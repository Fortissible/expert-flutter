import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/tv_card_list.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieWatchlistBloc>().add(
          FetchMovieWatchlist()
      );
      context.read<TvWatchlistBloc>().add(
          FetchTvWatchlist()
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<MovieWatchlistBloc>().add(
        FetchMovieWatchlist()
    );
    context.read<TvWatchlistBloc>().add(
        FetchTvWatchlist()
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Watchlist'),
            bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.movie_sharp),
                    text: "Movies",
                  ),
                  Tab(
                    icon: Icon(Icons.live_tv),
                    text: "TV Series",
                  )
                ]
            ),
          ),
          body: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
                    builder: (context, state) {
                      final watchlistState = state.movieWatchlistState;
                      if (watchlistState == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else if (watchlistState == RequestState.Loaded) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final movie = state.movieWatchlist![index];
                            return MovieCard(movie);
                          },
                          itemCount: state.movieWatchlist!.length,
                        );
                      }
                      else if (watchlistState == RequestState.Empty){
                        return Center(
                          key: Key('empty_msg_movie'),
                          child: Text(
                            "Watchlist Movies is empty,\nAdd new watchlist from movies screen",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      else if (watchlistState == RequestState.Error){
                        return Center(
                          key: Key('error_message_movie'),
                          child: Text(state.movieWatchlistMsg),
                        );
                      }
                      else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
                    builder: (context, state) {
                      final watchlistState = state.tvWatchlistState;
                      if (watchlistState == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      else if (watchlistState == RequestState.Loaded) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final tv = state.tvWatchlist![index];
                            return TvCard(tv);
                          },
                          itemCount: state.tvWatchlist!.length,
                        );
                      }
                      else if (watchlistState == RequestState.Empty){
                        return Center(
                          key: Key('empty_msg_tv'),
                          child: Text(
                            "Watchlist TV Series is empty,\nAdd new watchlist from TV Series screen",
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      else if (watchlistState == RequestState.Error){
                        return Center(
                          key: Key('error_message_tv'),
                          child: Text(state.tvWatchlistMsg),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                )
              ]
          )
        )
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
