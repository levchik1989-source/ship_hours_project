import 'package:flutter/material.dart';

import '../../../domain/entities/salary_profile.dart';

final class SalaryProfileFormScreen extends StatefulWidget {
  const SalaryProfileFormScreen({this.profile, super.key});

  final SalaryProfile? profile;

  @override
  State<SalaryProfileFormScreen> createState() =>
      _SalaryProfileFormScreenState();
}

final class _SalaryProfileFormScreenState
    extends State<SalaryProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _basicUk;
  late final TextEditingController _basicNonUk;
  late final TextEditingController _leaveUk;
  late final TextEditingController _leaveNonUk;
  late final TextEditingController _guaranteedOtUk;
  late final TextEditingController _guaranteedOtNonUk;
  late final TextEditingController _extraOtUkRate;
  late final TextEditingController _extraOtNonUkRate;
  late final TextEditingController _standardWorkDay;
  late final TextEditingController _lashingBonus;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _name = TextEditingController(text: p?.name ?? '');
    _basicUk = TextEditingController(text: _text(p?.basicUk));
    _basicNonUk = TextEditingController(text: _text(p?.basicNonUk));
    _leaveUk = TextEditingController(text: _text(p?.leaveUk));
    _leaveNonUk = TextEditingController(text: _text(p?.leaveNonUk));
    _guaranteedOtUk = TextEditingController(text: _text(p?.guaranteedOtUk));
    _guaranteedOtNonUk =
        TextEditingController(text: _text(p?.guaranteedOtNonUk));
    _extraOtUkRate = TextEditingController(text: _text(p?.extraOtUkRate));
    _extraOtNonUkRate = TextEditingController(text: _text(p?.extraOtNonUkRate));
    _standardWorkDay =
        TextEditingController(text: _text(p?.standardWorkDay ?? 8));
    _lashingBonus = TextEditingController(text: _text(p?.lashingBonus));
  }

  @override
  void dispose() {
    _name.dispose();
    _basicUk.dispose();
    _basicNonUk.dispose();
    _leaveUk.dispose();
    _leaveNonUk.dispose();
    _guaranteedOtUk.dispose();
    _guaranteedOtNonUk.dispose();
    _extraOtUkRate.dispose();
    _extraOtNonUkRate.dispose();
    _standardWorkDay.dispose();
    _lashingBonus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.profile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit profile' : 'Add profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _field(_name, 'Profile name', text: true),
            const SizedBox(height: 12),
            _field(_basicUk, 'Basic UK'),
            _field(_basicNonUk, 'Basic non-UK'),
            _field(_leaveUk, 'Leave UK'),
            _field(_leaveNonUk, 'Leave non-UK'),
            _field(_guaranteedOtUk, 'Guaranteed OT UK'),
            _field(_guaranteedOtNonUk, 'Guaranteed OT non-UK'),
            _field(_extraOtUkRate, 'Extra OT UK rate'),
            _field(_extraOtNonUkRate, 'Extra OT non-UK rate'),
            _field(_standardWorkDay, 'Standard work day'),
            _field(_lashingBonus, 'Lashing bonus'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                final now = DateTime.now().microsecondsSinceEpoch.toString();
                Navigator.of(context).pop(
                  SalaryProfile(
                    id: widget.profile?.id ?? now,
                    name: _name.text.trim(),
                    basicUk: _number(_basicUk),
                    basicNonUk: _number(_basicNonUk),
                    leaveUk: _number(_leaveUk),
                    leaveNonUk: _number(_leaveNonUk),
                    guaranteedOtUk: _number(_guaranteedOtUk),
                    guaranteedOtNonUk: _number(_guaranteedOtNonUk),
                    extraOtUkRate: _number(_extraOtUkRate),
                    extraOtNonUkRate: _number(_extraOtNonUkRate),
                    standardWorkDay: _number(_standardWorkDay),
                    lashingBonus: _number(_lashingBonus),
                  ),
                );
              },
              child: Text(editing ? 'Save changes' : 'Save profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool text = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: text
            ? TextInputType.text
            : const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (!text && double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'Invalid number';
          }
          return null;
        },
      ),
    );
  }

  double _number(TextEditingController controller) {
    return double.parse(controller.text.replaceAll(',', '.'));
  }

  String _text(double? value) {
    if (value == null) return '';
    return value.toString();
  }
}
