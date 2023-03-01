class WhoToFollow {
  final String name;
  final String username;
  final String imageUrl;
  final bool isFollowing;
  final int id;

  const WhoToFollow({
    required this.name,
    required this.imageUrl,
    required this.username,
    required this.id,
    this.isFollowing = false,
  });
}
