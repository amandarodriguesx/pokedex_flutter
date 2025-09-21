import 'package:flutter/material.dart';
import 'package:pokedex_somativo01/models/pokemon_models.dart';
import 'package:pokedex_somativo01/providers/favoritos_provider.dart';
import 'package:pokedex_somativo01/services/pokemon_service.dart';
import 'package:provider/provider.dart';

class PokemonDetailsScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  final PokemonService _pokemonService = PokemonService();
  bool _isLoading = true;
  late PokemonDetails _detailedPokemon;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetails(widget.pokemon.id);
  }

  Future<void> _loadPokemonDetails(int pokemonId) async {
    try {
      final pokemonDetails = await _pokemonService.fetchPokemonDetails(
        pokemonId,
      );
      if (!mounted) return;
      setState(() {
        _detailedPokemon = pokemonDetails;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar detalhes do Pokémon.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    final isFav = favoritosProvider.isFavorito(widget.pokemon.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              context.read<FavoritosProvider>().toggleFavorito(
                widget.pokemon.id,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: NetworkImage(_detailedPokemon.imageUrl)),
                  Text('Nome: ${_detailedPokemon.name}'),
                  Text('ID: ${_detailedPokemon.id}'),
                  Text('Altura: ${_detailedPokemon.height / 10} m'),
                  Text('Peso: ${_detailedPokemon.weight / 10} kg'),
                  Text('Habilidades: ${_detailedPokemon.abilities.join(', ')}'),
                  Wrap(
                    spacing: 8,
                    children: _detailedPokemon.types
                        .map((type) => Chip(label: Text(type)))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
