import 'package:book_scout/screens/book_read/book_read_details.dart';
import 'package:flutter/material.dart';

class BookReadListItem extends StatelessWidget {
  final String id;
  final String title;
  final String publisher;
  final String description;
  final String bookImage;
  final String authors;

  const BookReadListItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.publisher,
      required this.description,
      required this.bookImage,
      required this.authors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookReadDetails(
                            id: id,
                          )));
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 0.0),
                      height: 200,
                      width: double.infinity,
                      child: Image.network(bookImage, errorBuilder:
                          (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                        // Appropriate logging or analytics, e.g.
                        // myAnalytics.recordError(
                        //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                        //   exception,
                        //   stackTrace,
                        // );
                        return const Text('😢');
                      }, fit: BoxFit.fill)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'By: $authors',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
