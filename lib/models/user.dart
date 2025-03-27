class User {
  final int userID;
  final String nickname;
  final String abstract;
  final String avatar;
  final bool? recallMessage;
  final bool friendOnline;
  final bool sound;
  final bool secureLink;
  final bool savePwd;
  final int searchUser;
  final int verification;
  final String? verificationQuestion;

  User({
    required this.userID,
    required this.nickname,
    required this.abstract,
    required this.avatar,
    this.recallMessage,
    required this.friendOnline,
    required this.sound,
    required this.secureLink,
    required this.savePwd,
    required this.searchUser,
    required this.verification,
    this.verificationQuestion,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'] ?? 0,
      nickname: json['nickname']?.toString() ?? '',
      abstract: json['abstract']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      recallMessage: json['recallMessage'],
      friendOnline: json['friendOnline'] ?? false,
      sound: json['sound'] ?? true,
      secureLink: json['secureLink'] ?? false,
      savePwd: json['savePwd'] ?? false,
      searchUser: json['searchUser'] ?? 2,
      verification: json['verification'] ?? 2,
      verificationQuestion: json['verificationQuestion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'nickname': nickname,
      'abstract': abstract,
      'avatar': avatar,
      'recallMessage': recallMessage,
      'friendOnline': friendOnline,
      'sound': sound,
      'secureLink': secureLink,
      'savePwd': savePwd,
      'searchUser': searchUser,
      'verification': verification,
      'verificationQuestion': verificationQuestion,
    };
  }
} 