import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/views/customer/customer_detail_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch customers when the widget is first loaded
    Future.microtask(
      () =>
          Provider.of<CustomerProvider>(
            context,
            listen: false,
          ).fetchCustomers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => customerProvider.fetchCustomers(),
          ),
        ],
      ),
      body:
          customerProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : customerProvider.errorMessage != null
              ? Center(child: Text(customerProvider.errorMessage!))
              : ListView.builder(
                itemCount: customerProvider.customers.length,
                itemBuilder: (context, index) {
                  final customer = customerProvider.customers[index];
                  return ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.iban),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CustomerDetailScreen(
                                customerId: customer.id!,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/customers/create');
        },
      ),
    );
  }
}
