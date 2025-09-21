class Pokemon {
  final String name;
  final String url;
  final int id;

  Pokemon({
    required this.name,
    required this.url,
    required this.id,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final String url = json['url'];
    final int id = int.parse(url.split('/')[6]);
    return Pokemon(
      name: json['name'],
      url: json['url'],
      id: id,
    );
  }
}

class PokemonDetails {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final List<String> abilities;

  PokemonDetails({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.abilities,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    final List<String> types =
    (json['types'] as List).map((t) => t['type']['name'].toString()).toList();
    final List<String> abilities = (json['abilities'] as List)
        .map((a) => a['ability']['name'].toString())
        .toList();
    final String imageUrl = json['sprites']['other']['official-artwork']['front_default'];

    return PokemonDetails(
      id: json['id'],
      name: json['name'],
      types: types,
      imageUrl: imageUrl,
      abilities: abilities,
    );
  }
}
