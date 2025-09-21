import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_models.dart';

class PokemonService {
  final String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemons({int offset = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?offset=$offset&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Pokemon.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar a lista de Pokémon');
      }
    } catch (e) {
      print('Erro ao buscar a lista de Pokémon: $e');
      rethrow;
    }
  }

  Future<PokemonDetails> fetchPokemonDetails(int pokemonId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$pokemonId'));

      if (response.statusCode == 200) {
        return PokemonDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao carregar os detalhes do Pokémon');
      }
    } catch (e) {
      print('Erro ao buscar detalhes do Pokémon: $e');
      rethrow;
    }
  }

  Future<PokemonDetails> searchPokemon(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/${query.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        return PokemonDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception('Pokémon não encontrado. Verifique o nome ou número.');
      }
    } catch (e) {
      print('Erro ao buscar o Pokémon: $e');
      rethrow;
    }
  }
}
