enum PostPrivacy {
  onlyMe,
  friend,
  public;
}

extension FindPostPrivacyExtension on String? {
  PostPrivacy? getPrivacy() {
    if (this == null) return null;
    switch (this) {
      case "101":
        return PostPrivacy.onlyMe;
      case "102":
        return PostPrivacy.friend;
      case "103":
        return PostPrivacy.public;
    }
    return null;
  }
}

extension PostPrivacyExtension on PostPrivacy {
  static const codes = {
    PostPrivacy.friend: "102",
    PostPrivacy.public: "103",
    PostPrivacy.onlyMe: "101",
  };
  static const names = {
    PostPrivacy.friend: "Buddy",
    PostPrivacy.public: "Public",
    PostPrivacy.onlyMe: "Only me",
  };

  static const svgPaths = {
    PostPrivacy.friend: "assets/images/ic_friend_update.svg",
    PostPrivacy.public: "assets/images/ic_world_update.svg",
    PostPrivacy.onlyMe: "assets/images/ic_privacy_lock_update.svg",
  };

  //  static const svgPaths = {
  //   PostPrivacy.friend: "assets/images/ic_friend.svg",
  //   PostPrivacy.public: "assets/images/ic_world.svg",
  //   PostPrivacy.onlyMe: "assets/images/ic_privacy_lock.svg",
  // };

  String get code => codes[this]!;

  String get name => names[this]!;

  String get svgPath => svgPaths[this]!;
}
