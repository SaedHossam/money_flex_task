import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/customer.dart';
import 'package:frontend/providers/customer_provider.dart';
import 'package:frontend/utils/iban_validator.dart' as custom_iban_validator;

class CustomerFormScreen extends StatelessWidget {
  final Customer? customer;
  final _formKey = GlobalKey<FormBuilderState>();

  CustomerFormScreen({this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'name': customer?.name ?? '',
            'email': customer?.email ?? '',
            'phone': customer?.phone ?? '',
            'iban': customer?.iban ?? '',
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(labelText: 'Name'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(labelText: 'Email'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              FormBuilderTextField(
                name: 'phone',
                decoration: InputDecoration(labelText: 'Phone'),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'iban',
                decoration: InputDecoration(labelText: 'Saudi IBAN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IBAN';
                  }
                  if (!custom_iban_validator.IbanValidator.validateSaudiIban(
                    value,
                  )) {
                    return 'Please enter a valid Saudi IBAN';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (customerProvider.errorMessage != null)
                Text(
                  customerProvider.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    customerProvider.isLoading
                        ? null
                        : () async {
                          if (_formKey.currentState!.saveAndValidate()) {
                            final formData = _formKey.currentState!.value;
                            final newCustomer = Customer(
                              name: formData['name'],
                              email: formData['email'],
                              phone: formData['phone'],
                              iban: formData['iban'],
                            );
                            final success =
                                customer == null
                                    ? await customerProvider.createCustomer(
                                      newCustomer,
                                    )
                                    : await customerProvider.updateCustomer(
                                      newCustomer, customer!.id!,
                                    );
                            if (success && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                child:
                    customerProvider.isLoading
                        ? CircularProgressIndicator()
                        : Text(customer == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
