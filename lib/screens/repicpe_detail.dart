import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  final String recipeName;
  final String recipeDescription;
  final String img;
  const RecipeDetail({
    super.key,
    required this.recipeName,
    required this.recipeDescription,
    required this.img,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(recipeName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: <Widget>[
          Text(recipeName),

          Image.network(img, height: 500, width: 500),
          Text(recipeDescription),
        ],
      ),
    );
  }
}
