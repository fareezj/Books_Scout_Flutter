class BookListModel {
  final int? totalItems;
  final List<BookItemModel>? bookItem;

  BookListModel({this.totalItems, this.bookItem});

  factory BookListModel.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson["items"] as List;
    List<BookItemModel> bookList = list.map((e) => BookItemModel.fromJson(e)).toList();

    return BookListModel(
        totalItems: parsedJson['totalItems'],
        bookItem: bookList
    );
  }
}

class BookItemModel {
  final String? id;
  final String? etag;
  final VolumeInfo? volumeInfo;


  BookItemModel({this.id = "", this.etag = "", this.volumeInfo});

  factory BookItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return BookItemModel(
      id: parsedJson["id"],
      etag: parsedJson["etag"],
      volumeInfo: VolumeInfo.fromJson(parsedJson['volumeInfo']),
    );
  }
}

class VolumeInfo {
  final String? title;
  final String? publisher;
  final String? description;
  final ImageLinksModel? imageLinks;
  final List<dynamic>? authors;

  VolumeInfo({this.title,this.publisher, this.description, this.imageLinks, this.authors});

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {

    var author = parsedJson["authors"] as List<dynamic>;

    return VolumeInfo(
      title: parsedJson["title"],
      publisher: parsedJson["publisher"],
      description: parsedJson["description"],
      imageLinks: ImageLinksModel.fromJson(parsedJson["imageLinks"]),
      authors: author
    );
  }
}

class ImageLinksModel {
  final String? thumbnail;
  final String? smallThumbnail;

  ImageLinksModel({this.thumbnail, this.smallThumbnail});

  factory ImageLinksModel.fromJson(Map<String, dynamic> parsedJson) {
    return ImageLinksModel(
      thumbnail: getFromList(parsedJson, 'thumbnail') ,
      smallThumbnail: getFromList(parsedJson, 'smallThumbnail') ,
    );
  }
}

String getFromList(Map<String, dynamic> json, String key) {
  return json != null ? json[key] : "";
}