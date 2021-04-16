import 'package:flutter/material.dart';

class ListTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: Column(
        children: [
          Container(
            height: 35,
            width: double.infinity,
            child: Center(
              child: Text(
                "APRIL 2021",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            color: Theme.of(context).primaryColorLight,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => TransactionGroup(),
              itemCount: 20,
            ),
          )
        ],
      ),
    );
  }
}

class TransactionGroup extends StatelessWidget {
  const TransactionGroup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Card(
              child: Column(
                children: [
                  TransactionGroupHeader(),
                  Divider(
                    height: 16,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => JournalEntry(),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: 5,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "13",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Wednesday",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[100],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionGroupHeader extends StatelessWidget {
  const TransactionGroupHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 50,
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 2.0),
            Text(
              "Amount",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Text(
              "25,360.92",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JournalEntry extends StatelessWidget {
  const JournalEntry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JournalEntryDebit({
          "name": "Cash",
          "amount": "3,850.00",
        }),
        JournalEntryCredit({
          "name": "Accounts Receivable",
          "amount": "3,500.00",
        }),
        JournalEntryCredit({
          "name": "Income",
          "amount": "350.00",
        }),
        JournalEntryDescription("One-time millionaire")
      ],
    );
  }
}

class JournalEntryDebit extends StatelessWidget {
  const JournalEntryDebit(this.journalEntry, {Key key}) : super(key: key);

  final Map<String, String> journalEntry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(journalEntry["name"]),
        Row(
          children: [
            Container(
              width: 90,
              child: Text(
                journalEntry["amount"],
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(
              width: 90,
            )
          ],
        ),
      ],
    );
  }
}

class JournalEntryCredit extends StatelessWidget {
  const JournalEntryCredit(this.journalEntry, {Key key}) : super(key: key);

  final Map<String, String> journalEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(journalEntry["name"]),
          Row(
            children: [
              SizedBox(
                width: 90,
              ),
              Container(
                width: 90,
                child: Text(
                  journalEntry["amount"],
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class JournalEntryDescription extends StatelessWidget {
  const JournalEntryDescription(this.description, {Key key}) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          Text(
            description,
            textAlign: TextAlign.start,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(
            width: 90,
          ),
          SizedBox(
            width: 90,
          )
        ],
      ),
    );
  }
}
