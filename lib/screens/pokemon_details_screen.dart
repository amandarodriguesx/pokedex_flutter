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
        title: Text(widget.pokemon.name.toUpperCase()),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'pokemon-${_detailedPokemon.id}',
                    child: Image.network(
                      _detailedPokemon.imageUrl,
                      height: 180,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey[100],
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoRow('ID', '#${_detailedPokemon.id}'),
                          _buildInfoRow('Nome', _detailedPokemon.name),
                          _buildInfoRow(
                            'Altura',
                            '${_detailedPokemon.height / 10} m',
                          ),
                          _buildInfoRow(
                            'Peso',
                            '${_detailedPokemon.weight / 10} kg',
                          ),
                          _buildInfoRow(
                            'Habilidades',
                            _detailedPokemon.abilities.join(', '),
                          ),
                          _buildInfoRow(
                            'Tipos',
                            _detailedPokemon.types.join(', '),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      favoritosProvider.toggleFavorito(_detailedPokemon.id);
                    },
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      isFav ? 'Remover dos favoritos' : 'Favoritar',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFav ? Colors.red : Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
