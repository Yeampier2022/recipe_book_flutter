import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:http/http.dart' as HTTP;

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];
  // List<Recipe> _favoriteRecipe = [];

  Future<void> FetchRecipes() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('http://localhost:5555/recipes');

    try {
      final response = await HTTP.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        recipes = List<Recipe>.from(
          data['Recipes'].map((recipe) => Recipe.fromJSON(recipe)),
        );
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

  // Future<void> toggleFavoriteStatus(Recipe recipe) async {
  //   final isFavorite = _favoriteRecipe.contains(recipe);
  //   try {
  //     final url = Uri.parse('http://localhost:5555/favorites');

  //     final response = isFavorite
  //         ? await HTTP.delete(url, body: json.encode({"id": recipe.id}))
  //         : await HTTP.post(url, body: json.encode(recipe.toJson()));
  //     if (response.statusCode == 200) {
  //       if (isFavorite) {
  //         _favoriteRecipe.remove(recipe);
  //       } else {
  //         _favoriteRecipe.add(recipe);
  //       }
  //       notifyListeners();
  //     } else {
  //       throw Exception("Failed to update favorites recipes");
  //     }
  //   } catch (e) {
  //     print('Error update favorite recipe $e');
  //   }
  // }
}
