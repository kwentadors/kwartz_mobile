import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kwartz_mobile/utils/router.dart';
import '../repositories/transaction_repository.dart';
import '../blocs/list_transaction_bloc.dart';
import '../models/transaction.dart';

class ListTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListTransactionBloc>(
      create: (context) => ListTransactionBloc(
        context.read<TransactionRepository>(),
      ),
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
              return LoadingTransactionList();
            } else if (state is ListTransactionReady) {
              return TransactionList(transactions: state.transactions);
            } else {
              return Center(
                child: Text(
                    "Unable to handle bloc state: ${state.runtimeType.toString()}"),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pushNamed(context, Routes.TransactionNew);
            print("go to add transaction page");
          },
        ),
      ),
    );
  }
}

class LoadingTransactionList extends StatelessWidget {
  const LoadingTransactionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthlyGroupHeader(),
        Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
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
    var keys = groupedTransactions.keys.toList();
    keys.sort();
    keys = keys.reversed.toList();

    return Column(
      children: [
        MonthlyGroupHeader(),
        if (transactions.length == 0)
          Expanded(
            child: Center(
              child: Text("No transactions for this month."),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final key = keys[index];
                return TransactionGroup(
                  key,
                  groupedTransactions[key]['transactions'] as List<Transaction>,
                  groupedTransactions[key]['amount'],
                );
              },
              itemCount: keys.length,
            ),
          )
      ],
    );
  }

  Widget nonEmptyList() {
    final grouper = DayGrouper();

    final groupedTransactions = grouper.group(transactions);
    var keys = groupedTransactions.keys.toList();
    keys.sort();
    keys = keys.reversed.toList();

    return Column(
      children: [
        MonthlyGroupHeader(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final key = keys[index];
              return TransactionGroup(
                key,
                groupedTransactions[key]['transactions'] as List<Transaction>,
                groupedTransactions[key]['amount'],
              );
            },
            itemCount: keys.length,
          ),
        )
      ],
    );
  }
}

class MonthlyGroupHeader extends StatelessWidget {
  const MonthlyGroupHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListTransactionBloc, ListTransactionState>(
      builder: (context, state) {
        var previousButton = FlatButton(
          padding: EdgeInsets.zero,
          child:
              Text("<< ${state.previousMonthName} ${state.previousMonthYear}"),
          onPressed: () {
            context
                .read<ListTransactionBloc>()
                .add(UpdateDateFilterEvent(state.previousMonth));
          },
        );

        var nextButton = FlatButton(
          padding: EdgeInsets.zero,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("${state.nextMonthName} ${state.nextMonthYear} >>"),
          ),
          onPressed: () {
            context
                .read<ListTransactionBloc>()
                .add(UpdateDateFilterEvent(state.nextMonth));
          },
        );

        return Container(
          height: 45,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  previousButton,
                  SizedBox(width: 15),
                  Text(
                    "${state.monthName} ${state.year}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 15),
                  nextButton,
                ],
              ),
            ],
          ),
          color: Theme.of(context).primaryColorLight,
        );
      },
    );
  }
}

class TransactionGroup extends StatelessWidget {
  final DateTime grouping;
  final List<Transaction> transactions;
  final double amount;

  const TransactionGroup(
    this.grouping,
    this.transactions,
    this.amount, {
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
                  TransactionGroupHeader(DateTime.now(), amount),
                  Divider(
                    height: 16,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
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
  final double amount;

  const TransactionGroupHeader(
    this.dateTime,
    this.amount, {
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
              NumberFormat.simpleCurrency(decimalDigits: 2, name: "")
                  .format(amount),
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

  Map<DateTime, dynamic> group(List<Transaction> transactions) {
    var result = transactions.fold({}, (Map result, transaction) {
      var dateKey = DateFormat.yMMMMd()
          .parse(DateFormat.yMMMMd().format(transaction.transactionDate));

      if (!result.containsKey(dateKey)) {
        result[dateKey] = {};
        result[dateKey]['transactions'] = <Transaction>[];
      }
      result[dateKey]['transactions'].add(transaction);

      return result;
    });

    result.forEach((key, value) {
      value['amount'] = (value['transactions'] as List<Transaction>)
          .fold(0, (sum, trx) => sum + trx.amount);
    });

    return Map<DateTime, dynamic>.from(result);
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
