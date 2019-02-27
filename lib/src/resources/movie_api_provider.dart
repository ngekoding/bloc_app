import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = 'b3a9d4eb5d497caea91cd74575c91f87';

  Future<ItemModel> fetchMovieList() async {
    final response = await client.get('http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movies. ' + response.statusCode.toString());
    }
  }
}