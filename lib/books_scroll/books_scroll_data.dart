final List<Book> books = [
  Book(
    author: "Rachael Lippincott",
    title: "Five Feet Apart",
    rating: 4.19,
    views: 17692,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1529358577i/39939417.jpg",
  ),
  Book(
    author: "Nicola Yoon",
    title: "Everything, Everything",
    rating: 3.99,
    views: 46394,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1450515891i/18692431.jpg",
  ),
  Book(
    author: "Jenny Han",
    title: "P.S. I Still Love You",
    rating: 4.04,
    views: 26813,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1422881430i/20698530.jpg",
  ),
  Book(
    author: "John Green",
    title: "Paper Towns",
    rating: 3.73,
    views: 53884,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1349013610i/6442769.jpg",
  ),
  Book(
    author: "Veronica Roth",
    title: "Divergent",
    rating: 4.15,
    views: 116249,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1618526890i/13335037.jpg",
  ),
  Book(
    author: "Stephenie Meyer",
    title: "Twilight",
    rating: 3.64,
    views: 121048,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1361039443i/41865.jpg",
  ),
  Book(
    author: "Suzanne Collins",
    title: "Catching Fire",
    rating: 4.31,
    views: 107913,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1586722941i/6148028.jpg",
  ),
  Book(
    author: "J.K. Rowling",
    title: "Harry Potter and the Prisoner of Azkaban",
    rating: 4.58,
    views: 73998,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1630547330i/5.jpg",
  ),
  Book(
    author: "John Green",
    title: "The Fault in Our Stars",
    rating: 4.15,
    views: 171869,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1660273739i/11870085.jpg",
  ),
  Book(
    author: "Kristina Forest",
    title: "The Neighbor Favor",
    rating: 3.89,
    views: 297,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1664245474i/61111295.jpg",
  ),
  Book(
    author: "Amanda Elliot",
    title: "Best Served Hot",
    rating: 3.60,
    views: 171,
    imageUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1666029412i/61053817.jpg",
  ),
];

class Book {
  final String author;
  final String title;
  final double rating;
  final int views;
  final String imageUrl;

  Book({
    required this.author,
    required this.title,
    required this.rating,
    required this.views,
    required this.imageUrl,
  });
}
