import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({Key key, @required this.res}) : super(key: key);
  final List<Map<String, dynamic>> res;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Take measurement again',
                  style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
            ),
            Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index == 0 || index == res.length + 1) {
                      return Container();
                    }
                    return Card(
                      child: ListTile(
                        leading: Text(res[index-1].keys.elementAt(0)),
                        trailing: Text(res[index-1].values.elementAt(0)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(height: 5),
                  itemCount: res.length + 2,
                )
            )
          ],
        ));
  }
}
