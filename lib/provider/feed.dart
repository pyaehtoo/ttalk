import 'package:flutter/cupertino.dart';
import 'package:teatalk/network/res/post_res.dart';
import 'package:teatalk/util/extension.dart';
import 'package:teatalk/util/log.dart';

import '../model/post.dart';
import '../network/api/app_layer.dart';

class FeedProvider extends ChangeNotifier {
  int _arenaCount = 0;
  int _flashCount = 0;
  int _flashStart = 0;
  int _arenaStart = 0;
  List<PostModel> _myArena = [];
  List<PostModel> _freshFlash = [];
  ScrollController myAreaScrollController = ScrollController();
  ScrollController freshFlashScrollController = ScrollController();

  Future<void> onRefreshAndScrollToTop({required String? userToken}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (myAreaScrollController.hasClients) {
      final topPosition = myAreaScrollController.position.minScrollExtent;
      // myAreaScrollController.jumpTo(topPosition);
      myAreaScrollController.animateTo(topPosition,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }

    if (freshFlashScrollController.hasClients) {
      final freshFlashTopPosition =
          freshFlashScrollController.position.minScrollExtent;
      // freshFlashScrollController.jumpTo(freshFlashTopPosition);
      freshFlashScrollController.animateTo(freshFlashTopPosition,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }

    await loadPosts(
        token: userToken, isMyArena: true, refresh: true, notifyEmpty: true);
    await loadPosts(
        token: userToken, isMyArena: false, refresh: true, notifyEmpty: true);

    notifyListeners();
  }

  Future<List<PostModel>?> loadPosts({
    required String? token,
    bool isMyArena = true,
    bool refresh = false,
    bool notifyEmpty = false,
  }) async {
    if (refresh) {
      if (isMyArena) {
        _arenaStart = 0;
        _myArena = [];
      } else {
        _flashStart = 0;
        _freshFlash = [];
      }
      if (notifyEmpty) notifyListeners();
    }
    final PostRes? postRes = isMyArena
        ? await AppApi.instance.getMyArena(
            userToken: token,
            start: _arenaStart,
          )
        : await AppApi.instance.getFreshFlash(
            userToken: token,
            start: _flashStart,
          );
    if (postRes == null) return null;

    final tmpLoadedData = postRes.data ?? [];
    if (isMyArena) {
      _myArena.addAll(tmpLoadedData);
      _arenaStart = _myArena.length;
      _arenaCount = postRes.count ?? 0;
      Log.d("Loaded My Arena : ${_myArena.length}/$_arenaCount");
    } else {
      _freshFlash.addAll(tmpLoadedData);
      _flashStart = _freshFlash.length;
      _flashCount = postRes.count ?? 0;
      Log.d("Loaded Fresh Flash : ${_freshFlash.length}/$_flashCount");
    }
    notifyListeners();
    return tmpLoadedData;
  }

  List<PostModel> get myArena => _myArena;

  set myArena(List<PostModel> value) {
    _myArena = value;
    notifyListeners();
  }

  List<PostModel> get freshFlash => _freshFlash;

  set freshFlash(List<PostModel> value) {
    _freshFlash = value;
    notifyListeners();
  }

  int get flashCount => _flashCount;

  set flashCount(int value) {
    _flashCount = value;
    notifyListeners();
  }

  int get arenaCount => _arenaCount;

  set arenaCount(int value) {
    _arenaCount = value;
    notifyListeners();
  }
}
