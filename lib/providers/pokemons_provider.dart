import 'package:flutter/material.dart';
import 'package:pokedex_somativo01/models/pokemon_models.dart';
import 'package:pokedex_somativo01/services/pokemon_service.dart';
import 'package:collection/collection.dart';

class PokemonsProvider extends ChangeNotifier {
  final PokemonService _pokemonService = PokemonService();
  final List<Pokemon> _pokemons = [];
  final int _limit = 20;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Pokemon> get pokemons => _pokemons;

  Pokemon? searchPokemon(String query) {
    final lowerQuery = query.toLowerCase();

    return _pokemons.firstWhereOrNull(
      (p) =>
          p.name.toLowerCase() == lowerQuery || p.id.toString() == lowerQuery,
    );
  }

  Future<void> loadMorePokemons() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPokemons = await _pokemonService.fetchPokemons(
        offset: _pokemons.length,
        limit: _limit,
      );
      _pokemons.addAll(newPokemons);
    } catch (e) {
      debugPrint('Erro ao carregar Pokémons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
