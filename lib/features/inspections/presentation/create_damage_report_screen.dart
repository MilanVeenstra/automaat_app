import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../rentals/domain/entities/rental.dart';
import '../../rentals/presentation/providers/rentals_provider.dart';
import 'providers/inspections_provider.dart';

class CreateDamageReportScreen extends ConsumerStatefulWidget {
  final Rental? rental;

  const CreateDamageReportScreen({super.key, this.rental});

  @override
  ConsumerState<CreateDamageReportScreen> createState() =>
      _CreateDamageReportScreenState();
}

class _CreateDamageReportScreenState
    extends ConsumerState<CreateDamageReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _descriptionController = TextEditingController();

  Rental? _selectedRental;
  String _result = 'OK';
  XFile? _selectedImage;
  bool _isSubmitting = false;

  final List<String> _resultOptions = ['OK', 'DAMAGED', 'NEEDS_REPAIR'];

  @override
  void initState() {
    super.initState();
    _selectedRental = widget.rental;

    // Load rentals if not provided
    if (_selectedRental == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(rentalsNotifierProvider.notifier).loadRentals();
      });
    }
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRental == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rental')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Convert image to base64 if selected
      String? photoBase64;
      if (_selectedImage != null) {
        final bytes = await File(_selectedImage!.path).readAsBytes();
        photoBase64 = base64Encode(bytes);
      }

      print('Screen: Calling createInspection...');
      final success =
          await ref.read(inspectionsNotifierProvider.notifier).createInspection(
                rentalId: _selectedRental!.id,
                odometer: int.parse(_odometerController.text),
                result: _result,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                photoBase64: photoBase64,
              );

      print('Screen: Got success value: $success');

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Damage report submitted successfully')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit damage report')),
          );
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        print('Error submitting damage report: $e');
        print('Stack trace: $stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentalsState = ref.watch(rentalsNotifierProvider);
    final activeRentals = rentalsState.rentals
        .where((r) => r.state == RentalState.active)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Damage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rental selection
              if (_selectedRental == null && activeRentals.isNotEmpty)
                DropdownButtonFormField<Rental>(
                  decoration: const InputDecoration(
                    labelText: 'Select Rental',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRental,
                  items: activeRentals.map((rental) {
                    return DropdownMenuItem(
                      value: rental,
                      child: Text('${rental.car.brand} ${rental.car.model}'),
                    );
                  }).toList(),
                  onChanged: (rental) {
                    setState(() {
                      _selectedRental = rental;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a rental';
                    }
                    return null;
                  },
                )
              else if (_selectedRental != null)
                Card(
                  child: ListTile(
                    title: Text(
                        '${_selectedRental!.car.brand} ${_selectedRental!.car.model}'),
                    subtitle: Text('Rental #${_selectedRental!.id}'),
                  ),
                ),

              const SizedBox(height: 16),

              // Odometer reading
              TextFormField(
                controller: _odometerController,
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter odometer reading';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Result dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Inspection Result',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
                value: _result,
                items: _resultOptions.map((result) {
                  return DropdownMenuItem(
                    value: result,
                    child: Text(result.replaceAll('_', ' ')),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _result = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Describe any damage or issues...',
                ),
                maxLines: 4,
              ),

              const SizedBox(height: 16),

              // Photo selection
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Photo (Optional)'),
                      subtitle: _selectedImage != null
                          ? const Text('Photo selected')
                          : const Text('No photo selected'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: _showImageSourceDialog,
                      ),
                    ),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(
                              File(_selectedImage!.path),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Damage Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
