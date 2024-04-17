import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<TvListBloc>().add(
          FetchTopRatedTv()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvListBloc,TvListState>(
          builder: (ctx, state) {
            final tvTopRatedState = state.tvTopRatedState;
            if (tvTopRatedState == RequestState.Loading) {
              return Center(
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
              return Center(
                key: Key('empty_message'),
                child: Text("No top rated TV Series found!"),
              );
            }
            else if (tvTopRatedState == RequestState.Error){
              return Center(
                key: Key('error_message'),
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
