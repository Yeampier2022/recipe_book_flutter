import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe_model.dart';
import 'package:recipe_book/providers/recipes_provider.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipesData;
  const RecipeDetail({super.key, required this.recipesData});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipesProvider>(
      context,
      listen: false,
    ).favoriteRecipe.contains(widget.recipesData);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.recipesData.name,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<RecipesProvider>(
                context,
                listen: false,
              ).toggleFavoriteStatus(widget.recipesData);
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: ScaleTransition(
              scale: _scaleAnimation,

              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey<bool>(isFavorite),
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Image.network(
              widget.recipesData.image_link,
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 8),
            Text(widget.recipesData.name),
            SizedBox(height: 8),
            Text('By ${widget.recipesData.author}'),
            SizedBox(height: 8),

            Text('${widget.recipesData.recipe}'),
          ],
        ),
      ),
    );
  }
}
