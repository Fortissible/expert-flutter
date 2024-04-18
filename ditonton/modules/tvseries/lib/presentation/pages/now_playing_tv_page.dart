import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

class NowPlayingTvPage extends StatefulWidget {
  const NowPlayingTvPage({super.key});

  @override
  _NowPlayingTvPageState createState() => _NowPlayingTvPageState();
}

class _NowPlayingTvPageState extends State<NowPlayingTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TvListBloc>().add(
          const FetchOnAirTv()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListBloc, TvListState>(
          builder: (BuildContext context, TvListState state) {
            final tvOnAirState = state.tvOnAirState;
            if (tvOnAirState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvOnAirState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvOnAir![index];
                  return TvCard(tv);
                },
                itemCount: state.tvOnAir!.length,
              );
            } else if (tvOnAirState == RequestState.Empty ) {
              return const Center(
                key: Key('empty_message'),
                child: Text("No on air TV series found!"),
              );
            } else if (tvOnAirState == RequestState.Error ) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.tvOnAirMsg),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
