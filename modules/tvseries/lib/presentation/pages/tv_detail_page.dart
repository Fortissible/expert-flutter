import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tvseries/tvseries.dart';

class TvDetailPage extends StatefulWidget {
  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(tvId: widget.id));
      context.read<TvDetailBloc>().add(LoadTvWatchlist(tvId: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (BuildContext context, TvDetailState state) {
          final tvDetailState = state.tvDetailState;
          if (tvDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (tvDetailState == RequestState.Loaded) {
            final tvDetail = state.tvDetail;
            return SafeArea(
              child: DetailContentTv(
                  tvDetail!,
                  state,
                  context
              ),
            );
          } else {
            return Text(state.tvDetailMsg);
          }
        })
    );
  }
}

class DetailContentTv extends StatelessWidget {
  final TvDetail tvDetail;
  final TvDetailState state;
  final BuildContext context;

  const DetailContentTv(
      this.tvDetail,
      this.state,
      this.context, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isAddedWatchlist = state.tvWatchlistStatus;
    final recommendations = state.tvRecommendations;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
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
                              tvDetail.name,
                              style: kTextTheme.headlineSmall,
                            ),
                            BlocListener<TvDetailBloc, TvDetailState>(
                                child: const SizedBox(),
                                listener: (ctx, state){
                                  final message = state.tvWatchlistMsg;

                                  if (message == TvDetailBloc
                                        .watchlistAddSuccessMessage
                                      || message == TvDetailBloc
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
                                },
                                listenWhen: (oldState, newState) {
                                  return oldState.tvWatchlistMsg != newState.tvWatchlistMsg &&
                                      newState.tvWatchlistMsg != '';
                                },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context.read<TvDetailBloc>().add(
                                      AddTvWatchlist(tv: state.tvDetail!)
                                  );
                                } else {
                                  context.read<TvDetailBloc>().add(
                                      RemoveTvWatchlist(tv: state.tvDetail!)
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
                              _showGenres(tvDetail.genres),
                            ),
                            BlocBuilder<TvDetailBloc, TvDetailState>(
                                builder: (ctx, state){
                                  return ExpansionPanelList(
                                    expansionCallback: (int index, bool isExpanded) {
                                      context.read<TvDetailBloc>().add(
                                        ExpandSeasonDetail(isExpanded: isExpanded)
                                      );
                                    },
                                    elevation: 0,
                                    children: [
                                      ExpansionPanel(
                                        headerBuilder: (BuildContext context, bool isExpanded) {
                                          return ListTile(
                                            title: Text(state.tvSeasons!.headerValue),
                                          );
                                        },
                                        body: Column(
                                          children: [
                                            ..._generateSeasonDetailTile(state)
                                          ],
                                        ),
                                        isExpanded: state.tvSeasons!.isExpanded,
                                      )
                                    ],
                                  );
                                }
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _tvRecommendationWidget(recommendations)
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

  Widget _tvRecommendationWidget(List<Tv> recommendations){
    if (state.tvRecommendationState ==
        RequestState.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.tvRecommendationState ==
        RequestState.Error) {
      return Text(state.tvRecommendationMsg);
    } else if (state.tvRecommendationState ==
        RequestState.Loaded) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final tv = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    DETAIL_TV_ROUTE,
                    arguments: tv.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
          itemCount: recommendations.length,
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> _generateSeasonDetailTile(TvDetailState state){
    final seasonDetail = state.tvSeasons!.expandedValue;

    final listTile = <Widget>[];

    for(var i = 0; i<seasonDetail.length; i++){
      listTile.add(
          ListTile(
            onTap: (){
              Navigator.pushNamed(
                context,
                TV_DETAIL_SEASON_ROUTE,
                arguments: TvSeasonDetailArguments(
                    tvSeriesName: state.tvDetail?.name ?? "",
                    defaultPoster: state.tvDetail?.posterPath ?? "",
                    tvId: state.tvDetail?.id ?? 0,
                    seasonId: i+1
                ),
              );
            },
            title: Text(seasonDetail[i]),
          )
      );
    }
    return listTile;
  }

  String _showGenres(List<TvDetailGenre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
