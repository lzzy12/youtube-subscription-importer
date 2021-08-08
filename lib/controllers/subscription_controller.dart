import 'dart:convert';

import 'package:get/get.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_browser.dart' as gauth;
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:youtube_migrator/models/creator.dart';
import 'package:youtube_migrator/models/user.dart';
import 'package:youtube_migrator/utils/keys.dart';

class SubscriptionController extends GetxController {
  final sourceSubscriptions = <Creator>[].obs;
  final targetSubscriptions = <Creator>[].obs;
  final _isLoadingSourceSubscription = false.obs;
  final _sourceLoginRequesting = false.obs;
  final _targetLoginRequesting = false.obs;
  final _subscribing = false.obs;

  bool get isLoadingSourceSubscription => _isLoadingSourceSubscription.value;

  bool get sourceLoginRequesting => _sourceLoginRequesting.value;

  bool get targetLoginRequesting => _targetLoginRequesting.value;

  bool get subscribing => _subscribing.value;
  Client? _targetClient;
  Rx<GoogleUser?> _sourceUser = Rx<GoogleUser?>(null);
  Rx<GoogleUser?> _targetUser = Rx<GoogleUser?>(null);

  Rx<GoogleUser?> get sourceUser => _sourceUser;

  Rx<GoogleUser?> get targetUser => _targetUser;

  Future<String?> _fetchSubscribers(client, List<Creator> array,
      [String? nextPageToken]) async {
    // returns the next page token
    if (client != null) {
      final youtubeClient = YouTubeApi(client);
      var sourceList = await youtubeClient.subscriptions.list(["snippet"],
          mine: true, pageToken: nextPageToken, maxResults: 500);
      sourceList.items?.forEach((element) {
        print(element.snippet?.resourceId);
        array.add(Creator(
            id: element.snippet?.resourceId?.channelId ?? "",
            name: element.snippet?.title ?? "",
            subscribersCountText:
            element.contentDetails?.totalItemCount.toString() ?? "",
            notificationOn: true,
            imageUrl: element.snippet?.thumbnails?.default_?.url ?? ""));
      });
      return sourceList.nextPageToken;
    }
  }

  Future<Client> _googleSignIn(List<String> scopes) async {
    final flow = await gauth.createImplicitBrowserFlow(
        gauth.ClientId(
            APIKeys.GoogleClientID,
            null),
        scopes);
    final creds = await flow.obtainAccessCredentialsViaUserConsent(force: true);
    return gauth.authenticatedClient(Client(), creds);
  }

  Future<GoogleUser> _getUserInfo(Client client) async {
    final res = await client
        .get(Uri.parse("https://www.googleapis.com/oauth2/v2/userinfo"));
    final map = jsonDecode(res.body);
    return GoogleUser(
        email: map['email'],
        name: map['name'],
        profilePic: map['picture'],
        id: map['id']);
  }

  Future<List<Creator>> _getSubscriptionList(Client authenticatedClient,
      GoogleUser? user) async {
    var array = <Creator>[];
    final box = await Hive.openBox('cache');
    final cacheArray = null; //box.get(user?.email);
    if (cacheArray != null)
      array = List.generate(cacheArray.length, (index) => cacheArray[index]);
    else {
      array = <Creator>[];
      String? nextPageToken =
      await _fetchSubscribers(authenticatedClient, array);

      while (nextPageToken != null) {
        nextPageToken =
        await _fetchSubscribers(authenticatedClient, array, nextPageToken);
      }
      box.put(user?.email, array);
    }
    print("${array[0].name}: ${array[0].id}\n ${array[1].name}: ${array[1].id}");
    return array;
  }

  Future<void> onSourceLoginClicked(
      void Function(String errorMsg) onError) async {
    try {
      if (!_sourceLoginRequesting.value) {
        _sourceLoginRequesting.value = true;
        _isLoadingSourceSubscription.value = true;
        final client = await _googleSignIn(
            ["email", "profile", YouTubeApi.youtubeReadonlyScope]);
        _sourceUser.value = await _getUserInfo(client);
        sourceSubscriptions.addAll(
            await _getSubscriptionList(client, sourceUser.value));
        _isLoadingSourceSubscription.value = false;
      }
    } on gauth.UserConsentException catch (e, f) {
      onError("Sign in cancelled by user");
    } on DetailedApiRequestError catch(e){
      onError(e.message?? "Something went wrong");
    } finally {
      _isLoadingSourceSubscription.value = false;
      _sourceLoginRequesting.value = false;
    }
  }

  Future<void> onTargetLoginClicked(
      void Function(String errorMsg) onError) async {
    try {
      if (!_targetLoginRequesting.value) {
        _targetLoginRequesting.value = true;
        final client =
        await _googleSignIn(["email", "profile", YouTubeApi.youtubeScope]);
        _targetClient = client;
        _targetUser.value = await _getUserInfo(client);
        targetSubscriptions.addAll(
            await _getSubscriptionList(client, targetUser.value));
      }
    } on gauth.UserConsentException catch (e) {
      onError("Sign In cancelled by user");
    } finally {
      _targetLoginRequesting.value = false;
    }
  }

  void addAllCreatorsToTargetClicked() async {
    if (targetSubscriptions.isEmpty)
      targetSubscriptions.addAll(sourceSubscriptions);
    else if (targetSubscriptions.length == sourceSubscriptions.length)
      return;
    else {
      for (var i in sourceSubscriptions) {
        if (!targetSubscriptions.contains(i)) targetSubscriptions.add(i);
      }
    }
  }

  void logoutTarget() {
    _targetClient = null;
    _targetUser.value = null;
    targetSubscriptions.clear();
  }

  void logoutSource() {
    _sourceUser.value = null;
    sourceSubscriptions.clear();
  }

  void deleteAllTargetItems() {
    targetSubscriptions.clear();
  }

  Future<void> subscribeChannelsToTarget(
      void Function(Creator creator, int count, int total) onProgress, void Function(String message) onError) async {
    _subscribing.value = true;
    try {
      final client = _targetClient;
      if (client != null) {
        for (var i = 0; i < targetSubscriptions.length; i++) {
          onProgress(targetSubscriptions[i], i + 1, targetSubscriptions.length);
          try {
            await YouTubeApi(client).subscriptions.insert(
                Subscription(
                    id: targetSubscriptions[i].id,
                    snippet: SubscriptionSnippet(
                        resourceId:
                        ResourceId(channelId: targetSubscriptions[i].id))),
                ["snippet"]);
          } on DetailedApiRequestError catch (e) {
            if (e.errors[0].reason == "subscriptionDuplicate") {
              print("Already subscribed to ${targetSubscriptions[i]
                  .name}; Skipping");
              continue;
            }
            print("${e.errors[0].message}: ${e.errors[0].reason}");
            print(e.message);
            break;
          }
        }
      }
    } finally {
      _subscribing.value = false;
    }
  }
}
