import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/salary_profile_controller.dart';
import 'salary_profile_form_screen.dart';

final class SalaryProfilesScreen extends StatelessWidget {
  const SalaryProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SalaryProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary profiles'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final profile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SalaryProfileFormScreen(),
            ),
          );

          if (profile != null) {
            await controller.addProfile(profile);
          }
        },
      ),
      body: controller.profiles.isEmpty
          ? const Center(
              child: Text('No profiles yet'),
            )
          : ListView.builder(
              itemCount: controller.profiles.length,
              itemBuilder: (context, index) {
                final profile = controller.profiles[index];
                final active = controller.activeProfile?.id == profile.id;

                return ListTile(
                  leading: Icon(
                    active
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(profile.name),
                  subtitle: Text(
                    'UK ${profile.basicUk.toStringAsFixed(2)} / non-UK ${profile.basicNonUk.toStringAsFixed(2)}',
                  ),
                  onTap: () => controller.setActiveProfile(profile.id),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SalaryProfileFormScreen(profile: profile),
                            ),
                          );

                          if (updated != null) {
                            await controller.updateProfile(updated);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete profile?'),
                              content: Text(profile.name),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await controller.deleteProfile(profile.id);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
