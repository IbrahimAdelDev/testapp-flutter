import 'package:flutter/material.dart';
import '../services/fetch_posts_service.dart';
import '../models/post_model.dart';
import '../widgets/app_drawer.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = PostService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تجارب النحالين', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: const Color(0xFF222222),
        iconTheme: const IconThemeData(
          // 👈 هنا
          color: Color.fromARGB(255, 255, 255, 255), // لون الأيقونة المطلوب
        ),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<PostModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'فشل في تحميل البيانات',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _postsFuture = PostService.fetchPosts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFBD31),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }

            final posts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(post.userImage),
                          radius: 24,
                        ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              post.username,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200, // 👈 اختياري: لتحديد ارتفاع ثابت للصورة
                          child: Image.network(
                            post.postImage,
                            fit: BoxFit.cover, // ✅ تغطية الحاوية
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        post.postContent,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
