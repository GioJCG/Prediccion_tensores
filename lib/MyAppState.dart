import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;
  String? predictionResult;
  String? retrainResult;

  void callLinearModel({

    required List<double>instance,

  }) async {
    final url = Uri.parse("https://tensorflow-linear-model-hapw.onrender.com/v1/models/linear-model:predict");
    final headers = {"Content-Type": "application/json;charset=UTF-8"};
    final predictionInstance = {

      "instance": "[[1],[2.0],[5.0]]",

    };

    try {
      final res = await http.post(url, headers: headers, body: jsonEncode(predictionInstance));
      if (res.statusCode == 200) {
        final jsonPrediction = res.body;
        print(jsonPrediction);
        predictionResult = res.body;
      } else {
        print('Error: ${res.statusCode}');
        predictionResult = 'Error: ${res.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');
      predictionResult = 'Exception: $e';
    }
    notifyListeners();
  }

void retrainModel({
    required String datasetUrl,
    required String sha,
    required String githubToken,
  }) async {
    final url = Uri.parse("https://api.github.com/repos/DanielaCanoGarcia/heart-model/dispatches");
    final headers = {
      'Authorization': 'Bearer $githubToken',
      'Accept': 'application/vnd.github.v3+json',
      'Content-type': 'application/json',
    };
    final body = jsonEncode({
      'event_type': 'ml_ci_cd',
      'client_payload': {
        'dataseturl': datasetUrl,
        'sha': sha,
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 204) {
        retrainResult = 'Reentrenamiento del modelo desencadenado exitosamente.';
      } else {
        retrainResult = 'Error al desencadenar el reentrenamiento del modelo: ${response.body}';
      }
    } catch (e) {
      retrainResult = 'Exception: $e';
    }
    notifyListeners();
  }

  void callModel({
    required int age,
    required int sex,
    required int cp,
    required int trestbps,
    required int chol,
    required int fbs,
    required int restecg,
    required int thalach,
    required int exang,
    required double oldpeak,
    required int slope,
    required int ca,
    required int thal,
  }) async {
    final url = Uri.parse("https://fastapiml-latest.onrender.com/score");
    final headers = {"Content-Type": "application/json;charset=UTF-8"};
    final predictionInstance = {
      "age": age,
      "sex": sex,
      "cp": cp,
      "trestbps": trestbps,
      "chol": chol,
      "fbs": fbs,
      "restecg": restecg,
      "thalach": thalach,
      "exang": exang,
      "oldpeak": oldpeak,
      "slope": slope,
      "ca": ca,
      "thal": thal,
    };

    try {
      final res = await http.post(url, headers: headers, body: jsonEncode(predictionInstance));
      if (res.statusCode == 200) {
        final jsonPrediction = res.body;
        print(jsonPrediction);
        predictionResult = res.body;
      } else {
        print('Error: ${res.statusCode}');
        predictionResult = 'Error: ${res.statusCode}';
      }
    } catch (e) {
      print('Exception: $e');
      predictionResult = 'Exception: $e';
    }
    notifyListeners();
  }

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
