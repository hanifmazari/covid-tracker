import 'package:covid_tracker/Services/Utilities/app_uri.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/worldstatModal.dart';

class StatesServices {
  Future<WorldStatModel> fetchWorldStatesRecord () async{
    final response = await http.get(Uri.parse(AppUrl.worldStatApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return WorldStatModel.fromJson(data);
    }else{
      throw Exception('Error');
    }
  }

Future<List<dynamic>> countriesListApi() async{
  // var data; 
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
     var data = jsonDecode(response.body);

      return data;
    }else{
      throw Exception('Error');
    }
  }  
}
