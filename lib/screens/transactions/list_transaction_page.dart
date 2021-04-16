import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';

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
              itemCount: 5,
            ),
          )
        ],
      ),
    );
  }

  List<Transaction> _fetchTransactions() {
    var transaction1 = Transaction()
      ..transactionDate = DateTime.now()
      ..description = "Some transaction not to remember";

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Savings - BDO")
      ..amount = 2618.93;

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Expense - Bank Charges")
      ..amount = 25.00;

    transaction1.createCreditEntry()
      ..account = FinancialAccount("Savings - Unionbank")
      ..amount = 2643.93;

    return <Transaction>[
      transaction1,
    ];
  }
}

class TransactionGroup extends StatelessWidget {
  const TransactionGroup({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var transaction1 = Transaction()
      ..transactionDate = DateTime.now()
      ..description = "Some transaction1 not to remember";

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Savings - BDO")
      ..amount = 2618.93;

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Expense - Bank Charges")
      ..amount = 25.00;

    transaction1.createCreditEntry()
      ..account = FinancialAccount("Savings - Unionbank")
      ..amount = 2643.93;

    final today = DateTime.now();

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
                  TransactionGroupHeader(DateTime.now()),
                  Divider(
                    height: 16,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          JournalEntryWidget(transaction1),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: 3,
                    ),
                  ),
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
                  today.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEE').format(today),
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
  final DateTime dateTime;

  const TransactionGroupHeader(
    this.dateTime, {
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

class DayGrouper {
  DayGrouper();

  Map<DateTime, List<Transaction>> group(List<Transaction> transactions) {
    var transaction1 = Transaction()
      ..transactionDate = DateTime.now()
      ..description = "Some transaction not to remember";

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Savings - BDO")
      ..amount = 2618.93;

    transaction1.createDebitEntry()
      ..account = FinancialAccount("Expense - Bank Charges")
      ..amount = 25.00;

    transaction1.createCreditEntry()
      ..account = FinancialAccount("Savings - Unionbank")
      ..amount = 2643.93;

    return {
      DateTime.now(): [transaction1],
    };
  }
}

class JournalEntryWidget extends StatelessWidget {
  final Transaction transaction;

  const JournalEntryWidget(
    this.transaction, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...transaction.debitEntries.map((e) => JournalEntryDebit(e)),
        ...transaction.creditEntries.map((e) => JournalEntryCredit(e)),
        if (transaction.description != null)
          JournalEntryDescription(transaction.description)
      ],
    );
  }
}

class JournalEntryDebit extends StatelessWidget {
  final JournalEntry journalEntry;

  const JournalEntryDebit(this.journalEntry, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(journalEntry.account.name),
        Row(
          children: [
            Container(
              width: 90,
              child: Text(
                journalEntry.amount.toStringAsFixed(2),
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
  final JournalEntry journalEntry;

  const JournalEntryCredit(this.journalEntry, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(journalEntry.account.name),
          Row(
            children: [
              SizedBox(
                width: 90,
              ),
              Container(
                width: 90,
                child: Text(
                  journalEntry.amount.toStringAsFixed(2),
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
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.clip,
            ),
          ),
          SizedBox(
            width: 90,
          ),
          SizedBox(
            width: 90,
          ),
        ],
      ),
    );
  }
}
