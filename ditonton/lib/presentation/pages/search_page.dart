import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final String searchType;

  SearchPage({
    required this.searchType
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search $searchType'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                searchType == "Movies"
                    // ? Provider.of<MovieSearchNotifier>(context, listen: false)
                    // .fetchMovieSearch(query)
                    // : Provider.of<TvSearchNotifier>(context, listen: false)
                    // .fetchSearchTv(query);
                    ? context.read<MovieSearchBloc>().add(
                      SearchMovie(query: query)
                    )
                    : context.read<TvSearchBloc>().add(
                      SearchTv(query: query)
                    );
              },
              decoration: InputDecoration(
                hintText: 'Search $searchType title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            searchType == "Movies"
              ? BlocBuilder<MovieSearchBloc, MovieSearchState>(
                  builder: (ctx, state){
                    final searchState = state.movieSearchState;
                    if (searchState == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if (searchState == RequestState.Loaded) {
                      final result = state.movieSearch!;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            final movie = result[index];
                            return MovieCard(movie);
                          },
                        ),
                      );
                    }
                    else if (searchState == RequestState.Empty ) {
                      return Center(
                        key: Key('empty_message'),
                        child: Text("Movies not found"),
                      );
                    }
                    else if (searchState == RequestState.Error ) {
                      return Center(
                        key: Key('error_message'),
                        child: Text(state.movieSearchMsg),
                      );
                    }
                    else {
                      return const SizedBox();
                    }
                  }
                )
              : BlocBuilder<TvSearchBloc, TvSearchState>(
                  builder: (ctx, state){
                    final searchState = state.tvSearchState;
                    if (searchState == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    else if (searchState == RequestState.Loaded) {
                      final result = state.tvSearch!;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final tv = result[index];
                            return TvCard(tv);
                          },
                          itemCount: result.length,
                        ),
                      );
                    }
                    else if (searchState == RequestState.Empty ) {
                      return Center(
                        key: Key('empty_message'),
                        child: Text("Movies not found"),
                      );
                    }
                    else if (searchState == RequestState.Error ) {
                      return Center(
                        key: Key('error_message'),
                        child: Text(state.tvSearchMsg),
                      );
                    }
                    else {
                      return const SizedBox();
                    }
                  }
                ),
          ],
        ),
      ),
    );
  }
}
