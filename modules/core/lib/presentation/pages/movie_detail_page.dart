import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(FetchMovieDetail(movieId: widget.id));
      context.read<MovieDetailBloc>().add(LoadWatchlistMovie(movieId: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (BuildContext context, state) {
          if (state.movieDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.movieDetailState == RequestState.Loaded) {
            final movie = state.movieDetail!;
            return SafeArea(
              child: DetailContent(
                movie,
                state,
                state.movieWatchlistStatus,
              ),
            );
          } else if (state.movieDetailState == RequestState.Error){
            return Text(state.movieDetailMsg);
          } else {
            return Container();
          }
        },
      )
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final MovieDetailState state;
  final bool isAddedWatchlist;

  const DetailContent(this.movie, this.state, this.isAddedWatchlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kTextTheme.headlineSmall,
                            ),
                            BlocListener<MovieDetailBloc, MovieDetailState>(
                                child: const SizedBox(),
                                listenWhen: (oldState, newState) {
                                  return oldState.movieWatchlistMsg != newState.movieWatchlistMsg &&
                                      newState.movieWatchlistMsg != '';
                                },
                                listener: (ctx, state){
                                  final message = state.movieWatchlistMsg;

                                  if (message ==
                                      MovieDetailBloc
                                          .watchlistAddSuccessMessage ||
                                      message ==
                                          MovieDetailBloc
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(message),
                                          );
                                        });
                                  }
                                }
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<MovieDetailBloc>().add(
                                    AddWatchlistMovie(movieDetail: movie)
                                  );
                                } else {
                                  context.read<MovieDetailBloc>().add(
                                      RemoveWatchlistMovie(movieDetail: movie)
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _recommendationWidget()
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _recommendationWidget(){
    final recommendationState = state.movieRecommendationState;

    if (recommendationState == RequestState.Loading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (recommendationState == RequestState.Error){
      return Text(state.movieRecommendationMsg);
    } else if (recommendationState == RequestState.Empty){
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Center(
          child: Text(
            "Sorry, there are no recommendations for this movie.\nPlease choose other movie to see the recommendation",
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (recommendationState == RequestState.Loaded) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final movie = state.movieRecommendations![index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    MOVIE_DETAIL_ROUTE,
                    arguments: movie.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    placeholder: (context, url) =>
                        const Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                    errorWidget:
                        (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
          itemCount: state.movieRecommendations!.length,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  String _showGenres(List<GenreEntities> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
