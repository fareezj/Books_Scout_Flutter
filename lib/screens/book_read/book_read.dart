import 'package:book_scout/screens/book_read/widgets/book_read_list_item.dart';
import 'package:book_scout/viewModels/db_books_view_model.dart';
import 'package:flutter/material.dart';

class BookRead extends StatefulWidget {
  const BookRead({Key? key}) : super(key: key);

  @override
  _BookReadState createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  DbBooksViewModel dbViewModel = DbBooksViewModel();
  Future<List<Map>>? _readBooksData;

  @override
  void initState() {
    super.initState();
    _readBooksData = dbViewModel.getAllReadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final double screenAspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Books to Read'),
        ),
        body: FutureBuilder<List<Map>>(
          future: _readBooksData,
          builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: screenAspectRatio / 0.7,
                      crossAxisCount: 2),
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (BookReadListItem(
                      id: snapshot.data?[index]['id'] ?? "",
                      title: snapshot.data?[index]['title'] ?? "",
                      description: snapshot.data?[index]['description'] ?? "",
                      publisher: snapshot.data?[index]['publisher'] ?? "",
                      bookImage: snapshot.data?[index]['image'] ?? "",
                      authors: snapshot.data?[index]['author'] ?? "",
                    ));
                  });
            } else {
              return Text('No Data');
            }
          },
        ));
  }
}
