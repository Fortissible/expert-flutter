import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

class TvSeasonDetailPage extends StatefulWidget {
  final String tvSeriesName;
  final String defaultPoster;
  final int tvId;
  final int seasonId;

  const TvSeasonDetailPage({
    super.key,
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
      context.read<TvSeasonBloc>().add(
        FetchTvSeason(
            tvId: widget.tvId.toString(),
            seasonId: widget.seasonId.toString()
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeasonBloc, TvSeasonState>(
        builder: (context, state) {
          final tvSeasonDetailState = state.tvSeasonState;
          if (tvSeasonDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (tvSeasonDetailState == RequestState.Loaded) {
            final tvDetail = state.tvSeason;
            return SafeArea(
              child: SeasonDetailContent(
                tvDetail!,
                widget.tvSeriesName,
                widget.defaultPoster,
              ),
            );
          }
          else if (tvSeasonDetailState == RequestState.Error){
            return Expanded(
              child: Center(
                child: Text(state.tvSeasonMsg),
              ),
            );
          }
          else {
            return const SizedBox();
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
  const SeasonDetailContent(
      this.tvSeasonDetail,
      this.tvSeriesName,
      this.defaultPoster, {super.key}
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeasonDetail.posterPath ?? defaultPoster}',
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
                              "$tvSeriesName - ${tvSeasonDetail.name}",
                              style: kHeading5,
                            ),
                            const SizedBox(height: 16),
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
                'Episode name: ${episode.name??""}\nDuration : ${episode.runtime??"0"} Mins - Type : ${episode.episodeType == EpisodeTypeEntity.FINALE ? "Finale" : "Standard"}',
              ),
            )
        );
      }
    }
    return listTile;
  }
}
