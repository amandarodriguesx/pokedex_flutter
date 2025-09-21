import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex_somativo01/models/pokemon_models.dart';

class FavoritosProvider extends ChangeNotifier {
  final List<int> _idsPokemonsFavoritos = [];

  List<int> get idsPokemonsFavoritos => _idsPokemonsFavoritos;

  bool isFavorito(int id) {
    return _idsPokemonsFavoritos.contains(id);
  }

  void toggleFavorito(int id) {
    if (isFavorito(id)) {
      _idsPokemonsFavoritos.remove(id);
    } else {
      _idsPokemonsFavoritos.add(id);
    }

    notifyListeners();
  }
}
