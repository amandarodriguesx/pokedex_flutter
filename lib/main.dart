import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/pokemon_list_screen.dart';
import 'package:pokedex_somativo01/providers/favoritos_provider.dart';
import 'package:pokedex_somativo01/providers/pokemons_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritosProvider()),
      ],
      child: const PokemonsApp(),
    ),
  );
}

class PokemonsApp extends StatelessWidget {
  const PokemonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex Explorer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          color: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: PokemonListScreen(),
    );
  }
}
