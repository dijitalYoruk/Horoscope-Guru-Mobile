import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:horoscopeguruapp/screens/chat_screen.dart';
import 'package:horoscopeguruapp/models/relationship_data.dart';

class RelationshipAnalysisScreen extends StatefulWidget {
  const RelationshipAnalysisScreen({super.key});

  @override
  _RelationshipAnalysisScreenState createState() =>
      _RelationshipAnalysisScreenState();
}

class _RelationshipAnalysisScreenState
    extends State<RelationshipAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _partnerNameController = TextEditingController();
  DateTime? _selectedBirthDate;
  final _birthPlaceController = TextEditingController();
  TimeOfDay? _selectedBirthTime;

  bool _isLoading = false;

  @override
  void dispose() {
    _partnerNameController.dispose();
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

  void _analyzeRelationship() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Navigate to chat screen with relationship analysis context
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              relationshipData: RelationshipData(
                partnerName: _partnerNameController.text.trim().isEmpty
                    ? null
                    : _partnerNameController.text.trim(),
                partnerBirthDate: _selectedBirthDate,
                partnerBirthPlace: _birthPlaceController.text.trim(),
                partnerBirthTime: _selectedBirthTime,
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text(
          localizations.relationshipAnalysis,
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
                        Icons.favorite,
                        color: AppColors.accent,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.enterPartnerDetails,
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
                        'Enter your partner\'s details (name is optional) to start a relationship analysis chat',
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

                // Partner Name
                _buildInputField(
                  controller: _partnerNameController,
                  label: localizations.partnerName,
                  icon: Icons.person,
                  validator: (value) {
                    // Partner name is optional, no validation needed
                    return null;
                  },
                  isRequired: false,
                ),

                const SizedBox(height: 20),

                // Partner Birth Date
                _buildDateField(
                  label: localizations.partnerBirthDate,
                  icon: Icons.calendar_today,
                  selectedDate: _selectedBirthDate,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (_selectedBirthDate == null) {
                      return localizations.partnerBirthDateRequired;
                    }
                    return null;
                  },
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                // Partner Birth Place
                _buildInputField(
                  controller: _birthPlaceController,
                  label: localizations.partnerBirthPlace,
                  icon: Icons.place,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localizations.partnerBirthPlaceRequired;
                    }
                    return null;
                  },
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                // Partner Birth Time (Optional)
                _buildTimeField(
                  label: localizations.partnerBirthTime,
                  icon: Icons.access_time,
                  selectedTime: _selectedBirthTime,
                  onTap: () => _selectTime(context),
                ),

                const SizedBox(height: 32),

                // Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _analyzeRelationship,
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
                                Icons.psychology,
                                size: 24,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Start Relationship Chat',
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
