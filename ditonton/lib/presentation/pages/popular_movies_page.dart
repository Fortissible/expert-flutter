import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MoviePopularBloc>().add(
          FetchMoviesPopular()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (ctx, state){
            final popularState = state.moviePopularState;
            if (popularState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (popularState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.moviePopular![index];
                  return MovieCard(movie);
                },
                itemCount: state.moviePopular!.length,
              );
            }
            else if (popularState == RequestState.Empty){
              return Center(
                key: Key('empty_message'),
                child: Text("No popular movies found!"),
              );
            }
            else if (popularState == RequestState.Error){
              return Center(
                key: Key('error_message'),
                child: Text(state.moviePopularMsg),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
