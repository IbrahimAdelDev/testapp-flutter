class PostModel {
  final String username;
  final String userImage;
  final String postImage;
  final String postContent;

  PostModel({
    required this.username,
    required this.userImage,
    required this.postImage,
    required this.postContent,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      username: json['username'],
      userImage: json['userImage'],
      postImage: json['postImage'],
      postContent: json['postContent'],
    );
  }
}
