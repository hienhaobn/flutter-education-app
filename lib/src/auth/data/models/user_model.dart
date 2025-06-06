import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.points,
    required super.fullName,
    super.groupIds,
    super.enrolledCourseIds,
    super.following,
    super.followers,
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
    : this(uid: '', email: '', points: 0, fullName: '');

  LocalUserModel.fromMap(DataMap map)
    : super(
        uid: map['uid'] as String,
        email: map['email'] as String,
        points: (map['points'] as num).toInt(),
        fullName: map['fullName'] as String,
        // TODO: sometimes it doesnt work it returns a list of maps
        // groupIds: map['groupIds'] as List<String>,
        groupIds: (map['groupIds'] as List<dynamic>).cast<String>(),
        enrolledCourseIds:
            (map['enrolledCourseIds'] as List<dynamic>).cast<String>(),
        following: (map['following'] as List<dynamic>).cast<String>(),
        followers: (map['followers'] as List<dynamic>).cast<String>(),
        profilePic: map['profilePic'] as String?,
        bio: map['bio'] as String?,
      );

  LocalUser copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? fullName,
    List<String>? groupIds,
    List<String>? enrolledCourseIds,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      fullName: fullName ?? this.fullName,
      groupIds: groupIds ?? this.groupIds,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  DataMap toMap() => {
    'uid': uid,
    'email': email,
    'points': points,
    'fullName': fullName,
    'groupIds': groupIds,
    'enrolledCourseIds': enrolledCourseIds,
    'following': following,
    'followers': followers,
    'profilePic': profilePic,
    'bio': bio,
  };
}
