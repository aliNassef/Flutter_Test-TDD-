import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_course/cubit/posts_cubit.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/presentation/post_details_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    // تحميل المنشورات عند بدء الصفحة
    context.read<PostsCubit>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المنشورات'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          return switch (state) {
            PostsInitial() => const Center(
                child: Text('اضغط على زر التحديث لتحميل المنشورات'),
              ),
            PostsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            PostsLoaded(posts: final posts) => _buildPostsList(posts),
            PostsFailure(error: final error) => _buildErrorWidget(error),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PostsCubit>().loadPosts();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildPostsList(List<PostModel> posts) {
    return posts.isEmpty
        ? const Center(child: Text('لا توجد منشورات'))
        : RefreshIndicator(
            onRefresh: () async {
              context.read<PostsCubit>().loadPosts();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            ),
          );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ أثناء تحميل المنشورات',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PostsCubit>().loadPosts();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // التنقل إلى صفحة تفاصيل المنشور
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailsPage(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      '${post.id}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.body,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المستخدم: ${post.userId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () {
                      // التنقل إلى صفحة تفاصيل المنشور
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailsPage(post: post),
                        ),
                      );
                    },
                    child: const Text('قراءة المزيد'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
