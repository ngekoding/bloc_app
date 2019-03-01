import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';
import '../models/trailer_model.dart';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = 'b3a9d4eb5d497caea91cd74575c91f87';
  final _baseUrl = 'http://api.themoviedb.org/3/movie';

  Future<ItemModel> fetchMovieList() async {
    final response = await client.get('$_baseUrl/popular?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movies. ' + response.statusCode.toString());
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    print('Movie ID: $movieId');
    final response = await client.get('$_baseUrl/$movieId/vidoes?api_key=$_apiKey');
    if (response.statusCode == 200) {
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers. ' + response.statusCode.toString());
    }
  }
}