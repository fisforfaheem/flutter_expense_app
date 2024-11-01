import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange.shade800, Colors.blue.shade600],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset('assets/images/playstore.png',
                    width: 100, height: 100),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  'Knowledge Zone',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  String name;

  Person(this.name);
}

@HiveType(typeId: 1)
class Expense extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  double totalAmount;
  @HiveField(2)
  Map<String, double> individualAmounts;
  @HiveField(3)
  List<String> involvedPeople;

  Expense(
      this.date, this.totalAmount, this.individualAmounts, this.involvedPeople);
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Person>('people');
  await Hive.openBox<Expense>('expenses');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Distribution',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF16213E),
          elevation: 0,
        ),
        cardColor: const Color(0xFF16213E),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NewExpensePage(),
    PeopleManagementPage(),
    HistoryPage(),
    AnalyticsPage(),
    //add a settings page
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  activeIcon: Icon(Icons.add_circle),
                  label: '💰 New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people),
                  label: '👥 People',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  activeIcon: Icon(Icons.history),
                  label: '📅 History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  activeIcon: Icon(Icons.analytics),
                  label: '📊 Analytics',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  _NewExpensePageState createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage>
    with SingleTickerProviderStateMixin {
  final _peopleBox = Hive.box<Person>('people');
  final _expensesBox = Hive.box<Expense>('expenses');
  double totalAmount = 0;
  Map<String, double> individualAmounts = {};
  List<String> involvedPeople = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💸 New Expense',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: '💵 Total Amount',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    totalAmount = double.tryParse(value) ?? 0;
                    _distributeAmount();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '👥 Select Involved People:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _peopleBox.listenable(),
                builder: (context, Box<Person> box, _) {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final person = box.getAt(index)!;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          alignment: Alignment.center,
                          child: CheckboxListTile(
                            title: Text(person.name),
                            value: involvedPeople.contains(person.name),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  involvedPeople.add(person.name);
                                } else {
                                  involvedPeople.remove(person.name);
                                }
                                _distributeAmount();
                              });
                            },
                            secondary: GestureDetector(
                              onTap: () => _adjustAmount(person.name),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Rs: ${individualAmounts[person.name]?.toStringAsFixed(2) ?? "0.00"}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveExpense,
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _distributeAmount() {
    if (involvedPeople.isEmpty) return;
    double amountPerPerson = totalAmount / involvedPeople.length;
    individualAmounts = {
      for (var person in involvedPeople) person: amountPerPerson
    };
    setState(() {});
  }

  void _adjustAmount(String person) {
    showDialog(
      context: context,
      builder: (context) {
        double extraAmount = 0;
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: Text('Adjust amount for $person'),
              content: TextField(
                decoration: InputDecoration(
                  labelText: 'Extra amount',
                  errorText: errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  extraAmount = double.tryParse(value) ?? 0;
                  setState(() {
                    errorText =
                        extraAmount < 0 ? 'Amount cannot be negative' : null;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: errorText == null
                      ? () {
                          setState(() {
                            individualAmounts[person] =
                                (individualAmounts[person] ?? 0) + extraAmount;
                            totalAmount += extraAmount;
                          });
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveExpense() {
    if (totalAmount <= 0 || involvedPeople.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter a valid amount and select at least one person.')),
      );
      return;
    }

    final expense = Expense(DateTime.now(), totalAmount,
        Map.from(individualAmounts), List.from(involvedPeople));
    _expensesBox.add(expense);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense saved successfully!')),
    );

    setState(() {
      totalAmount = 0;
      individualAmounts.clear();
      involvedPeople.clear();
    });
  }
}

class PeopleManagementPage extends StatelessWidget {
  final _peopleBox = Hive.box<Person>('people');

  PeopleManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👥 Manage People',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _peopleBox.listenable(),
              builder: (context, Box<Person> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final person = box.getAt(index)!;
                    return Dismissible(
                      key: Key(person.name),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deletePerson(context, person),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.white70),
                          title: Text(person.name),
                          trailing: const Icon(Icons.swipe_left,
                              color: Colors.white54),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: () => _addPerson(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Person'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPerson(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newPerson = '';
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF16213E),
              title: const Text('Add Person 👤'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    enabled: !isLoading,
                    onChanged: (value) => newPerson = value,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed:
                      isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (newPerson.isNotEmpty) {
                            setState(() => isLoading = true);
                            await _peopleBox.add(Person(newPerson));
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deletePerson(BuildContext context, Person person) {
    person.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${person.name} has been deleted')),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final _expensesBox = Hive.box<Expense>('expenses');

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📅 Expense History',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _expensesBox.listenable(),
              builder: (context, Box<Expense> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final expense = box.getAt(box.length - 1 - index)!;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long,
                            color: Colors.white70),
                        title: Text(
                            DateFormat('MMM dd, yyyy').format(expense.date)),
                        subtitle: Text(
                          '💰 Total: Rs ${expense.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          '👥 ${expense.involvedPeople.length} people',
                          style: const TextStyle(color: Colors.white54),
                        ),
                        onTap: () => _showExpenseDetails(context, expense),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Expense Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Date: ${DateFormat('yyyy-MM-dd').format(expense.date)}'),
                Text('Total: Rs: ${expense.totalAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                const Text('Individual Amounts:'),
                ...expense.individualAmounts.entries.map(
                  (e) => Text('${e.key}: Rs: ${e.value.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    expense.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense has been deleted')),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  final _expensesBox = Hive.box<Expense>('expenses');

  AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Analytics Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _expensesBox.listenable(),
              builder: (context, Box<Expense> box, _) {
                List<Expense> expenses = box.values.toList();
                expenses.sort((a, b) => b.date.compareTo(a.date));

                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bar_chart_sharp,
                            size: 64, color: Colors.white.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No expenses recorded yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  children: [
                    _buildTotalSpendingWidget(expenses),
                    const SizedBox(height: 20),
                    _buildMonthlySpendingWidget(expenses),
                    const SizedBox(height: 20),
                    _buildTopSpendersWidget(expenses),
                    const SizedBox(height: 20),
                    _buildRecentTransactionsWidget(expenses),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSpendingWidget(List<Expense> expenses) {
    double totalSpending =
        expenses.fold(0, (sum, expense) => sum + expense.totalAmount);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text(
                '💰 Total Spending',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₹${totalSpending.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
          Text(
            '${expenses.length} total transactions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySpendingWidget(List<Expense> expenses) {
    Map<String, double> monthlySpending = {};

    for (var expense in expenses) {
      String monthYear = DateFormat('MMM yyyy').format(expense.date);
      monthlySpending[monthYear] =
          (monthlySpending[monthYear] ?? 0) + expense.totalAmount;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Text(
                '📅 Monthly Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...monthlySpending.entries.take(3).map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      '₹${entry.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopSpendersWidget(List<Expense> expenses) {
    Map<String, double> totalSpendingByPerson = {};
    for (var expense in expenses) {
      expense.individualAmounts.forEach((person, amount) {
        totalSpendingByPerson[person] =
            (totalSpendingByPerson[person] ?? 0) + amount;
      });
    }

    List<MapEntry<String, double>> sortedSpenders =
        totalSpendingByPerson.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                '🏆 Top Spenders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedSpenders.take(5).map((spender) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      child: Text(
                        spender.key[0].toUpperCase(),
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(spender.key),
                    ),
                    Text(
                      '₹${spender.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsWidget(List<Expense> expenses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                '🕒 Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...expenses.take(3).map((expense) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.receipt, color: Colors.blueAccent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(expense.date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${expense.involvedPeople.length} people involved',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${expense.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
