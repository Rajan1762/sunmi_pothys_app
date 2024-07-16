import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/settlement_pg_model.dart';
import '../utils/constants.dart';

Future<bool> checkUserPassword({required String password}) async{
  print('${apiBaseUrl}GetSettlementlogin?pass=$password');
  http.Response response = await http.get(Uri.parse('${apiBaseUrl}GetSettlementlogin?pass=$password'));
  print('response statusCode = ${response.statusCode}\nresponse body = ${response.body}');
  if(response.statusCode == 200 && response.body != '' && response.body != '{}')
  {
    print('Condition passed');
    return true;
  }else{
    return false;
  }
}

Future<SettlementPgModel?> getSettlementPgData(String date,String counter) async {
  try{
    print("url = ${"${apiBaseUrl}GetSettlementReport?indate=$date&counter=$counter"}");
    var response = await http.get(Uri.parse("${apiBaseUrl}GetSettlementReport?indate=$date&counter=$counter"));
    // var response = await http.get(Uri.parse("${Constants.apiBaseUrl}GetSettlementReport?indate=2024-02-27"));
    print("response.statusCode = ${response.statusCode} response body = ${response.body}");
    if(response.statusCode == 200)
    {
      if(response.body.isNotEmpty)
      {
        var data = json.decode(response.body);
        return SettlementPgModel.fromJson(data);
      }else{
        return null;
      }
    }else{
      return null;
    }
  }catch(e)
  {
    print("Exception occurred $e");
    return null;
  }
}

Future<List<SettlementOverallModel?>?> getAllCounterSettlementPgData(String date) async {
  try{
    print("url = ${"${apiBaseUrl}GetSettlementOverAll?fromdate=$date"}");
    var response = await http.get(Uri.parse("${apiBaseUrl}GetSettlementOverAll?fromdate=$date"));
    print("getAllCounterSettlementPgData statusCode = ${response.statusCode}\n response body = ${response.body}");
    if(response.statusCode == 200)
    {
      if(response.body.isNotEmpty)
      {
        List data = json.decode(response.body);
        List<SettlementOverallModel> settlementOverallModel = [];
        for (var element in data) {
          settlementOverallModel.add(SettlementOverallModel.fromJson(element));
        }
        return settlementOverallModel;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }catch(e)
  {
    print("Exception occurred $e");
    return null;
  }
}

