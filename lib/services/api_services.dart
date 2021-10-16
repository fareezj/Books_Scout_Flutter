
import 'package:book_scout/services/network_helper.dart';

class ApiServices {

  Future<dynamic> searchBookByName(String query) async {
    String url = "https://www.googleapis.com/books/v1/volumes?q=$query&key=AIzaSyAT1MKgVWXHzH3TMl22-Thsd4XAVm-OMQE&maxResults=40";
    NetworkHelper networkHelper = NetworkHelper(url);
    Map<String, dynamic> booksData = await networkHelper.getApiData();
    return booksData;
  }
}