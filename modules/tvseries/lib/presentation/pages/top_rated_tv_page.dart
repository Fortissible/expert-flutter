import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/tvseries.dart';

class TopRatedTvPage extends StatefulWidget {
  const TopRatedTvPage({super.key});

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TvListBloc>().add(
          const FetchTopRatedTv()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListBloc,TvListState>(
          builder: (ctx, state) {
            final tvTopRatedState = state.tvTopRatedState;
            if (tvTopRatedState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (tvTopRatedState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvTopRated![index];
                  return TvCard(tv);
                },
                itemCount: state.tvTopRated!.length,
              );
            }
            else if (tvTopRatedState == RequestState.Empty){
              return const Center(
                key: Key('empty_message'),
                child: Text("No top rated TV Series found!"),
              );
            }
            else if (tvTopRatedState == RequestState.Error){
              return Center(
                key: const Key('error_message'),
                child: Text(state.tvTopRatedMsg),
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ),
    );
  }
}
