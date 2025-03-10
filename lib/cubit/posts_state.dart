part of 'posts_cubit.dart';

@immutable
sealed class PostsState extends Equatable {
  const PostsState();
}

final class PostsInitial extends PostsState {
  @override
  List<Object?> get props => [];
}

final class PostsLoading extends PostsState {
  @override
  List<Object?> get props => [];
}

final class PostsFailure extends PostsState {
  final String error;

  const PostsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

final class PostsLoaded extends PostsState {
  final List<PostModel> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object?> get props => [posts];
}
