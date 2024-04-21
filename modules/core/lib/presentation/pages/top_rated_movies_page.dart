import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({super.key});

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieTopRatedBloc>().add(
          const FetchMoviesTopRated()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (ctx, state){
            final topRatedState = state.movieTopRatedState;
            if (topRatedState == RequestState.Loading) {
              return const Center(
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
              return const Center(
                key: Key('empty_message'),
                child: Text("No top rated Movies found!"),
              );
            }
            else if (topRatedState == RequestState.Error){
              return Center(
                key: const Key('error_message'),
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
