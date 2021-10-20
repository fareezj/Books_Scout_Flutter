import 'dart:io';
import 'package:book_scout/models/book_model.dart';
import 'package:book_scout/screens/book_read/widgets/book_read_list_item.dart';
import 'package:book_scout/screens/widgets/book_list_item.dart';
import 'package:book_scout/viewModels/books_view_model.dart';
import 'package:book_scout/viewModels/db_books_view_model.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalDataLength = 0;
  int totalBookToReadLength = 0;
  bool isLoading = true;
  bool isLoadingBookToRead = true;
  String searchText = "ronaldo";
  final myController = TextEditingController();
  var vm = BooksViewModel();
  final List<BookListModel> _bookList = <BookListModel>[];
  Future<List<Map>>? _readBooksData;
  static const TextStyle bottomNavStyle = TextStyle(fontSize: 18.0);
  DbBooksViewModel dbViewModel = DbBooksViewModel();

  @override
  void initState() {
    if (_bookList.isEmpty) {
      vm.getSearchBook(searchText).then((value) {
        setState(() {
          isLoading = false;
          _bookList.add(value[0]);
          for (var element in _bookList) {
            totalDataLength = element.bookItem!.length;
          }
        });
      });
      _readBooksData = dbViewModel.getAllReadBooks().then((value) {
        if (value.isNotEmpty) {
          setState(() {
            isLoadingBookToRead = false;
            totalBookToReadLength = value.length;
          });
          return value;
        } else {
          throw '';
        }
      });
    }
    super.initState();
  }

  searchBookList() {
    searchText = myController.text;
    vm.getSearchBook(myController.text).then((value) => setState(() {
          _bookList.clear();
          _bookList.addAll(value);
        }));
  }

  void refreshCallback(String val) {
    print(val);
    _readBooksData = dbViewModel.getAllReadBooks().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          isLoadingBookToRead = false;
          totalBookToReadLength = value.length;
        });
        print(value.length);
        return value;
      } else {
        throw '';
      }
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books Scout'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1.1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: myController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Input Book Name'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          searchBookList();
                        },
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              const DashboardTitle(title: 'Popular Books'),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: Platform.isIOS
                          ? 350
                          : MediaQuery.of(context).size.height / 2.35,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: totalDataLength,
                          itemBuilder: (BuildContext context, int index) {
                            return BookListItem(
                              onRefreshCallback: (val) => refreshCallback(val),
                              id: _bookList[0].bookItem?[index].id ?? "",
                              title: _bookList[0]
                                      .bookItem?[index]
                                      .volumeInfo
                                      ?.title ??
                                  "",
                              description: _bookList[0]
                                      .bookItem?[index]
                                      .volumeInfo
                                      ?.description ??
                                  "",
                              publisher: _bookList[0]
                                      .bookItem?[index]
                                      .volumeInfo
                                      ?.publisher ??
                                  "",
                              bookImage: _bookList[0]
                                      .bookItem?[index]
                                      .volumeInfo
                                      ?.imageLinks
                                      ?.smallThumbnail ??
                                  "",
                              authors: _bookList[0]
                                      .bookItem?[index]
                                      .volumeInfo
                                      ?.authors ??
                                  ["Unknown"],
                            );
                          }),
                    ),
              const DashboardTitle(title: 'Books to Read'),
              isLoadingBookToRead
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: Platform.isIOS
                          ? 350
                          : MediaQuery.of(context).size.height / 2.35,
                      child: FutureBuilder<List<Map>>(
                        future: _readBooksData,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Map>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: totalBookToReadLength,
                                itemBuilder: (BuildContext context, int index) {
                                  return (BookReadListItem(
                                    id: snapshot.data?[index]['id'] ?? "",
                                    title: snapshot.data?[index]['title'] ?? "",
                                    description: snapshot.data?[index]
                                            ['description'] ??
                                        "",
                                    publisher: snapshot.data?[index]
                                            ['publisher'] ??
                                        "",
                                    bookImage:
                                        snapshot.data?[index]['image'] ?? "",
                                    authors:
                                        snapshot.data?[index]['author'] ?? "",
                                  ));
                                });
                          } else {
                            return Text('No Data');
                          }
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardTitle extends StatelessWidget {
  final String title;
  const DashboardTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
