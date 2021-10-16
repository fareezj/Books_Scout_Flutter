import 'dart:io';
import 'package:book_scout/models/book_model.dart';
import 'package:book_scout/screens/saved_books.dart';
import 'package:book_scout/screens/widgets/book_list_item.dart';
import 'package:book_scout/viewModels/books_view_model.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalDataLength = 0;
  bool isLoading = true;
  String searchText = "ronaldo";
  final myController = TextEditingController();
  var vm = BooksViewModel();
  final List<BookListModel> _bookList = <BookListModel>[];
  static const TextStyle bottomNavStyle = TextStyle(fontSize: 18.0);

  @override
  void initState() {
    vm.getSearchBook(searchText).then((value) {
      setState(() {
        isLoading = false;
        _bookList.add(value[0]);
        for (var element in _bookList) {
          totalDataLength = element.bookItem!.length;
        }
      });
    });
    super.initState();
  }

  searchBookList() {
    searchText = myController.text;
    vm.getSearchBook(myController.text).then((value) => setState(() {
          _bookList.clear();
          _bookList.addAll(value);
        }));
  }

  @override
  void dispose() {
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
          height: MediaQuery.of(context).size.height,
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
                        child: const Text('Search Book'),
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
