import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/search_res.dart';

enum SearchPageState { notSearch, searched, resultNotFound, resultFound }

class SearchProvider extends ChangeNotifier {
  SearchResData? searchRes;
  SearchPageState searchPageState = SearchPageState.notSearch;
  bool isLoading = false;

  Future<void> search({required String token,required String searchValue}) async {
    isLoading = true;
    notifyListeners();

    return AppApi.instance
        .getSearch(token: token, searchValue: searchValue)
        .then((value) {
      searchRes = value?.data;

      isLoading = false;
      if (searchRes == null) {
        searchPageState = SearchPageState.resultNotFound;
      } else if ((searchRes?.accounts?.isEmpty ?? false) &&
          (searchRes?.posts?.isEmpty ?? false)) {
        searchPageState = SearchPageState.resultNotFound;
      } else {
        searchPageState = SearchPageState.resultFound;
      }

      notifyListeners();
    });
  }
}
