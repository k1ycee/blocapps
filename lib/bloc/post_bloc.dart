import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';

import 'package:blocapps/bloc/models/unreal.dart';
import 'package:blocapps/bloc/loc.dart';

/// This class indicates that the post bloc class is going to  be taking the PostEvent as input an giving out PostState as output
class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({@required this.httpClient});
/// This transform removes any post that comes in before the stipulated time of 500 milliseconds so as to avoid spamming the API unnecessarily which is a good thing
  /// So anything that is earlier that 500 milliseconds is skipped then it goes to the very next post in the list of posts
  @override
  Stream<PostState> transformEvents(
      Stream<PostEvent> events,
      Stream<PostState> Function(PostEvent event) next,
      ) {
    return super.transformEvents(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }
/// We're setting the initial state of the app here to Uninitialized
  @override
  get initialState => PostUninitialized();
/// This where we map event to states take this to be like the "brains"(remember from the documentation)
  @override
  Stream<PostState> mapEventToState(event) async* {
    final currentState = state;
    /// If you remember the Fetch class was an empty class so this is like the initialization of the fetch class
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
      /// Logic here checks if the currentState is PostUninitialized and if it is this stream is to yield a stream of basically nothing
        if (currentState is PostUninitialized) {
          final posts = await _fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
        }
    /// Logic here checks to see if currentState is PostLoaded and if it is it awaits the _fetchPosts function and uses the ternary operator that checks if post is empty and yields hasReachedMax to true which in turn makes the app to not display nothing
        /// and if posts.isEmpty is false then the app displays the posts to the user (see it's like a "brain").
        if (currentState is PostLoaded) {
          final posts = await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostLoaded(
              posts: currentState.posts + posts, hasReachedMax: false);
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;
/// This function makes the network call the decodes the json and then serializes the json which would be presented in the app.
  Future<List<Unreal>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Unreal(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
