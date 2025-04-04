import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/customer.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/views/customer/customer_form_screen.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;

  const CustomerDetailScreen({required this.customerId, Key? key})
    : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Customer? _customer;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
        Future.microtask(
      () =>
          _loadCustomer()
    );
  }

  Future<void> _loadCustomer() async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final customer = await customerProvider.getCustomerById(
        widget.customerId,
      );
      setState(() {
        _customer = customer;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load customer details';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCustomer() async {
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Customer'),
            content: Text('Are you sure you want to delete this customer?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await customerProvider.deleteCustomer(widget.customerId);
        Navigator.pop(context); // Go back to customer list
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to delete customer';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [
          if (_customer != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CustomerFormScreen(customer: _customer),
                  ),
                ).then((_) => _loadCustomer());
              },
            ),
          if (_customer != null)
            IconButton(icon: Icon(Icons.delete), onPressed: _deleteCustomer),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _customer == null
              ? Center(child: Text('Customer not found'))
              : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem('Name', _customer!.name),
                    _buildDetailItem('Email', _customer!.email),
                    _buildDetailItem('Phone', _customer!.phone),
                    _buildDetailItem('IBAN', _customer!.iban),
                    if (_customer!.createdAt != null)
                      _buildDetailItem(
                        'Created At',
                        DateFormat(
                          'yyyy-MM-dd – HH:mm',
                        ).format(_customer!.createdAt!),
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Divider(),
        ],
      ),
    );
  }
}
