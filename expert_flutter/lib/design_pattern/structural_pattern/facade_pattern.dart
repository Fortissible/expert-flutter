class OfflineData {
  String getDataFromDatabase() => 'Here is your cached data!';
}

class OnlineData {
  String getDataFromApi() => 'Here is your latest data!';
}

class DataRepository {
  final OfflineData _offlineData = OfflineData();
  final OnlineData _onlineData = OnlineData();

  String getData({bool isOnline = false}) {
    if (isOnline) {
      return _onlineData.getDataFromApi();
    } else {
      return _offlineData.getDataFromDatabase();
    }
  }
}