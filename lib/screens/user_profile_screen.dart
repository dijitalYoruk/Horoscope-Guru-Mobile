import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horoscopeguruapp/main.dart'
    as mainApp; // Import for the changeLocale function

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();

  bool _showValidationErrors = false;
  User? _user;
  String _selectedLanguage = 'en'; // Default language

  bool get _isFormValid =>
      _nameController.text.isNotEmpty &&
      _surnameController.text.isNotEmpty &&
      _birthDateController.text.isNotEmpty &&
      _birthPlaceController.text.isNotEmpty;

  String? _getErrorText(String value, String fieldName) {
    final localizations = AppLocalizations.of(context)!;
    if (_showValidationErrors && value.isEmpty) {
      return '[31m$fieldName ${localizations.isRequired}[0m';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (_isFormValid) {
      Api api = new Api();
      UpdateUserRequest request = new UpdateUserRequest(
        name: _nameController.text,
        surname: _surnameController.text,
        birthPlace: _birthPlaceController.text,
        birthDate: _birthDateController.text,
        birthTime: _birthTimeController.text.isEmpty
            ? null
            : _birthTimeController.text,
        preferredLanguage: _selectedLanguage,
      );

      await api.updateUser(request, context);

      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.profileUpdated,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.accent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    // Initialize the dropdown with the user's preferred language
    _selectedLanguage = _user?.preferredLanguage ?? 'en';
  }

  Future<void> _getUser() async {
    final api = Api();
    final response = await api.getUser(context);
    setState(() {
      _user = response;
      _emailController.text = _user?.email ?? '';
      _nameController.text = _user?.name ?? '';
      _surnameController.text = _user?.surname ?? '';
      _birthDateController.text = _user?.birthDate ?? '';
      _birthPlaceController.text = _user?.birthPlace ?? '';
      _birthTimeController.text = _user?.birthTime ?? '';
      _selectedLanguage = _user?.preferredLanguage ?? 'en';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: AppColors.primary,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.primaryDark,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: AppColors.primary,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppColors.primaryDark,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final hour = picked.hourOfPeriod;
        final minute = picked.minute.toString().padLeft(2, '0');
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        _birthTimeController.text = "$hour:$minute $period";
      });
    }
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  InputDecoration _getInputDecoration({
    required String labelText,
    String? hintText,
    bool showError = true,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: (_showValidationErrors && showError && !enabled)
            ? Colors.red.shade300
            : Colors.white70,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white30),
      border: InputBorder.none,
      errorStyle: const TextStyle(color: Colors.red),
      errorText: showError
          ? _getErrorText(
              labelText == 'Name'
                  ? _nameController.text
                  : labelText == 'Surname'
                      ? _surnameController.text
                      : labelText == 'Birth Date'
                          ? _birthDateController.text
                          : labelText == 'Birth Place'
                              ? _birthPlaceController.text
                              : '',
              labelText)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Background star decoration
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Scrollable content
              const SizedBox(height: 36),
              // Header section
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () {
                        Navigator.pop(context);

                    },  icon: Icon(Icons.arrow_back, color: AppColors.accent, size: 22)),
                    Text(
                      localizations.tellTheStarsAboutYourself,
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),]), ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  localizations.birthDateAndPlaceRequired,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Language selection dropdown
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.language,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _selectedLanguage,
                                  dropdownColor: AppColors.primaryDark,
                                  icon: const Icon(Icons.arrow_downward,
                                      color: Colors.orange),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.orange,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedLanguage = newValue!;
                                      // Change app language
                                      mainApp.changeLocale(
                                          context, _selectedLanguage);
                                    });
                                  },
                                  items: <String>['en', 'tr']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value == 'en'
                                            ? localizations.languageEnglish
                                            : localizations.languageTurkish,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.email,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  enabled: false,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: localizations.email,
                                    labelStyle:
                                        const TextStyle(color: Colors.white70),
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.person,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _getInputDecoration(
                                      labelText: localizations.name),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Surname field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _surnameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _getInputDecoration(
                                      labelText: localizations.surname),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Birth details section header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.orange, width: 3),
                            ),
                          ),
                          child: Text(
                            localizations.yourCosmicCoordinates,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Birth date field with date picker
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _birthDateController,
                                  readOnly: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _getInputDecoration(
                                    labelText: localizations.birthDate,
                                    hintText: localizations.selectDate,
                                  ),
                                  onTap: () => _selectDate(context),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.event,
                                    color: Colors.orange),
                                onPressed: () => _selectDate(context),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Birth place field
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.place,
                                  color: Colors.orange, size: 24),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _birthPlaceController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _getInputDecoration(
                                    labelText: localizations.birthPlace,
                                    hintText: localizations.cityCountry,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Birth time field with time picker
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.orange, size: 24),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller: _birthTimeController,
                                      readOnly: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: _getInputDecoration(
                                        labelText:
                                            localizations.birthTimeOptional,
                                        hintText: localizations.selectTime,
                                        showError: false,
                                      ),
                                      onTap: () => _selectTime(context),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.schedule,
                                        color: Colors.orange),
                                    onPressed: () => _selectTime(context),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Text(
                                  localizations.providingTimeHelps,
                                  style: TextStyle(
                                    color: Colors.orange.shade300,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              // Sticky bottom button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                    20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? AppColors.accent
                          : Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      localizations.updateMyCosmicProfile,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
