import 'package:flutter/material.dart';

class SaveTransactionPage extends StatefulWidget {
  @override
  _SaveTransactionPageState createState() => _SaveTransactionPageState();
}

class _SaveTransactionPageState extends State<SaveTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var sectionTitlePadding = SizedBox(height: 20.0);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Transaction"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Card(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Transaction Date",
                      ),
                    ),
                    sectionTitlePadding,
                    dividerWidget('Debit'),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Account",
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Amount",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sectionTitlePadding,
                    dividerWidget('Credit'),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Account",
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Amount",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "2,500.75",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container dividerWidget(final String title) {
    return Container(
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
