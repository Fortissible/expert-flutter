import 'package:core/core.dart';

Seasons generateSeasonFromDetail(List<SeasonEntity> seasons){
  List<String> expandedValue = [];
  for(var i = 0; i < seasons.length; i++){
    expandedValue.add("• Season ${i+1} - ${seasons[i].episodeCount} Episode\n");
  }
  final season = Seasons(
      expandedValue: expandedValue,
      headerValue: "${seasons.length} Seasons"
  );
  return season;
}