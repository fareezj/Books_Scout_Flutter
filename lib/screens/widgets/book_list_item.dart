import 'package:flutter/material.dart';
import '../book_details/book_details.dart';

class BookListItem extends StatefulWidget {
  final String id;
  final String title;
  final String publisher;
  final String description;
  final String bookImage;
  final List<dynamic> authors;

  const BookListItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.publisher,
      required this.description,
      required this.bookImage,
      required this.authors})
      : super(key: key);

  @override
  _BookListItemState createState() => _BookListItemState();
}

class _BookListItemState extends State<BookListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.only(right: 20.0, bottom: 5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(
                          id: widget.id,
                          title: widget.title,
                          publisher: widget.publisher,
                          authors: widget.authors,
                          description: widget.description,
                          image: widget.bookImage,
                        )));
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    height: 250,
                    width: double.infinity,
                    child: Image.network(widget.bookImage, errorBuilder:
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
                          widget.title,
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
                          'By: ${widget.authors[0] ?? "Unknown"}',
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
        ));
  }
}
