import 'package:flutter/material.dart';

// This is my data model - each Recipe has an ID, name, 
// author, image URL, and step-by-step instructions"
@Material()
class Recipe {
  int id;
  String name;
  String author;
  String image_link;
  String recipe; // Cambiado a String

  Recipe({
    required this.id,
    required this.name,
    required this.author,
    required this.image_link,
    required this.recipe,
    // Ahora es String
  });

  factory Recipe.fromJSON(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 'Sin id',
      name: json['name'] ?? 'Sin nombre',
      author: json['author'] ?? 'Anónimo',
      image_link: json['image_link'] ?? '',
      recipe: json['recipe'] ?? '', // Recibe el String directamente
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'image_link': image_link,
      'recipe': recipe,
    };
  }

  @override
  String toString() {
    return 'Recipe{id: $id,name: $name ,author: $author, image_link: $image_link, recipe $recipe }';
  }
}
