// lib/card/restaurant.dart
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final int number; // e.g. number of reviews
  final String rating;
  final String image_url;
  final String restaurant_url;
  final List<String> tags;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.number,
    required this.rating,
    required this.image_url,
    required this.restaurant_url,
    required this.tags,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(restaurant_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $restaurant_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayedTags =
        tags.length > 3 ? tags.sublist(0, 3) : tags;

    return GestureDetector(
      onTap: () {
        // Show a confirmation dialog before proceeding.
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to proceed to the restaurant listing?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        ).then((confirmed) {
          if (confirmed == true) {
            _launchUrl();
          }
        });
      },
      child: FractionallySizedBox(
        widthFactor: 0.75, // 3/4 of the viewport width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 2,
          // Optionally set a background color if needed:
          // color: Colors.grey[900],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  image_url,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              // Restaurant name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Rating and number of reviews
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '$rating ($number reviews)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Display tags as plain text styled like a "Breakfast Included" tag
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 8.0,
                  children: displayedTags.map((tag) {
                    return Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ).animate().fade(duration: 400.ms).slideY(),
      ),
    );
  }
}

// Example data generator for RestaurantCard widgets
List<RestaurantCard> getRestaurantCards() {
  final List<Map<String, dynamic>> restaurantDataList = [
    {
      "image_url": "https://example.com/restaurant1.jpg",
      "restaurant_url": "https://example.com/restaurant1",
      "name": "The Gourmet Kitchen",
      "rating": "4.5",
      "number": 120,
      "tags": ["Italian", "Pasta", "Desserts", "Wine"]
    },
    {
      "image_url": "https://example.com/restaurant2.jpg",
      "restaurant_url": "https://example.com/restaurant2",
      "name": "Sushi World",
      "rating": "4.8",
      "number": 200,
      "tags": ["Japanese", "Sushi", "Seafood", "Fusion", "Fresh", "Seasonal"]
    },
  ];

  return restaurantDataList.map((data) {
    return RestaurantCard(
      image_url: data["image_url"],
      restaurant_url: data["restaurant_url"],
      name: data["name"],
      rating: data["rating"],
      number: data["number"],
      tags: List<String>.from(data["tags"]),
    );
  }).toList();
}
