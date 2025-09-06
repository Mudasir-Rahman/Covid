import 'dart:convert';

import 'package:cov_19/Model/WorldStateModel.dart';
import 'package:cov_19/Utilities/app_url.dart';
import 'package:http/http.dart'as http;
class StateServices{
  Future<WorldStateModel>fetchWorldStatesRecord()async{
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      return WorldStateModel.fromJson(data);
    }
    else{
      throw Exception('Error');
    }
  }
  Future<List<dynamic>>countriesListApi()async{
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if(response.statusCode==200){
       data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Error');
    }
  }
}