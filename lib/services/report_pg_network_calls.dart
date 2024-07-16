import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report_pg_model.dart';
import '../utils/constants.dart';

Future<ReportPgModel?> getReportPgData(String date, String counter) async {
  try{
    print("url = ${"${apiBaseUrl}GetSummaryReport?indate=$date&counter=$counter"}");
    var response = await http.get(Uri.parse("${apiBaseUrl}GetSummaryReport?indate=$date&counter=$counter"));
    // var response = await http.get(Uri.parse("${Constants.apiBaseUrl}GetSettlementReport?indate=2024-02-27"));
    print("response.statusCode = ${response.statusCode} response body = ${response.body}");
    var v = response.body;
    if(response.statusCode == 200)
    {
      print("v = $v");
      if(response.body.isNotEmpty)
      {
        var data = json.decode(response.body);
        return ReportPgModel.fromJson(data);
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
