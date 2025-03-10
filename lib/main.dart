import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_course/core/services/network_service_impl.dart';
import 'package:tdd_course/core/theme/app_theme.dart';
import 'package:tdd_course/cubit/posts_cubit.dart';
import 'package:tdd_course/datasource/remote_datasource.dart';
import 'package:tdd_course/repo/posts_repo_impl.dart';

import 'presentation/post_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق المنشورات',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => PostsCubit(
          PostsRepoImpl(
            datasource: RemoteDatasourceImpl(
              networkService: NetworkServiceImpl(),
            ),
          ),
        ),
        child: const PostsPage(),
      ),
    );
  }
}
