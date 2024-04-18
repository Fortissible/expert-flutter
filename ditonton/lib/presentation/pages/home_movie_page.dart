import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/tv.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  bool _isTvSeriesContent = false;

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<MovieListBloc>()
          ..add(FetchOnAirMovie())
          ..add(FetchPopularMovie())
          ..add(FetchTopRatedMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                setState(() {
                  _isTvSeriesContent = false;
                });
                _isTvSeriesContent
                    ? Future.microtask((){
                      context.read<TvListBloc>()
                          ..add(FetchTopRatedTv())
                          ..add(FetchPopularTv())
                          ..add(FetchOnAirTv());
                    })
                    : Future.microtask((){
                      context.read<MovieListBloc>()
                          ..add(FetchTopRatedMovie())
                          ..add(FetchOnAirMovie())
                          ..add(FetchPopularMovie());
                    });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.live_tv_outlined),
              title: Text('TV Series'),
              onTap: () {
                setState(() {
                  _isTvSeriesContent = true;
                });
                _isTvSeriesContent
                    ? Future.microtask((){
                        context.read<TvListBloc>()
                          ..add(FetchTopRatedTv())
                          ..add(FetchPopularTv())
                          ..add(FetchOnAirTv());
                      })
                    : Future.microtask((){
                        context.read<MovieListBloc>()
                          ..add(FetchTopRatedMovie())
                          ..add(FetchOnAirMovie())
                          ..add(FetchPopularMovie());
                      });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton - ${_isTvSeriesContent ? 'TV Series' : 'Movies'}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  SearchPage.ROUTE_NAME,
                  arguments: _isTvSeriesContent ? "Tv Series" : "Movies",
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isTvSeriesContent
                  ? _buildSubHeading(
                    title: 'Now Playing',
                    onTap: () => Navigator.pushNamed(context, NowPlayingTvPage.ROUTE_NAME),
                  )
                  : Text(
                    'Now Playing',
                    style: kHeading6,
                  ),
              _isTvSeriesContent
                ? BlocBuilder<TvListBloc, TvListState>(
                    builder: (BuildContext context, TvListState tvListState) {
                      final state = tvListState.tvOnAirState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvOnAir!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvOnAirMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.movieOnAirState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.movieOnAir!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.movieOnAirMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                _isTvSeriesContent
                  ? Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME)
                  : Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              _isTvSeriesContent
                ? BlocBuilder<TvListBloc, TvListState>(
                    builder: (BuildContext context, TvListState tvListState) {
                      final state = tvListState.tvPopularState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvPopular!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvPopularMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.moviePopularState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.moviePopular!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.moviePopularMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                _isTvSeriesContent
                    ? Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME)
                    : Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              _isTvSeriesContent
                ? BlocBuilder<TvListBloc, TvListState>(
                    builder: (BuildContext context, TvListState tvListState) {
                      final state = tvListState.tvTopRatedState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvTopRated!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvTopRatedMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.movieTopRatedState;
                      if (state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.movieTopRated!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.movieTopRatedMsg}');
                      } else {
                        return Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, Function()? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvSeries;

  TvList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }

}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
