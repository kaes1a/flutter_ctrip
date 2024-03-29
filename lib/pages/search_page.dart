import 'package:flutter/material.dart';
import 'package:flutter_ctrip/dao/search_dao.dart';
import 'package:flutter_ctrip/model/search_model.dart';
import 'package:flutter_ctrip/widget/search_bar.dart';

const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _appBar,
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                  itemCount: searchModel?.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return _item(position);
                  }),
            ))
      ],
    ));
  }

  void _onTextChanged(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChanged,
            ),
          ),
        )
      ],
    );
  }

  Widget _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return Text(item.word);
  }
}
