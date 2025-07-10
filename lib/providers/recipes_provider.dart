import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:http/http.dart' as http;
// import 'dart:developer';

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];
  List<Recipe> favoriteRecipe = [];

  Future<void> FetchRecipes() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://localhost:5555/recipes');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['Recipes'] != null) {
          recipes = List<Recipe>.from(
            data['Recipes'].map((recipe) => Recipe.fromJSON(recipe)),
          );
        } else {
          print('Received null data or null Recipes list');
          recipes = [];
        }
      } else {
        print('Error status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        recipes = [];
      }
    } catch (e) {
      print('Error in request: $e');
      recipes = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(Recipe recipe) async {
    final isFavorite = favoriteRecipe.contains(recipe);
    try {
      final url = Uri.parse('http://localhost:5555/favorites');

      final response = isFavorite
          ? await http.delete(url, body: json.encode({"id": recipe.id}))
          : await http.post(url, body: json.encode(recipe.toJson()));
      if (response.statusCode == 200) {
        if (isFavorite) {
          favoriteRecipe.remove(recipe);
        } else {
          favoriteRecipe.add(recipe);
        }
        notifyListeners();
      } else {
        throw Exception("Failed to update favorites recipes");
      }
    } catch (e) {
      print('Error update favorite recipe $e');
    }
  }
}
