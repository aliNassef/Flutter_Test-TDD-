import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:tdd_course/models/post_model.dart';
import 'package:tdd_course/repo/posts_repo.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._postsRepo) : super(PostsInitial());
  final PostsRepo _postsRepo;
  void loadPosts() async {
    emit(PostsLoading());
    try {
      var posts = await _postsRepo.getPosts();
      emit(PostsLoaded(posts: posts));
    } catch (e) {
      emit(PostsFailure(error: e.toString()));
    }
  }
}
