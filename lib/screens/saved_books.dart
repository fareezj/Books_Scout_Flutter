import 'package:book_scout/screens/dashboard/dashboard.dart';
import 'package:book_scout/screens/widgets/bookmark_list_item.dart';
import 'package:book_scout/viewModels/db_books_view_model.dart';
import 'package:flutter/material.dart';

class SavedBooks extends StatefulWidget {
  const SavedBooks({Key? key}) : super(key: key);
  @override
  _SavedBooksState createState() => _SavedBooksState();
}

class _SavedBooksState extends State<SavedBooks> {
  Future<List<Map>>? _bookmarkData;
  DbBooksViewModel dbViewModel = DbBooksViewModel();

  @override
  void initState() {
    super.initState();
    _bookmarkData = dbViewModel.getAllBookmark();
  }

  onRefreshCallback(val) {
    setState(() {
      _bookmarkData = dbViewModel.getAllBookmark();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 30.0),
        height: double.infinity,
        child: FutureBuilder<List<Map>>(
            future: _bookmarkData,
            builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return (BookmarkListItem(
                        id: snapshot.data![index]["id"],
                        title: snapshot.data![index]["title"],
                        publisher: snapshot.data![index]["publisher"],
                        authors: snapshot.data![index]["author"],
                        image: snapshot.data![index]["image"],
                        description: snapshot.data![index]["description"],
                        isFavourite: 'true',
                        refreshCallback: onRefreshCallback,
                      ));
                    });
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Result: ${snapshot.data}'),
                );
              }
            }),
      ),
    );
  }
}
