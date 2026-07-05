import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

final class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset('assets/images/Logo.png', width: 104, height: 104, fit: BoxFit.cover),
                ),
                const SizedBox(height: 18),
                Text(l.appName, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('Version 3.0', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(l.createdBy, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text('LEVCHIK', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Ship Hours helps seafarers track work hours, overtime, holidays, salary and reports in a simple way.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('© 2026 LEVCHIK')),
        ],
      ),
    );
  }
}
