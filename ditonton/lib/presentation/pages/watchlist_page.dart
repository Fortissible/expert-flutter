import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
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
                  child: Consumer<WatchlistMovieNotifier>(
                    builder: (context, data, child) {
                      if (data.watchlistState == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (data.watchlistState == RequestState.Loaded) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final movie = data.watchlistMovies[index];
                            return MovieCard(movie);
                          },
                          itemCount: data.watchlistMovies.length,
                        );
                      } else {
                        return Center(
                          key: Key('error_message'),
                          child: Text(data.message),
                        );
                      }
                    },
                  ),
                ),
                Center(
                  child: Text(
                    "THIS IS TV Series WATCHLIST"
                  ),
                )
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Consumer<WatchlistTvNotifier>(
                //     builder: (context, data, child) {
                //       if (data.watchlistState == RequestState.Loading) {
                //         return Center(
                //           child: CircularProgressIndicator(),
                //         );
                //       } else if (data.watchlistState == RequestState.Loaded) {
                //         return ListView.builder(
                //           itemBuilder: (context, index) {
                //             final tv = data.watchlistTv[index];
                //             return TvCard(tv);
                //           },
                //           itemCount: data.watchlistTv.length,
                //         );
                //       } else {
                //         return Center(
                //           key: Key('error_message'),
                //           child: Text(data.watchlistTvErrorMsg),
                //         );
                //       }
                //     },
                //   ),
                // ),
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