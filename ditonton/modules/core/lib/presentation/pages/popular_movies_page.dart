import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MoviePopularBloc>().add(
          const FetchMoviesPopular()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (ctx, state){
            final popularState = state.moviePopularState;
            if (popularState == RequestState.Loading) {
              return const Center(
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
              return const Center(
                key: Key('empty_message'),
                child: Text("No popular movies found!"),
              );
            }
            else if (popularState == RequestState.Error){
              return Center(
                key: const Key('error_message'),
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
