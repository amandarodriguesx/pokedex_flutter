import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokedex_somativo01/providers/favoritos_provider.dart';
import 'package:pokedex_somativo01/screens/pokemon_list_screen.dart';
import 'package:pokedex_somativo01/providers/pokemons_provider.dart';
import 'package:pokedex_somativo01/models/pokemon_models.dart';
import 'package:pokedex_somativo01/screens/pokemon_details_screen.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokemons Favoritas')),
      body: Consumer<FavoritosProvider>(
        builder: (context, favoritosProvider, child) {
          final idsFavoritos = favoritosProvider.idsPokemonsFavoritos;

          final todosPokemons = context.watch<PokemonsProvider>().pokemons;

          final pokemonsFavoritos = todosPokemons
              .where((pokemon) => idsFavoritos.contains(pokemon.id))
              .toList();

          if (pokemonsFavoritos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Você ainda não tem pokemons favoritas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque no ícone de coração nos detalhes do pokemon para adicioná-los aqui!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Exibe a lista de receitas favoritas
          return ListView.builder(
            itemCount: pokemonsFavoritos.length,
            itemBuilder: (ctx, index) {
              final pokemon = pokemonsFavoritos[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(child: Text(pokemon.id.toString())),
                  title: Text(pokemon.name),
                  subtitle: const Text('Clique para ver detalhes'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) =>
                            PokemonDetailsScreen(pokemon: pokemon),
                      ),
                    );
                  },
                  trailing: Consumer<FavoritosProvider>(
                    builder: (ctx, favoritosProvider, child) {
                      final isFav = favoritosProvider.isFavorito(pokemon.id);
                      return Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
