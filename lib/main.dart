import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'main.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //add icon here
            Icon(Icons.wallet, size: 100),
            SizedBox(height: 20),
            Text('Expense Distribution',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Learn more about this app'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.green),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Read our privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Distribution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.group, size: 40, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Manage and split expenses among friends and groups with ease.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 40, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Keep track of who owes what and settle up easily.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.pie_chart, size: 40, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Visualize your expenses with detailed charts and graphs.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Easy expense tracking'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Group expense management'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Detailed reports and analytics'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('Secure and private'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.blue),
                title: Text('User-friendly interface'),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We are a team of passionate developers dedicated to making expense management easy and efficient. Our goal is to help you keep track of your expenses and manage your finances better.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  PrivacyPolicyPage({super.key});
  String url = 'https://www.google.com';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted)),
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
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
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
    const SettingsPage(),
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics), label: 'Analytics'),
            //add a settings barItem
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue.withOpacity(0.1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
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
              'New Expense',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 60,
              alignment: Alignment.center,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
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
              'Select Involved People:',
              style: Theme.of(context).textTheme.titleLarge,
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
        return AlertDialog(
          title: Text('Adjust amount for $person'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Extra amount'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              extraAmount = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  individualAmounts[person] =
                      (individualAmounts[person] ?? 0) + extraAmount;
                  totalAmount += extraAmount;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
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
            'Manage People',
            style: Theme.of(context).textTheme.headlineMedium,
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
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deletePerson(context, person),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(person.name),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _addPerson(context),
            child: const Text('Add Person'),
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
        return AlertDialog(
          title: const Text('Add Person'),
          content: TextField(
            onChanged: (value) {
              newPerson = value;
            },
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newPerson.isNotEmpty) {
                  _peopleBox.add(Person(newPerson));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
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
            'Expense History',
            style: Theme.of(context).textTheme.headlineMedium,
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
                    return Dismissible(
                      key: Key(expense.date.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _deleteExpense(context, expense),
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                              DateFormat('yyyy-MM-dd').format(expense.date)),
                          subtitle: Text(
                              'Total: Rs: ${expense.totalAmount.toStringAsFixed(2)}'),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
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
            'Analytics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _expensesBox.listenable(),
              builder: (context, Box<Expense> box, _) {
                List<Expense> expenses = box.values.toList();
                expenses.sort((a, b) => b.date.compareTo(a.date));
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTotalSpendingWidget(expenses),
                      const SizedBox(height: 20),
                      _buildTopSpendersWidget(expenses),
                    ],
                  ),
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
      width: double.infinity,
      height: 100,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Total Spending', style: TextStyle(fontSize: 18)),
          Text('Rs: ${totalSpending.toStringAsFixed(2)}',
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
      width: double.infinity,
      height: 300,
      alignment: Alignment.center,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Top Spenders', style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedSpenders.length.clamp(0, 5),
              itemBuilder: (context, index) {
                final spender = sortedSpenders[index];
                return ListTile(
                  title: Text(spender.key),
                  trailing: Text('Rs: ${spender.value.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
