import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/list_transaction_bloc.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

class ListTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Transaction> transactions = _fetchTransactions();

    return BlocProvider<ListTransactionBloc>(
      create: (context) => ListTransactionBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text("Transactions")),
        body: BlocBuilder<ListTransactionBloc, ListTransactionState>(
          builder: (context, state) {
            if (state is ListTransactionInitial) {
              context.read<ListTransactionBloc>().add(FetchTransactionsEvent());
              return Center(
                child: Text("Initial state"),
              );
            } else if (state is ListTransactionLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return TransactionList(transactions: transactions);
          },
        ),
      ),
    );
  }

  List<Transaction> _fetchTransactions() {
    // TODO implementation
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

    var transaction2 = Transaction()..transactionDate = DateTime.now();

    transaction2.createDebitEntry()
      ..account = FinancialAccount("Expense - Personal")
      ..amount = 2000.00;

    transaction2.createCreditEntry()
      ..account = FinancialAccount("Savings - BDO")
      ..amount = 2000.00;

    var transaction3 = Transaction()
      ..transactionDate = DateTime.parse("2021-04-09");

    transaction3.createDebitEntry()
      ..account = FinancialAccount("Savings - BDO")
      ..amount = 11253.72;

    transaction3.createCreditEntry()
      ..account = FinancialAccount("Income - Arcanys")
      ..amount = 11253.72;

    return <Transaction>[
      transaction1,
      transaction2,
      transaction3,
    ];
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({Key key, @required this.transactions})
      : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final grouper = DayGrouper();
    final groupedTransactions = grouper.group(transactions);
    final keys = groupedTransactions.keys.toList();

    return Column(
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
            itemBuilder: (context, index) {
              final key = keys[index];
              return TransactionGroup(key, groupedTransactions[key]);
            },
            itemCount: keys.length,
          ),
        )
      ],
    );
  }
}

class TransactionGroup extends StatelessWidget {
  final DateTime grouping;
  final List<Transaction> transactions;

  const TransactionGroup(
    this.grouping,
    this.transactions, {
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
                          JournalEntryWidget(transactions[index]),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: transactions.length,
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
                  grouping.day.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEE').format(grouping),
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
    return transactions.fold({}, (Map result, transaction) {
      var dateKey = DateFormat.yMMMMd()
          .parse(DateFormat.yMMMMd().format(transaction.transactionDate));

      if (!result.containsKey(dateKey)) {
        result[dateKey] = <Transaction>[];
      }
      result[dateKey].add(transaction);

      return result;
    });
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
                NumberFormat.simpleCurrency(decimalDigits: 2, name: "")
                    .format(journalEntry.amount),
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
                  NumberFormat.simpleCurrency(decimalDigits: 2, name: "")
                      .format(journalEntry.amount),
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
