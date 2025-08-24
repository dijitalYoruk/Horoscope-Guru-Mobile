import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:horoscopeguruapp/models/person.dart';
import 'package:horoscopeguruapp/services/people_service.dart';
import 'package:uuid/uuid.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthDate;
  final _birthPlaceController = TextEditingController();
  TimeOfDay? _selectedBirthTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedBirthTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.accent,
              onPrimary: AppColors.primary,
              surface: AppColors.primary,
              onSurface: AppColors.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthTime) {
      setState(() {
        _selectedBirthTime = picked;
      });
    }
  }

  Future<void> _addPerson() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if person already exists
        final exists = await PeopleService.personExists(
          _selectedBirthDate!,
          _birthPlaceController.text.trim(),
        );

        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'A person with the same birth date and place already exists'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Create new person
        final person = Person(
          id: const Uuid().v4(),
          name: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          birthDate: _selectedBirthDate!,
          birthPlace: _birthPlaceController.text.trim(),
          birthTime: _selectedBirthTime,
          createdAt: DateTime.now(),
        );

        await PeopleService.addPerson(person);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Person added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(
          localizations.addNewPerson,
          style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: AppColors.accent,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.addNewPerson,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the person\'s details to add them to your relationship analysis list',
                        style: TextStyle(
                          color: AppColors.textColor.withOpacity(0.8),
                          fontSize: 16,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Name (Optional)
                _buildInputField(
                  controller: _nameController,
                  label: localizations.nameOptional,
                  icon: Icons.person,
                  validator: (value) => null, // Name is optional
                  isRequired: false,
                ),

                const SizedBox(height: 20),

                // Birth Date
                _buildDateField(
                  label: localizations.birthDate,
                  icon: Icons.calendar_today,
                  selectedDate: _selectedBirthDate,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (_selectedBirthDate == null) {
                      return 'Birth date is required';
                    }
                    return null;
                  },
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                // Birth Place
                _buildInputField(
                  controller: _birthPlaceController,
                  label: localizations.birthPlace,
                  icon: Icons.place,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Birth place is required';
                    }
                    return null;
                  },
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                // Birth Time (Optional)
                _buildTimeField(
                  label: localizations.birthTimeOptional,
                  icon: Icons.access_time,
                  selectedTime: _selectedBirthTime,
                  onTap: () => _selectTime(context),
                ),

                const SizedBox(height: 32),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addPerson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                size: 24,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                localizations.addPerson,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(
          color: AppColors.textColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          labelStyle: TextStyle(
            color: AppColors.textColor.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.accent,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.primary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    String? Function(String?)? validator,
    bool isRequired = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: AppColors.textColor.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        if (isRequired)
                          Text(
                            ' *',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedDate != null
                          ? DateFormat('MMM dd, yyyy').format(selectedDate)
                          : 'Select date',
                      style: TextStyle(
                        color: selectedDate != null
                            ? AppColors.textColor
                            : AppColors.textColor.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: selectedDate != null
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required IconData icon,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.textColor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedTime != null
                          ? selectedTime.format(context)
                          : 'Select time (optional)',
                      style: TextStyle(
                        color: selectedTime != null
                            ? AppColors.textColor
                            : AppColors.textColor.withOpacity(0.5),
                        fontSize: 16,
                        fontWeight: selectedTime != null
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
