import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

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
          ..add(const FetchOnAirMovie())
          ..add(const FetchPopularMovie())
          ..add(const FetchTopRatedMovie());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                setState(() {
                  _isTvSeriesContent = false;
                });
                _isTvSeriesContent
                    ? Future.microtask((){
                      context.read<TvListBloc>()
                          ..add(const FetchTopRatedTv())
                          ..add(const FetchPopularTv())
                          ..add(const FetchOnAirTv());
                    })
                    : Future.microtask((){
                      context.read<MovieListBloc>()
                          ..add(const FetchTopRatedMovie())
                          ..add(const FetchOnAirMovie())
                          ..add(const FetchPopularMovie());
                    });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv_outlined),
              title: const Text('TV Series'),
              onTap: () {
                setState(() {
                  _isTvSeriesContent = true;
                });
                _isTvSeriesContent
                    ? Future.microtask((){
                        context.read<TvListBloc>()
                          ..add(const FetchTopRatedTv())
                          ..add(const FetchPopularTv())
                          ..add(const FetchOnAirTv());
                      })
                    : Future.microtask((){
                        context.read<MovieListBloc>()
                          ..add(const FetchTopRatedMovie())
                          ..add(const FetchOnAirMovie())
                          ..add(const FetchPopularMovie());
                      });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
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
                  SEARCH_ROUTE,
                  arguments: _isTvSeriesContent ? "Tv Series" : "Movies",
              );
            },
            icon: const Icon(Icons.search),
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
                    onTap: () => Navigator.pushNamed(context, NOW_PLAYING_TV_ROUTE),
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvOnAir!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvOnAirMsg}');
                      } else {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.movieOnAirState;
                      if (state == RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.movieOnAir!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.movieOnAirMsg}');
                      } else {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                _isTvSeriesContent
                  ? Navigator.pushNamed(context, POPULAR_TV_ROUTE)
                  : Navigator.pushNamed(context, POPULAR_MOVIES_ROUTE),
              ),
              _isTvSeriesContent
                ? BlocBuilder<TvListBloc, TvListState>(
                    builder: (BuildContext context, TvListState tvListState) {
                      final state = tvListState.tvPopularState;
                      if (state == RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvPopular!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvPopularMsg}');
                      } else {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.moviePopularState;
                      if (state == RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.moviePopular!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.moviePopularMsg}');
                      } else {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                _isTvSeriesContent
                    ? Navigator.pushNamed(context, TOP_RATED_TV_ROUTE)
                    : Navigator.pushNamed(context, TOP_RATED_ROUTE),
              ),
              _isTvSeriesContent
                ? BlocBuilder<TvListBloc, TvListState>(
                    builder: (BuildContext context, TvListState tvListState) {
                      final state = tvListState.tvTopRatedState;
                      if (state == RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return TvList(tvListState.tvTopRated!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${tvListState.tvTopRatedMsg}');
                      } else {
                        return const Expanded(
                          child: SizedBox(),
                        );
                      }
                    }
                  )
                : BlocBuilder<MovieListBloc, MovieListState>(
                    builder: (BuildContext context, MovieListState movieListState) {
                      final state = movieListState.movieTopRatedState;
                      if (state == RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state == RequestState.Loaded) {
                        return MovieList(movieListState.movieTopRated!);
                      } else if (state == RequestState.Error) {
                        return Text('Error happened: ${movieListState.movieTopRatedMsg}');
                      } else {
                        return const Expanded(
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
          child: const Padding(
            padding: EdgeInsets.all(8.0),
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

  const TvList(this.tvSeries, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  DETAIL_TV_ROUTE,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  MOVIE_DETAIL_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
