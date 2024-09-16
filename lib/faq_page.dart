import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: const Text(
              'FAQ 1: How to use this app?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 1: How to use this app?',
                  content:
                      'This app helps you track your expenses easily. You can add, view, and delete expenses, as well as generate reports to analyze your spending habits. '
                      'To get started, simply create an account or log in if you already have one. Once logged in, you can start adding your expenses by clicking on the add button. '
                      'You can categorize your expenses, set budgets, and even get notifications for upcoming bills. The app also allows you to export your data for further analysis.',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_circle_outline, color: Colors.green),
            title: const Text(
              'FAQ 2: How to add a new expense?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 2: How to add a new expense?',
                  content:
                      'Click on the add button on the main screen, fill in the details such as amount, category, and date, and then save the expense. '
                      'You can also add a description to each expense to keep track of what it was for. '
                      'If you have recurring expenses, you can set them up to be automatically added at regular intervals. '
                      'The app also allows you to attach receipts or other documents to each expense for easy reference.',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bar_chart, color: Colors.orange),
            title: const Text(
              'FAQ 3: How to view expense reports?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 3: How to view expense reports?',
                  content:
                      'Go to the reports section from the menu. You can view detailed reports of your expenses categorized by date, category, and more. '
                      'The reports section provides various charts and graphs to help you visualize your spending patterns. '
                      'You can filter the reports by different time periods, such as daily, weekly, monthly, or yearly. '
                      'Additionally, you can compare your expenses against your budget to see how well you are managing your finances.',
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text(
              'FAQ 4: How to delete an expense?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FaqDetailPage(
                  title: 'FAQ 4: How to delete an expense?',
                  content:
                      'Swipe left on the expense item you want to delete, and then confirm the deletion. '
                      'If you accidentally delete an expense, you can restore it from the trash within 30 days. '
                      'The app also allows you to permanently delete expenses from the trash if you no longer need them. '
                      'Be careful when deleting expenses, as this action cannot be undone once the item is permanently removed.',
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class FaqDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const FaqDetailPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FaqPage(),
  ));
}
