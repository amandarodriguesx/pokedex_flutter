import 'package:flutter/material.dart';
import 'package:pokedex_somativo01/models/pokemon_models.dart';
import 'package:pokedex_somativo01/services/pokemon_service.dart';


class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokemonService _pokemonService = PokemonService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Pokemon>> _pokemonsFuture;

  List<Pokemon> _pokemons = [];
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _pokemonsFuture = _pokemonService.fetchPokemons(offset: 0, limit: _limit);
  }

  Future<void> _loadMorePokemons() async {
    try {
      final newPokemons = await _pokemonService.fetchPokemons(
          offset: _pokemons.length, limit: _limit);
      setState(() {
        _pokemons.addAll(newPokemons);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load more Pokémon.')),
      );
    }
  }

  Future<void> _searchPokemon() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, digite um nome ou número de Pokémon.')),
      );
      return;
    }

    try {
      final pokemonDetails = await _pokemonService.searchPokemon(query);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pokémon ${pokemonDetails.name} encontrado!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro na busca: Pokémon não encontrado.')),
      );
    }
  }

  Color _getPokemonCardColor(int pokemonId) {
    if (pokemonId % 4 == 0) return Colors.lightBlue.shade100;
    if (pokemonId % 4 == 1) return Colors.lightGreen.shade100;
    if (pokemonId % 4 == 2) return Colors.pink.shade100;
    return Colors.amber.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchField(),
            Expanded(
              child: FutureBuilder<List<Pokemon>>(
                future: _pokemonsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error loading Pokémon: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Pokémon found.'));
                  }

                  if (_pokemons.isEmpty) {
                    _pokemons = snapshot.data!;
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        _loadMorePokemons();
                      }
                      return false;
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _pokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = _pokemons[index];
                        return _buildPokemonCard(pokemon);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Pokédex',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F5),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search Pokémon',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('vc clicou no ${pokemon.name}!')),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: _getPokemonCardColor(pokemon.id),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  pokemon.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF6A1B9A),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
