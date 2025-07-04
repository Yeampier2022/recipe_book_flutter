import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_book/screens/repicpe_detail.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<dynamic>> FetchRecipes() async {
    final url = Uri.parse('http://localhost:5555/recipes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['recipes'];
      } else {
        print('Error ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in request');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: FetchRecipes(),
        builder: (context, snapshot) {
          final recipes = snapshot.data ?? [];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Recipes found'));
          } else {
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return _RecipesCard(context, recipes[index]);
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showBottom(context);
        },
      ),
    );
  }

  Future<void> _showBottom(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        color: Colors.white,
        child: ReciperForm(),
      ),
    );
  }

  Widget _RecipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              recipeName: recipe['name'],
              recipeDescription: recipe['recipe'],
              img: recipe['image_link'],

            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: <Widget>[
                Container(
                  height: 125,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe['image_link'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 26),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipe['name'],

                      style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    ),
                    SizedBox(height: 4),
                    Container(height: 2, width: 75, color: Colors.orange),
                    Text(
                      recipe['author'],

                      style: TextStyle(fontSize: 16, fontFamily: 'Quicksand'),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReciperForm extends StatelessWidget {
  const ReciperForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _recipeName = TextEditingController();
    final TextEditingController _recipeAuthor = TextEditingController();
    final TextEditingController _recipeImg = TextEditingController();
    final TextEditingController _recipeDescription = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add new Recipe",
              style: TextStyle(color: Colors.orange, fontSize: 24),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeName,
              label: 'Recipe name',

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the name recipe";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeAuthor,
              label: 'Author',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the Author";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeImg,
              label: 'Image url',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the Image url";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeDescription,
              label: 'Recipe',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter the description";
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                child: Text(
                  'Save recipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Quicksand', color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 10),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      validator: validator,
      maxLines: maxLines,
    );
  }
}
