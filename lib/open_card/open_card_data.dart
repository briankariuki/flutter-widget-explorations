import 'package:flutter/material.dart';

class OpenCard {
  final String title;
  final GlobalObjectKey key;
  final NFTCollection collection;

  OpenCard({
    required this.title,
    required this.key,
    required this.collection,
  });
}

// const collections = <NFTCollection>[];
// const List<NFTCollection> collections = [];

final List<NFTCollection> collections = [
  NFTCollection(
    name: 'Doodles',
    description:
        'A community-driven collectibles project featuring art by Burnt Toast. Doodles come in a joyful range of colors, traits and sizes with a collection size of 10,000. Each Doodle allows its owner to vote for experiences and activations paid for by the Doodles Community Treasury.',
    author: 'Doodles_LLC',
    imageUrl: 'https://i.seadn.io/gae/7B0qai02OdHA8P_EOVK672qUliyjQdQDGNrACxs7WnTgZAkJa_wWURnIFKeOh5VTf8cfTqW3wQpozGedaC9mteKphEOtztls02RlWQ?auto=format&w=384',
    createdAt: 'Oct 2021',
    items: 10000,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 250684,
    floorPrice: 3.6887,
    bestOffer: 3.55,
    owners: 5466,
    uniqueOwners: 0.55,
    verified: true,
  ),
  NFTCollection(
    name: 'Mutant Ape Yacht Club',
    description:
        'The MUTANT APE YACHT CLUB is a collection of up to 20,000 Mutant Apes that can only be created by exposing an existing Bored Ape to a vial of MUTANT SERUM or by minting a Mutant Ape in the public sale.',
    author: 'YugaLabs',
    imageUrl:
        'https://i.seadn.io/gae/lHexKRMpw-aoSyB1WdFBff5yfANLReFxHzt1DOj_sg7mS14yARpuvYcUtsyyx-Nkpk6WTcUPFoG53VnLJezYi8hAs0OxNZwlw6Y-dmI?auto=format&w=384',
    createdAt: 'Aug 2021',
    items: 19461,
    creatorEarnings: 0.025,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 735913,
    floorPrice: 14.08,
    bestOffer: 13.4,
    owners: 11503,
    uniqueOwners: 0.59,
    verified: true,
  ),
  NFTCollection(
    name: 'Moonbirds',
    description:
        'A collection of 10,000 PFPs which grant their holders access to the digital and IRL Moonbirds community. Community members can nest their birds to signal their commitment, in return for exclusive perks—which so far have included trait-based physical and digital drops, the Oddities, and time-based nesting rewards.',
    author: 'PROOF_XYZ',
    imageUrl: 'https://i.seadn.io/gae/H-eyNE1MwL5ohL-tCfn_Xa1Sl9M9B4612tLYeUlQubzt4ewhr4huJIR5OLuyO3Z5PpJFSwdm7rq-TikAh7f5eUw338A2cy6HRH75?auto=format&w=384',
    createdAt: 'Apr 2022',
    items: 10000,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 290713,
    floorPrice: 3.998,
    bestOffer: 3.75,
    owners: 6494,
    uniqueOwners: 0.65,
    verified: true,
  ),
  NFTCollection(
    name: 'Azuki',
    description:
        'Azuki starts with a collection of 10,000 avatars that give you membership access to The Garden: a corner of the internet where artists, builders, and web3 enthusiasts meet to create a decentralized future. Azuki holders receive access to exclusive drops, experiences, and more.',
    author: 'TeamAzuki',
    imageUrl: 'https://i.seadn.io/gae/H8jOCJuQokNqGBpkBN5wk1oZwO7LM8bNnrHCaekV2nKjnCqw6UB5oaH8XyNeBDj6bA_n1mjejzhFQUP3O1NfjFLHr3FOaeHcTOOT?auto=format&w=384',
    createdAt: 'Jan 2022',
    items: 10000,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 438757,
    floorPrice: 14.5,
    bestOffer: 14.0,
    owners: 4866,
    uniqueOwners: 0.49,
    verified: true,
  ),
  NFTCollection(
    name: 'Otherdeed for Otherside',
    description:
        'Otherdeed is the key to claiming land in Otherside. Each have a unique blend of environment and sediment — some with resources, some home to powerful artifacts. And on a very few, a Koda roams.',
    author: 'OthersideMeta',
    imageUrl:
        'https://i.seadn.io/gae/yIm-M5-BpSDdTEIJRt5D6xphizhIdozXjqSITgK4phWq7MmAU3qE7Nw7POGCiPGyhtJ3ZFP8iJ29TFl-RLcGBWX5qI4-ZcnCPcsY4zI?auto=format&w=384',
    createdAt: 'Apr 2022',
    items: 100000,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'Virtual Worlds',
    totalVolume: 438757,
    floorPrice: 1.626,
    bestOffer: 1.6046,
    owners: 32203,
    uniqueOwners: 0.32,
    verified: true,
  ),
  NFTCollection(
    name: 'MG Land',
    description:
        'MGLand is the largest NFT Space on blockchain, everyone can bring their NFT into space to socialize, to play games, to hold NFT exhibitions and to trade freely. Join Alpha Season 3 — NFT Exhibition Event With 1,500,000 \$MGL Tokens Rewards In Total.',
    author: 'MetaGameSpace',
    imageUrl: 'https://i.seadn.io/gcs/files/e05d1e09349d7fb36c7970e7ac0e054c.png?auto=format&w=384',
    createdAt: 'Dec 2022',
    items: 5000,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'Virtual Worlds',
    totalVolume: 33402,
    floorPrice: 0.064,
    bestOffer: 0.084,
    owners: 2122,
    uniqueOwners: 0.42,
    verified: true,
  ),
  NFTCollection(
    name: 'This is Nouns',
    description:
        'WTF is Nouns? That’s the question we sought to answer in this crazy video – packing in more artistic styles than we’ve ever put into a project before, and a sprinkling of humour along the way.',
    author: '0xTranqui',
    imageUrl: 'https://i.seadn.io/gcs/files/a6749ad57d276cd2149eb8bf7fad1dee.png?auto=format&w=384',
    createdAt: 'Dec 2022',
    items: 3526,
    creatorEarnings: 0.00,
    chain: 'Ethereum',
    category: 'Art',
    totalVolume: 2624,
    floorPrice: 0.0389,
    bestOffer: 0.0217,
    owners: 1469,
    uniqueOwners: 0.42,
    verified: true,
  ),
  NFTCollection(
    name: 'Sewer Pass',
    description:
        'Sewer Passes have the opportunity to summon a Power Source. The rank visible on each pass will determine which Power Source you’ll receive. If your Sewer Pass did not place on the Dookey Dash leaderboard, you have the opportunity receive an unranked Power Source by participating in Dookey Dash: Toad Mode. Sewer Passes marked as VOID are ineligible for The Summoning',
    author: 'Sewer_Pass',
    imageUrl: 'https://i.seadn.io/gcs/files/a8a2c681f0241bc7128b9ee204a501f2.jpg?auto=format&w=384',
    createdAt: 'Jan 2023',
    items: 26485,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'Art',
    totalVolume: 46210,
    floorPrice: 1.1098,
    bestOffer: 0.6104,
    owners: 5931,
    uniqueOwners: 0.59,
    verified: true,
  ),
  NFTCollection(
    name: 'Pudgy Penguins',
    description:
        'Pudgy Penguins is a collection of 8,888 NFT’s, accelerating Web3 innovation through IP utilization and community empowerment. Embodying love, empathy, & compassion, the Pudgy Penguins are a beacon of good vibes & positivity for everyone. Each holder receives exclusive access to experiences, events, IP licensing opportunities and more. Let’s break through the boundaries of Web3 together',
    author: 'TheIglooCompany',
    imageUrl: 'https://i.seadn.io/gae/yNi-XdGxsgQCPpqSio4o31ygAV6wURdIdInWRcFIl46UjUQ1eV7BEndGe8L661OoG-clRi7EgInLX4LPu9Jfw4fq0bnVYHqg7RFi?auto=format&w=384',
    createdAt: 'Jul 2021',
    items: 8888,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 134659,
    floorPrice: 5.08,
    bestOffer: 4.9015,
    owners: 4628,
    uniqueOwners: 0.52,
    verified: true,
  ),
  NFTCollection(
    name: 'Meebits',
    description: 'The Meebits are 20,000 unique 3D voxel characters, created by a custom generative algorithm, then registered on the Ethereum blockchain.',
    author: 'C352B5',
    imageUrl: 'https://i.seadn.io/gae/d784iHHbqQFVH1XYD6HoT4u3y_Fsu_9FZUltWjnOzoYv7qqB5dLUqpGyHBd8Gq3h4mykK5Enj8pxqOUorgD2PfIWcVj9ugvu8l0?auto=format&w=384',
    createdAt: 'May 2021',
    items: 19999,
    creatorEarnings: 0.05,
    chain: 'Ethereum',
    category: 'PFPs',
    totalVolume: 156546,
    floorPrice: 3.05,
    bestOffer: 2.9694,
    owners: 6597,
    uniqueOwners: 0.33,
    verified: true,
  )
];

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
  final bool verified;

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
    required this.verified,
  });
}
