import 'package:book_scout/models/db_book_model.dart';
import 'package:book_scout/screens/dashboard/dashboard.dart';
import 'package:book_scout/viewModels/db_books_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class BookReadDetails extends StatefulWidget {
  final String id;
  const BookReadDetails({Key? key, required this.id}) : super(key: key);

  @override
  _BookReadDetailsState createState() => _BookReadDetailsState();
}

class _BookReadDetailsState extends State<BookReadDetails> {
  DbBooksViewModel dbViewModel = DbBooksViewModel();
  List<Map>? _readBookDetails = <Map>[];
  bool _descTileExpanded = false;
  DbBookReadModel? _bookReadDetails;
  bool isEditingReview = false;
  String textReview = "";

  @override
  void initState() {
    super.initState();
    dbViewModel.getBookmark(widget.id).then((value) => {
          setState(() => {_readBookDetails = value})
        });
    dbViewModel.getReadBookDetails(widget.id).then((value) => {
          if (value.isNotEmpty)
            {
              setState(() => {
                    _bookReadDetails = DbBookReadModel(
                        idRead: widget.id,
                        reviews: value[0]['reviews'],
                        sideNotes: value[0]['sideNotes'])
                  })
            }
        });
  }

  void editReviewFlag(bool value, {String review = ""}) {
    setState(() {
      isEditingReview = value;
    });
    if (!value && _bookReadDetails != null) {
      setState(() {
        textReview = review;
      });
      setState(() {
        _bookReadDetails!.reviews = review;
      });
      dbViewModel.addToReadDetails(_bookReadDetails!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Book Details'),
        ),
        body: _readBookDetails!.isNotEmpty
            ? SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 3.5,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 5.0,
                          decoration: BoxDecoration(color: HexColor('#A7C798')),
                        ),
                        Positioned(
                          top: 60,
                          left: 35,
                          child: Image.network(
                            _readBookDetails![0]['image'],
                            fit: BoxFit.fill,
                            height: 200,
                          ),
                        ),
                        Positioned(
                            bottom: 100,
                            left: 200,
                            child: SizedBox(
                                width: 200,
                                child: Text(
                                  _readBookDetails![0]['title'],
                                  style: GoogleFonts.zillaSlab(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                ))),
                        Positioned(
                            bottom: 35,
                            left: 200,
                            child: SizedBox(
                                width: 200,
                                child: Text(
                                  'By: ${_readBookDetails![0]['author']}',
                                  style: GoogleFonts.zillaSlab(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                ))),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.0, color: HexColor('#A7C798')),
                                borderRadius: BorderRadius.circular(10.0)),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 30.0),
                            child: ExpansionTile(
                              title: const Text('Synopsis'),
                              trailing: Icon(_descTileExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child:
                                      Text(_readBookDetails![0]['description']),
                                )
                              ],
                              onExpansionChanged: (bool expanded) {
                                setState(() => _descTileExpanded = expanded);
                              },
                            )),
                        const DashboardTitle(title: 'Your Review'),
                        Container(
                            child: isEditingReview
                                ? ReviewInput(
                                    initialValue: _bookReadDetails!.reviews,
                                    onTapEdit: (status, review) =>
                                        editReviewFlag(status, review: review),
                                  )
                                : ReviewDisplay(
                                    textReview: _bookReadDetails!.reviews,
                                    onTapEdit: (val) => editReviewFlag(val),
                                  ))
                      ],
                    )
                  ],
                ),
              )
            : const Text('Error getting data'));
  }
}

class ReviewDisplay extends StatelessWidget {
  final Function(bool) onTapEdit;
  final String textReview;
  const ReviewDisplay(
      {Key? key, required this.onTapEdit, required this.textReview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          FittedBox(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(20.0),
              child: Text(textReview),
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: HexColor('#A7C798')),
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0)),
                child: GestureDetector(
                  onTap: () => onTapEdit(true),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ReviewInput extends StatefulWidget {
  final Function(bool, String) onTapEdit;
  final String initialValue;
  const ReviewInput(
      {Key? key, required this.onTapEdit, required this.initialValue})
      : super(key: key);

  @override
  _ReviewInputState createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  @override
  Widget build(BuildContext context) {
    final textReviewController = TextEditingController();
    textReviewController.text = widget.initialValue;

    @override
    void dispose() {
      // Clean up the controller when the widget is removed from the
      // widget tree.
      textReviewController.dispose();
      super.dispose();
    }

    return Container(
        child: Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            width: 400.0,
            child: TextField(
              controller: textReviewController,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: HexColor('#A7C798')),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: HexColor('#A7C798'), width: 2.0),
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Input Book Review'),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0)),
              child: GestureDetector(
                onTap: () => widget.onTapEdit(false, textReviewController.text),
                child: Icon(Icons.done, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
