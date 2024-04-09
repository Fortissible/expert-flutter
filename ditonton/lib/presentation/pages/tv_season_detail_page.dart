import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/tv_season_detail.dart';
import '../provider/tv_season_detail_notifier.dart';

class TvSeasonDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detailtv/season';
  final String tvSeriesName;
  final String defaultPoster;
  final int tvId;
  final int seasonId;

  TvSeasonDetailPage({
    required this.tvSeriesName,
    required this.defaultPoster,
    required this.tvId,
    required this.seasonId
  });

  @override
  _TvSeasonDetailPageState createState() => _TvSeasonDetailPageState();
}

class _TvSeasonDetailPageState extends State<TvSeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvSeasonDetailNotifier>(context, listen: false)
          .fetchTvSeasonDetail(
            widget.tvId.toString(),
            widget.seasonId.toString()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvSeasonDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvSeasonDetailState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.tvSeasonDetailState == RequestState.Loaded) {
            final tvDetail = provider.tvSeasonDetail;
            return SafeArea(
              child: SeasonDetailContent(
                tvDetail!,
                widget.tvSeriesName,
                widget.defaultPoster,
              ),
            );
          } else {
            return Text(provider.tvSeasonDetailErrorMsg);
          }
        },
      ),
    );
  }
}

class SeasonDetailContent extends StatelessWidget {
  final TvSeasonDetail tvSeasonDetail;
  final String tvSeriesName;
  final String defaultPoster;
  SeasonDetailContent(
      this.tvSeasonDetail,
      this.tvSeriesName,
      this.defaultPoster
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeasonDetail.posterPath ?? defaultPoster}',
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
                              "${tvSeriesName} - ${tvSeasonDetail.name}",
                              style: kHeading5,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Episodes Detail :',
                              style: kHeading6,
                            ),
                            ..._generateSeasonDetailTile(tvSeasonDetail)
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

  List<Widget> _generateSeasonDetailTile(TvSeasonDetail tvSeasonDetail){
    final listTile = <Widget>[];
    if (tvSeasonDetail.episodes != null){
      for (var idx = 0; idx < tvSeasonDetail.episodes!.length; idx++){
        final episode = tvSeasonDetail.episodes![idx];
        listTile.add(
            ListTile(
              title: Text(
                'Episode ${episode.episodeNumber??"0"}',
              ),
              subtitle: Text(
                'Episode name: ${episode.name??""}\nDuration : ${episode.runtime??"0"} Mins - Type : ${episode.episodeType == EpisodeType.FINALE ? "Finale" : "Standard"}',
              ),
            )
        );
      }
    }
    return listTile;
  }
}
