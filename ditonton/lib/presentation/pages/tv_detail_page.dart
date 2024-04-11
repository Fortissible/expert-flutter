import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
// ignore: unused_import
import 'package:ditonton/data/models/seasons.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_season_detail_args.dart';
import 'package:ditonton/presentation/pages/tv_season_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/tv.dart';
import '../provider/tv_detail_notifier.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detailtv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvDetailNotifier>(context, listen: false)
          .fetchTvDetail(widget.id.toString());
      Provider.of<TvDetailNotifier>(context, listen: false)
          .fetchTvRecommendations(widget.id.toString());
      Provider.of<TvDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvDetailState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvDetailState == RequestState.Loaded) {
            final tvDetail = provider.tvDetail;
            return SafeArea(
              child: DetailContent(
                tvDetail!,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
                context
              ),
            );
          } else {
            return Text(provider.tvDetailErrorMsg);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tvDetail;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;
  final BuildContext context;

  DetailContent(
      this.tvDetail,
      this.recommendations,
      this.isAddedWatchlist,
      this.context
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
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
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<TvDetailNotifier>(
                                      context,
                                      listen: false)
                                      .addWatchlist(tvDetail);
                                } else {
                                  await Provider.of<TvDetailNotifier>(
                                      context,
                                      listen: false)
                                      .removeFromWatchlist(tvDetail);
                                }

                                final message =
                                    Provider.of<TvDetailNotifier>(context,
                                        listen: false)
                                        .watchlistMessage;

                                if (message ==
                                    TvDetailNotifier
                                        .watchlistAddSuccessMessage ||
                                    message ==
                                        TvDetailNotifier
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvDetail.genres),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Consumer<TvDetailNotifier>(
                                  builder: (ctx, provider, child){
                                    return ExpansionPanelList(
                                      expansionCallback: (int index, bool isExpanded) {
                                        provider.expandSeasonsDetail(isExpanded);
                                      },
                                      elevation: 0,
                                      children: [
                                        ExpansionPanel(
                                          headerBuilder: (BuildContext context, bool isExpanded) {
                                            return ListTile(
                                              title: Text(provider.seasons.headerValue),
                                            );
                                          },
                                          body: Column(
                                            children: [
                                              ..._generateSeasonDetailTile(provider)
                                            ],
                                          ),
                                          isExpanded: provider.seasons.isExpanded,
                                        )
                                      ],
                                    );
                                  }
                              ),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<TvDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.tvRecommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.tvRecommendationState ==
                                    RequestState.Error) {
                                  return Text(data.tvRecommendationsErrorMsg);
                                } else if (data.tvRecommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
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
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
                              },
                            ),
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
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _generateSeasonDetailTile(TvDetailNotifier provider){
    final seasonDetail = provider.seasons.expandedValue;

    final listTile = <Widget>[];

    for(var i = 0; i<seasonDetail.length; i++){
      listTile.add(
          ListTile(
            onTap: (){
              Navigator.pushNamed(
                context,
                TvSeasonDetailPage.ROUTE_NAME,
                arguments: TvSeasonDetailArguments(
                    tvSeriesName: provider.tvDetail?.name ?? "",
                    defaultPoster: provider.tvDetail?.posterPath ?? "",
                    tvId: provider.tvDetail?.id ?? 0,
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

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
