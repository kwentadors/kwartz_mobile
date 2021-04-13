import 'package:flutter/material.dart';

class ListTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => TransactionGroup(),
          itemCount: 20,
        ),
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
    return Card(
      child: Column(
        children: [
          TransactionGroupHeader(),
          Divider(
            // height: 5,
            color: Colors.black,
          ),
          Column(
            children: [
              JournalEntry(),
              Divider(),
              JournalEntry(),
              Divider(),
              JournalEntry(),
            ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "APR",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
            Text(
              "13",
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            Text(
              "Tue",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Amount",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
            ),
            Text(
              "25,360.92",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class JournalEntry extends StatelessWidget {
  const JournalEntry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
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
      ),
    );
  }
}

class JournalEntryDebit extends StatelessWidget {
  const JournalEntryDebit(this.journalEntry, {Key key}) : super(key: key);

  final Map<String, String> journalEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
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
      ),
    );
  }
}

class JournalEntryCredit extends StatelessWidget {
  const JournalEntryCredit(this.journalEntry, {Key key}) : super(key: key);

  final Map<String, String> journalEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
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
      padding: const EdgeInsets.only(left: 30.0),
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
