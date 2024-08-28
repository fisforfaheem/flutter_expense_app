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
        children: const <Widget>[
          ExpansionTile(
            leading: Icon(Icons.help_outline, color: Colors.blue),
            title: Text(
              'FAQ 1: How to use this app?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: This app helps you track your expenses easily. You can add, view, and delete expenses, as well as generate reports to analyze your spending habits.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.add_circle_outline, color: Colors.green),
            title: Text(
              'FAQ 2: How to add a new expense?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: Click on the add button on the main screen, fill in the details such as amount, category, and date, and then save the expense.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.bar_chart, color: Colors.orange),
            title: Text(
              'FAQ 3: How to view expense reports?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: Go to the reports section from the menu. You can view detailed reports of your expenses categorized by date, category, and more.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text(
              'FAQ 4: How to delete an expense?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: Swipe left on the expense item you want to delete, and then confirm the deletion.',
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            leading: Icon(Icons.support_agent, color: Colors.purple),
            title: Text(
              'FAQ 5: How to contact support?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Answer: You can contact support via the feedback section in the app. Provide your feedback or issues, and our support team will get back to you.',
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
