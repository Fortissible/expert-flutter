import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

class PopularTvPage extends StatefulWidget {
  const PopularTvPage({super.key});

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TvListBloc>().add(
          const FetchPopularTv()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListBloc,TvListState>(
          builder: (ctx, state) {
            final tvPopularState = state.tvPopularState;
            if (tvPopularState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (tvPopularState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvPopular![index];
                  return TvCard(tv);
                },
                itemCount: state.tvPopular!.length,
              );
            } else if (tvPopularState == RequestState.Empty) {
              return const Center(
                key: Key('empty_message'),
                child: Text("No popular TV Series found!"),
              );
            } else if (tvPopularState == RequestState.Error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.tvPopularMsg),
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
