import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/pokemon_list_screen.dart';

class PokemonsProvider with ChangeNotifier {
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PokemonsProvider(),
      child: PokemonsApp(),
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
