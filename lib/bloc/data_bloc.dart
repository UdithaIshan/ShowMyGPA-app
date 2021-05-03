import 'dart:async';

import 'package:gpa_analyzer/data/data.dart';
import 'package:gpa_analyzer/data/data_db.dart';

class DataBloc {
  DataBloc() {
    dataDb = DataDb();
    getResults();
    _dataResultStreamController.stream.listen(returnData);
  }

  DataDb dataDb;
  Data dataResult;

  final _dataResultStreamController =   StreamController<Data>.broadcast();

  Stream<Data> get data => _dataResultStreamController.stream;
  StreamSink<Data> get dataSink =>_dataResultStreamController.sink;

  Future getResults() async {
    Data data = await dataDb.getDataFromFirestore();
    dataResult = data;
    dataSink.add(dataResult);
  }

  Data returnData(data) {
    return data;
  }

  Future<void> refresh() async{
    await getResults();
  }

  void dispose() {
    _dataResultStreamController.close();
  }
}