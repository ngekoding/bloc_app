import 'dart:async';
import 'package:flutter/material.dart';
import '../blocs/movie_detail_bloc_provider.dart';
import '../models/trailer_model.dart';

class MovieDetail extends StatefulWidget {
  final posterPath;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail(this.posterPath, this.description, this.releaseDate, this.title,
      this.voteAverage, this.movieId);

  @override
  _MovieDetailState createState() => _MovieDetailState(
      posterPath, description, releaseDate, title, voteAverage, movieId);
}

class _MovieDetailState extends State<MovieDetail> {
  final posterPath;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetailBloc bloc;

  _MovieDetailState(this.posterPath, this.description, this.releaseDate,
      this.title, this.voteAverage, this.movieId);

  @override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.fetchTrailersById(movieId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    elevation: 0.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                          'https://image.tmdb.org/t/p/w500$posterPath',
                          fit: BoxFit.cover),
                    ),
                  ),
                ];
              },
              body: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Text(title,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 20.0),
                        Text(releaseDate, style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(description),
                    SizedBox(height: 16.0),
                    Text("Trailer",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    StreamBuilder(
                      stream: bloc.movieTrailers,
                      builder: (context,
                          AsyncSnapshot<Future<TrailerModel>> snapshot) {
                        if (snapshot.hasData) {
                          return FutureBuilder(
                            future: snapshot.data,
                            builder: (context,
                                AsyncSnapshot<TrailerModel> itemSnapshot) {
                              if (itemSnapshot.hasData) {
                                if (itemSnapshot.data.results.length > 0) {
                                  return trailerLayout(itemSnapshot.data);
                                } else {
                                  return noTrailer(itemSnapshot.data);
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  ],
                ),
              ))),
    );
  }

  Widget noTrailer(TrailerModel data) {
    return Center(
      child: Container(
        child: Text('No trailer available'),
      ),
    );
  }

  Widget trailerLayout(TrailerModel data) {
    if (data.results.length > 1) {
      return Row(
        children: [
          trailerItem(data, 0),
          trailerItem(data, 1),
        ],
      );
    } else {
      return Row(
        children: [
          trailerItem(data, 0),
        ],
      );
    }
  }

  trailerItem(TrailerModel data, int index) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            height: 100.0,
            color: Colors.grey,
            child: Center(
              child: Icon(Icons.play_circle_filled),
            ),
          ),
          Text(
            data.results[index].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
