import 'package:flutter/material.dart';

import '../../application/controllers/app_controllers.dart';
import '../../domain/entities/car.dart';
import '../components/eink_scaffold.dart';
import '../components/primary_button.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key, required this.controllers});

  final AppControllerRegistry controllers;

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _save() {
    if (!widget.controllers.authController.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سجل الدخول لإضافة سيارة')));
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      final car = Car(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        make: _makeController.text,
        model: _modelController.text,
        trim: '',
        year: int.tryParse(_yearController.text) ?? 2024,
        price: 0,
        currency: 'USD',
        condition: 'new',
        mileageKm: 0,
        transmission: 'auto',
        fuel: 'gasoline',
        bodyType: 'sedan',
        drive: 'fwd',
        color: 'white',
        images: const <String>[],
        images360: const <String>[],
        location: 'local',
        postedAt: DateTime.now(),
        sellerType: 'individual',
        engineCc: 2000,
        hp: 150,
        doors: 4,
        seats: 5,
        notes: '',
      );
      widget.controllers.myCarController.addCar(car);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EInkScaffold(
      appBar: AppBar(title: const Text('إضافة مركبة')),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(controller: _makeController, decoration: const InputDecoration(labelText: 'الشركة'), validator: (value) => value!.isNotEmpty ? null : 'مطلوب'),
            TextFormField(controller: _modelController, decoration: const InputDecoration(labelText: 'الموديل'), validator: (value) => value!.isNotEmpty ? null : 'مطلوب'),
            TextFormField(controller: _yearController, decoration: const InputDecoration(labelText: 'السنة'), keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            PrimaryButton(label: 'حفظ', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
