import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieTopRatedBloc>().add(
          FetchMoviesTopRated()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (ctx, state){
            final topRatedState = state.movieTopRatedState;
            if (topRatedState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (topRatedState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movieTopRated![index];
                  return MovieCard(movie);
                },
                itemCount: state.movieTopRated!.length,
              );
            }
            else if (topRatedState == RequestState.Empty){
              return Center(
                key: Key('empty_message'),
                child: Text("No top rated Movies found!"),
              );
            }
            else if (topRatedState == RequestState.Error){
              return Center(
                key: Key('error_message'),
                child: Text(state.movieTopRatedMsg),
              );
            }
            else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
