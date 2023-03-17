import 'package:flutter/material.dart';

class OpenCard {
  final String title;
  final GlobalObjectKey key;

  OpenCard({
    required this.title,
    required this.key,
  });
}

class NFTCollection {
  final String name;
  final String description;
  final String author;
  final String imageUrl;
  final String createdAt;
  final int items;
  final double creatorEarnings;
  final String chain;
  final String category;
  final int totalVolume;
  final double floorPrice;
  final double bestOffer;
  final int owners;
  final double uniqueOwners;

  NFTCollection({
    required this.name,
    required this.description,
    required this.author,
    required this.imageUrl,
    required this.createdAt,
    required this.items,
    required this.creatorEarnings,
    required this.chain,
    required this.category,
    required this.totalVolume,
    required this.floorPrice,
    required this.bestOffer,
    required this.owners,
    required this.uniqueOwners,
  });
}
