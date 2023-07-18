import 'package:flutter/cupertino.dart';
import 'package:teatalk/network/api/app_layer.dart';
import 'package:teatalk/network/res/location_res.dart';

import '../network/res/reaction_res.dart';

class AppProvider extends ChangeNotifier {
  List<LocationData> _locations = [];
  List<ReactionData> _reactions = [];

  void loadLocations() async {
    if (_locations.isNotEmpty) return;
    final LocationRes? res = await AppApi.instance.getLocations();
    _locations = res?.data ?? [];
  }

  void loadReactions(BuildContext context) async {
    if (_reactions.isNotEmpty) return;
    final ReactionRes? res =
        await AppApi.instance.getReactions(context: context);
    _reactions = res?.data ?? [];
  }

  List<ReactionData> get reactions => _reactions;

  LocationData? findLocationById(int? id) {
    if (id == null) return null;
    for (final location in _locations) {
      if (location.id == id) return location;
    }
    return null;
  }

  ReactionData? findReaction(String key) {
    for (final reaction in _reactions) {
      if (reaction.key == key) return reaction;
    }
    return null;
  }
}
