class DbBookModel {
  String id;
  String title;
  String publisher;
  String authors;
  String image;
  String description;
  String isFavourite;
  String isAddedToReadList;

  DbBookModel(
      {required this.id,
      required this.title,
      required this.publisher,
      required this.authors,
      required this.description,
      required this.isFavourite,
      required this.image,
      required this.isAddedToReadList});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'publisher': publisher,
      'author': authors,
      'description': description,
      'isFavourite': isFavourite,
      'image': image,
      'isAddedToReadList': isAddedToReadList
    };
  }
}

class DbBookReadModel {
  String idRead;
  String reviews;
  String sideNotes;

  DbBookReadModel(
      {required this.idRead, required this.reviews, required this.sideNotes});

  Map<String, dynamic> toJson() =>
      {'idRead': idRead, 'reviews': reviews, 'sideNotes': sideNotes};
}

class BookSideNote {
  final String bookId;
  final String note;
  final String dateTime;

  factory BookSideNote.fromJson(dynamic json) {
    return BookSideNote(
        bookId: json['bookId'], note: json['note'], dateTime: json['dateTime']);
  }

  Map<String, dynamic> toJson() =>
      {'bookId': bookId, 'note': note, 'dateTime': dateTime};

  BookSideNote(
      {required this.bookId, required this.note, required this.dateTime});
}
