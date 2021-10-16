import 'package:book_scout/models/book_model.dart';
import 'package:book_scout/services/api_services.dart';

class BooksViewModel {
  Future<List<BookListModel>> getSearchBook(String query) async {
    var bookList = <BookListModel>[];
    Map<String, dynamic> bookData = await ApiServices().searchBookByName(query);
    BookListModel bookListModel = BookListModel();
    bookListModel = BookListModel.fromJson(bookData);
    bookList.add(bookListModel);
    return bookList;
  }
}
