import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../book_details/book_details.dart';

class BookmarkListItem extends StatefulWidget {
  final String id;
  final String title;
  final String publisher;
  final String authors;
  final String image;
  final String description;
  final String isFavourite;
  final Function(String)? refreshCallback;

  const BookmarkListItem(
      {Key? key,
      required this.id,
      required this.title,
      required this.publisher,
      required this.authors,
      required this.image,
      required this.description,
      required this.isFavourite,
      this.refreshCallback})
      : super(key: key);

  @override
  _BookmarkListItemState createState() => _BookmarkListItemState();
}

class _BookmarkListItemState extends State<BookmarkListItem> {
  List<String> authorList = [];

  @override
  void initState() {
    super.initState();
    authorList.add(widget.authors);
  }

  getCallback(val) {
    if (widget.refreshCallback != null) {
      print(val);
      widget.refreshCallback!(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(
                        id: widget.id,
                        title: widget.title,
                        publisher: widget.publisher,
                        authors: authorList,
                        description: widget.description,
                        image: widget.image,
                        refreshCallback: getCallback)))
            .whenComplete(() => getCallback('when complete...'));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: HexColor('#E8D4D1'),
            borderRadius: BorderRadius.circular(20.0)),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              width: 80.0,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'By: ${widget.authors}',
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
