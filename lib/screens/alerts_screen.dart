// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../models/models.dart';
// import '../theme/app_theme.dart';
// import '../utils/auth_state.dart';

// class AlertsScreen extends StatelessWidget {
//   final Client client;
//   const AlertsScreen({super.key, required this.client});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthState>();
//     final alerts = auth.alerts;

//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         backgroundColor: AppTheme.background,
//         title: Row(
//           children: [
//             const Text('Alerts',
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: AppTheme.textPrimary)),
//             if (auth.unreadCount > 0) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: AppTheme.danger,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   '${auth.unreadCount}',
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ],
//           ],
//         ),
//         actions: [
//           if (auth.unreadCount > 0)
//             TextButton(
//               onPressed: auth.markAllRead,
//               child: const Text('Mark all read',
//                   style: TextStyle(color: AppTheme.primary, fontSize: 12)),
//             ),
//         ],
//       ),
//       body: alerts.isEmpty
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.check_circle_outline,
//                       color: AppTheme.success, size: 52),
//                   SizedBox(height: 16),
//                   Text('All Clear!',
//                       style: TextStyle(
//                           color: AppTheme.textPrimary,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600)),
//                   SizedBox(height: 6),
//                   Text('No expiry alerts at the moment.',
//                       style: TextStyle(
//                           color: AppTheme.textSecondary, fontSize: 13)),
//                 ],
//               ),
//             )
//           : ListView.separated(
//               padding: const EdgeInsets.all(20),
//               itemCount: alerts.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 10),
//               itemBuilder: (context, index) {
//                 final alert = alerts[index];
//                 final isRead = auth.isAlertRead(alert.id);
//                 return _AlertCard(
//                   alert: alert,
//                   isRead: isRead,
//                   onTap: () => auth.markAlertRead(alert.id),
//                 );
//               },
//             ),
//     );
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AppAlert alert;
//   final bool isRead;
//   final VoidCallback onTap;
//   const _AlertCard(
//       {required this.alert, required this.isRead, required this.onTap});

//   Color get _severityColor => switch (alert.severity) {
//         ExpiryStatus.expired => AppTheme.danger,
//         ExpiryStatus.critical => AppTheme.danger,
//         ExpiryStatus.expiringSoon => AppTheme.warning,
//         ExpiryStatus.active => AppTheme.success,
//       };

//   Color get _severityBg => switch (alert.severity) {
//         ExpiryStatus.expired => AppTheme.dangerDim,
//         ExpiryStatus.critical => AppTheme.dangerDim,
//         ExpiryStatus.expiringSoon => AppTheme.warningDim,
//         ExpiryStatus.active => AppTheme.successDim,
//       };

//   IconData get _severityIcon => switch (alert.severity) {
//         ExpiryStatus.expired => Icons.error_outline,
//         ExpiryStatus.critical => Icons.warning_amber_rounded,
//         ExpiryStatus.expiringSoon => Icons.timer_outlined,
//         ExpiryStatus.active => Icons.check_circle_outline,
//       };

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isRead ? AppTheme.surfaceElevated : AppTheme.surface,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isRead
//                 ? AppTheme.surfaceBorder
//                 : _severityColor.withOpacity(0.3),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 38,
//               height: 38,
//               decoration: BoxDecoration(
//                 color: _severityBg,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(_severityIcon, color: _severityColor, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           alert.title,
//                           style: TextStyle(
//                             color: isRead
//                                 ? AppTheme.textSecondary
//                                 : AppTheme.textPrimary,
//                             fontSize: 13,
//                             fontWeight:
//                                 isRead ? FontWeight.w400 : FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       if (!isRead)
//                         Container(
//                           width: 7,
//                           height: 7,
//                           decoration: BoxDecoration(
//                             color: _severityColor,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     alert.message,
//                     style: const TextStyle(
//                         color: AppTheme.textMuted, fontSize: 12, height: 1.4),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     timeago.format(alert.createdAt),
//                     style: const TextStyle(
//                         color: AppTheme.textMuted, fontSize: 10),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:client_support_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:timeago/timeago.dart' as timeago;

class StoryModel {
  final String id;
  final String userName;
  final String avatarUrl;
  final List<String> imageUrls;
  final bool isOwn;
  final bool isSeen;
  File? localImage;

  StoryModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    this.imageUrls = const [],
    this.isOwn = false,
    this.isSeen = false,
    this.localImage,
  });
}

class PostModel {
  final String id;
  final String userName;
  final String avatarUrl;
  final String caption;
  final List<String> imageUrls;
  final int likes;
  final int comments;
  final DateTime postedAt;

  const PostModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.caption,
    required this.imageUrls,
    required this.likes,
    required this.comments,
    required this.postedAt,
  });
}

final List<StoryModel> _mockStories = [
  StoryModel(
    id: 'own',
    userName: 'Your Story',
    avatarUrl:
        'https://hips.hearstapps.com/hmg-prod/images/henry-cavill-superman-1536761926.jpg?crop=0.49925925925925924xw:1xh;center,top&resize=640:*',
    isOwn: true,
  ),
  // StoryModel(
  //   id: 's1',
  //   userName: 'Priya M.',
  //   avatarUrl: 'https://i.pravatar.cc/150?img=9',
  //   imageUrls: [
  //     'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600',
  //     'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600',
  //   ],
  // ),
  // StoryModel(
  //   id: 's2',
  //   userName: 'Arjun K.',
  //   avatarUrl: 'https://i.pravatar.cc/150?img=12',
  //   imageUrls: [
  //     'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=600',
  //   ],
  // ),
  // StoryModel(
  //   id: 's3',
  //   userName: 'Sneha R.',
  //   avatarUrl: 'https://i.pravatar.cc/150?img=25',
  //   imageUrls: [
  //     'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?w=600',
  //     'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
  //   ],
  // ),
  // StoryModel(
  //   id: 's4',
  //   userName: 'Rohan V.',
  //   avatarUrl: 'https://i.pravatar.cc/150?img=33',
  //   imageUrls: [
  //     'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=600',
  //   ],
  // ),
  // StoryModel(
  //   id: 's5',
  //   userName: 'Meera J.',
  //   avatarUrl: 'https://i.pravatar.cc/150?img=47',
  //   imageUrls: [
  //     'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=600',
  //     'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=600',
  //     'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=600',
  //   ],
  // ),
];

final List<PostModel> _mockPosts = [
  PostModel(
    id: 'p1',
    userName: 'Priya M.',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    caption:
        'Golden hour in the mountains 🏔️ Nothing beats this view after a long hike.',
    imageUrls: [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800',
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
    ],
    likes: 1243,
    comments: 58,
    postedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  PostModel(
    id: 'p2',
    userName: 'Arjun K.',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    caption: 'Weekend getaway 🌊 The sea always has an answer.',
    imageUrls: [
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800',
    ],
    likes: 872,
    comments: 34,
    postedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  PostModel(
    id: 'p3',
    userName: 'Sneha R.',
    avatarUrl: 'https://i.pravatar.cc/150?img=25',
    caption: 'Forest therapy 🌿 Switch off and breathe.',
    imageUrls: [
      'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800',
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
      'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?w=800',
      'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=800',
    ],
    likes: 2110,
    comments: 91,
    postedAt: DateTime.now().subtract(const Duration(hours: 9)),
  ),
  PostModel(
    id: 'p4',
    userName: 'Rohan V.',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    caption: 'Desert sunrise 🌅 Worth every early alarm.',
    imageUrls: [
      'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800',
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800',
    ],
    likes: 649,
    comments: 22,
    postedAt: DateTime.now().subtract(const Duration(hours: 14)),
  ),
  PostModel(
    id: 'p5',
    userName: 'Meera J.',
    avatarUrl: 'https://i.pravatar.cc/150?img=47',
    caption: 'Lakeside mornings ☕ Still water, still mind.',
    imageUrls: [
      'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800',
      'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800',
      'https://images.unsplash.com/photo-1494500764479-0c8f2919a3d8?w=800',
    ],
    likes: 3041,
    comments: 145,
    postedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];

class AlertsScreen extends StatefulWidget {

  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AlertsScreen> {
  final ImagePicker _picker = ImagePicker();
  late List<StoryModel> _stories;
  late List<PostModel> _posts;
  final Set<String> _likedPosts = {};

  @override
  void initState() {
    super.initState();
    _stories = List.from(_mockStories);
    _posts = List.from(_mockPosts);
  }

  Future<void> _pickStoryImage() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null) return;
    setState(() {
      _stories[0] = StoryModel(
        id: 'own',
        userName: 'Your Story',
        avatarUrl: _stories[0].avatarUrl,
        isOwn: true,
        localImage: File(file.path),
      );
    });
  }

  void _openStory(StoryModel story) {
    if (story.isOwn && story.imageUrls.isEmpty && story.localImage == null) {
      _pickStoryImage();
      return;
    }
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _StoryViewerScreen(story: story),
      ),
    );
  }

  void _toggleLike(String postId) {
    setState(() {
      if (_likedPosts.contains(postId)) {
        _likedPosts.remove(postId);
      } else {
        _likedPosts.add(postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Moments',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                letterSpacing: -0.8,
              ),
            ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.add_box_outlined,
            //         color: Color(0xFF0F172A), size: 26),
            //     onPressed: _pickStoryImage,
            //   ),
            //   IconButton(
            //     icon: const Icon(Icons.near_me_outlined,
            //         color: Color(0xFF0F172A), size: 24),
            //     onPressed: () {},
            //   ),
            //   const SizedBox(width: 4),
            // ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFEEEEEE)),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _stories.length,
                  itemBuilder: (_, i) => _StoryThumbnail(
                    story: _stories[i],
                    onTap: () => _openStory(_stories[i]),
                  ),
                ),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(height: 8, color: const Color(0xFFF1F1F1)),
          // ),
          SliverList.separated(
            itemCount: _posts.length,
            separatorBuilder: (_, __) =>
                Container(height: 8, color: const Color(0xFFF1F1F1)),
            itemBuilder: (_, i) => _PostCard(
              post: _posts[i],
              isLiked: _likedPosts.contains(_posts[i].id),
              onLike: () => _toggleLike(_posts[i].id),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StoryThumbnail extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;
  const _StoryThumbnail({required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasStory =
        story.imageUrls.isNotEmpty || story.localImage != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 4),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (hasStory && !story.isSeen)
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFD5949),
                          Color(0xFFD6249F),
                          Color(0xFF285AEB),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: story.localImage != null
                        ? Image.file(story.localImage!, fit: BoxFit.cover)
                        : Image.network(
                            story.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE5E7EB),
                              child: const Icon(Icons.person,
                                  color: Color(0xFF9CA3AF)),
                            ),
                          ),
                  ),
                ),
                if (story.isOwn)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              story.userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: story.isSeen
                    ? const Color(0xFFADB5BD)
                    : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryViewerScreen extends StatefulWidget {
  final StoryModel story;
  const _StoryViewerScreen({required this.story});

  @override
  State<_StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<_StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _current = 0;
  late AnimationController _progressController;

  List<String> get _images => widget.story.imageUrls;
  int get _total => _images.isNotEmpty ? _images.length : 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((s) {
        if (s == AnimationStatus.completed) _next();
      });
    _progressController.forward();
  }

  void _next() {
    if (_current < _total - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() => _current++);
      _progressController
        ..reset()
        ..forward();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _prev() {
    if (_current > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() => _current--);
      _progressController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (d) {
          final w = MediaQuery.of(context).size.width;
          d.globalPosition.dx < w / 2 ? _prev() : _next();
        },
        onVerticalDragEnd: (d) {
          if (d.primaryVelocity != null && d.primaryVelocity! > 300) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _total,
              itemBuilder: (_, i) {
                if (widget.story.localImage != null) {
                  return Image.file(widget.story.localImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity);
                }
                return Image.network(
                  _images[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)),
                );
              },
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xAA000000),
                      Colors.transparent,
                      Colors.transparent,
                      Color(0x66000000),
                    ],
                    stops: [0, 0.15, 0.75, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: List.generate(_total, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: i < _current
                          ? Container(
                              color: Colors.white,
                              height: 2.5,
                            )
                          : i == _current
                              ? AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (_, __) => FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _progressController.value,
                                    child: Container(
                                      color: Colors.white,
                                      height: 2.5,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 14,
              right: 14,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(widget.story.avatarUrl,
                        width: 36, height: 36, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.story.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final PostModel post;
  final bool isLiked;
  final VoidCallback onLike;

  const _PostCard({
    required this.post,
    required this.isLiked,
    required this.onLike,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  int _currentImage = 0;
  final PageController _imgController = PageController();

  @override
  void dispose() {
    _imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return PopScope(
          canPop: false,
    onPopInvoked: (bool didPop) async {
      if (didPop) return;
      
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Exit'),
            ),
          ],
        ),
      );
      
      if (shouldExit == true) {
        SystemNavigator.pop();
      }
    },
      child: Container(
        // color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // ClipOval(
                  //   child: Image.network(post.avatarUrl,
                  //       width: 36, height: 36, fit: BoxFit.cover),
                  // ),
                  // const SizedBox(width: 10),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         post.userName,
                  //         style: const TextStyle(
                  //           fontSize: 13.5,
                  //           fontWeight: FontWeight.w700,
                  //           color: Color(0xFF0F172A),
                  //         ),
                  //       ),
                  //       Text(
                  //         timeago.format(post.postedAt),
                  //         style: const TextStyle(
                  //           fontSize: 11,
                  //           color: Color(0xFFADB5BD),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const Icon(Icons.more_horiz,
                  //     color: Color(0xFF6B7280), size: 22),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: _imgController,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemCount: post.imageUrls.length,
                    itemBuilder: (_, i) => Image.network(
                      post.imageUrls[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (_, child, p) => p == null
                          ? child
                          : Container(
                              color: const Color(0xFFF3F4F6),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFD1D5DB),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE5E7EB),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Color(0xFF9CA3AF), size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                if (post.imageUrls.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        post.imageUrls.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentImage == i ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImage == i
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (post.imageUrls.length > 1)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentImage + 1}/${post.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  // _ActionBtn(
                  //   icon: widget.isLiked
                  //       ? Icons.favorite_rounded
                  //       : Icons.favorite_border_rounded,
                  //   color: widget.isLiked
                  //       ? const Color(0xFFEF4444)
                  //       : const Color(0xFF374151),
                  //   onTap: widget.onLike,
                  // ),
                  SizedBox(width: 4),
                  // _ActionBtn(
                  //   icon: Icons.chat_bubble_outline_rounded,
                  //   color: const Color(0xFF374151),
                  //   onTap: () {},
                  // ),
                  // const SizedBox(width: 4),
                  // _ActionBtn(
                  //   icon: Icons.send_outlined,
                  //   color: const Color(0xFF374151),
                  //   onTap: () {},
                  // ),
                  // const Spacer(),
                  // _ActionBtn(
                  //   icon: Icons.bookmark_border_rounded,
                  //   color: const Color(0xFF374151),
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
      
            // ── Likes ────────────────────────────────────────────────────────
            // Padding(
            //   padding: const EdgeInsets.only(left: 14, right: 14, bottom: 4),
            //   child: Text(
            //     '${_formatCount(post.likes + (widget.isLiked ? 1 : 0))} likes',
            //     style: const TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.w700,
            //       color: Color(0xFF0F172A),
            //     ),
            //   ),
            // ),
      
            // ── Caption ──────────────────────────────────────────────────────
            // Padding(
            //   padding: const EdgeInsets.only(left: 14, right: 14, bottom: 4),
            //   child: RichText(
            //     text: TextSpan(
            //       children: [
            //         TextSpan(
            //           text: '${post.userName}  ',
            //           style: const TextStyle(
            //             fontSize: 13,
            //             fontWeight: FontWeight.w700,
            //             color: Color(0xFF0F172A),
            //           ),
            //         ),
            //         TextSpan(
            //           text: post.caption,
            //           style: const TextStyle(
            //             fontSize: 13,
            //             color: Color(0xFF374151),
            //             height: 1.4,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
      
            // ── Comments hint ────────────────────────────────────────────────
            // Padding(
            //   padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
            //   child: Text(
            //     'View all ${post.comments} comments',
            //     style: const TextStyle(
            //       fontSize: 12.5,
            //       color: Color(0xFFADB5BD),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // String _formatCount(int n) {
  //   if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  //   return '$n';
  // }
}

// class _ActionBtn extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;

//   const _ActionBtn({
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: Icon(icon, color: color, size: 26),
//       ),
//     );
//   }
// }
