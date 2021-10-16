import 'dart:convert';

import 'package:book_scout/models/db_book_model.dart';
import 'package:book_scout/screens/book_details/widgets/add_read_button.dart';
import 'package:book_scout/viewModels/db_books_view_model.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final List<dynamic>? authors;
  final String? publisher;
  final String? description;
  final String? image;
  final Function(String)? refreshCallback;

  const BookDetailsScreen(
      {Key? key,
      this.id,
      this.title,
      this.authors,
      this.publisher,
      this.description,
      this.image,
      this.refreshCallback})
      : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  DbBooksViewModel dbViewModel = DbBooksViewModel();
  List<Map>? dbInitData;
  bool isBookAlreadyStored = false;
  bool isBookmarked = false;
  bool isAddedToReadList = false;
  DbBookModel? bookDetails;

  @override
  void initState() {
    super.initState();
    bookInfoInitialCheck();
    bookDetails = DbBookModel(
        id: widget.id!,
        title: widget.title!,
        publisher: widget.publisher!,
        authors: widget.authors![0],
        image: widget.image!,
        description: widget.description!,
        isFavourite: "false",
        isAddedToReadList: "false");
  }

  void parseValue(value) {
    var tagJson = jsonDecode(value[0]['sideNotes']);
    print(tagJson.runtimeType);
  }

  void checkingBookInfo(String fieldName, List<dynamic> value) {
    switch (fieldName) {
      case "isFavourite":
        if (value[0]["isFavourite"] == "true") {
          setState(() => {isBookmarked = true});
        } else {
          setState(() => {isBookmarked = false});
        }
        break;
      case "isAddedToReadList":
        if (value[0]["isAddedToReadList"] == "true") {
          setState(() => {isAddedToReadList = true});
        } else {
          setState(() => {isAddedToReadList = false});
        }
        break;
      default:
    }
    print(value);
  }

  void bookInfoInitialCheck() {
    dbViewModel.getBookmark(widget.id!).then((value) => {
          if (value.isNotEmpty)
            {
              checkingBookInfo("isAddedToReadList", value),
              checkingBookInfo("isFavourite", value)
            }
        });
    // dbViewModel.getAllReadBooks().then((value) => parseValue(value));
  }

  // void onAddToRead() {
  //   String sideNotesEncode = jsonEncode([
  //     {
  //       'bookId': widget.id!,
  //       'note': 'Gonna read it',
  //       'dateTime': '01 Sept 2021'
  //     },
  //     {
  //       'bookId': widget.id!,
  //       'note': 'Gonna read it',
  //       'dateTime': '02 Sept 2021'
  //     },
  //     {
  //       'bookId': widget.id!,
  //       'note': 'Gonna read it',
  //       'dateTime': '03 Sept 2021'
  //     },
  //     {
  //       'bookId': widget.id!,
  //       'note': 'Gonna read it',
  //       'dateTime': '04 Sept 2021'
  //     }
  //   ]);

  //   dbViewModel.addToRead(DbBookReadModel(
  //       idRead: widget.id!,
  //       reviews: 'Nice book to read',
  //       sideNotes: sideNotesEncode));
  // }

  Future<void> bookmarkExistCheck() async {
    dbViewModel.getBookmark(widget.id!).then((value) => {
          value.isNotEmpty
              ? setState(() => {isBookAlreadyStored = true})
              : setState(() => {isBookAlreadyStored = false})
        });
    if (!isBookAlreadyStored) {
      await dbViewModel.addBookmark(bookDetails!).then((value) => {
            setState(() => {isBookAlreadyStored = true})
          });
    }
  }

  void onBookmarkBook() {
    bookmarkExistCheck().then((value) => {
          if (isBookAlreadyStored)
            {
              isBookmarked
                  ? setState(() {
                      bookDetails!.isAddedToReadList =
                          isAddedToReadList.toString();
                      bookDetails!.isFavourite = "false";
                    })
                  : setState(() {
                      bookDetails!.isAddedToReadList =
                          isAddedToReadList.toString();
                      bookDetails!.isFavourite = "true";
                    }),
              dbViewModel
                  .updateBookmark(widget.id!, bookDetails!)
                  .then((value) => {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        })
                      })
            }
        });
    if (widget.refreshCallback != null) {
      widget.refreshCallback!('Hello refresh');
      // print('Total Bookmark now: ');
      // dbViewModel.getAllBookmark().then((value) => print(value.length));
    }
  }

  void onAddToReadList() {
    bookmarkExistCheck().then((value) => {
          if (isBookAlreadyStored)
            {
              isAddedToReadList
                  ? setState(() {
                      bookDetails!.isFavourite = isBookmarked.toString();
                      bookDetails!.isAddedToReadList = "false";
                    })
                  : setState(() {
                      bookDetails!.isFavourite = isBookmarked.toString();
                      bookDetails!.isAddedToReadList = "true";
                    }),
              dbViewModel
                  .updateBookmark(widget.id!, bookDetails!)
                  .then((value) => {
                        setState(() {
                          isAddedToReadList = !isAddedToReadList;
                        }),
                        dbViewModel.addToReadDetails(DbBookReadModel(
                            idRead: widget.id!, reviews: '', sideNotes: ''))
                      })
            }
        });
    if (widget.refreshCallback != null) {
      widget.refreshCallback!('Hello refresh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Null"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => onBookmarkBook(),
              child: isBookmarked
                  ? const Icon(Icons.bookmark_outlined)
                  : const Icon(Icons.bookmark_add_outlined),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.expand(
                  width: double.infinity, height: 400),
              child: Image.network(
                widget.image ?? "null",
                fit: BoxFit.fill,
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? "Unknown",
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(
                        widget.authors![0] ?? "Unknown",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isAddedToReadList
                              ? AddToReadListButton(
                                  buttonStatus: isAddedToReadList,
                                  buttonText: 'Added to Read List',
                                  clickCallback: onAddToReadList)
                              : AddToReadListButton(
                                  buttonStatus: isAddedToReadList,
                                  buttonText: 'Add to Read List',
                                  clickCallback: onAddToReadList)
                        ],
                      )
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(widget.description ?? ""),
            )
          ],
        ),
      ),
    );
  }
}
