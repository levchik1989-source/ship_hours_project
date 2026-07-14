import 'package:flutter/material.dart';

import '../../../../application/export/report_export_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/month_statistics.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../domain/entities/salary_calculation.dart';

final class ExportCard extends StatefulWidget {
  const ExportCard(
      {required this.statistics,
      required this.settings,
      required this.month,
      required this.salaryCalculation,
      super.key});

  final MonthStatistics statistics;
  final AppSettings settings;
  final DateTime month;
  final SalaryCalculation? salaryCalculation;

  @override
  State<ExportCard> createState() => _ExportCardState();
}

final class _ExportCardState extends State<ExportCard> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.file_download_outlined),
                const SizedBox(width: 10),
                Text(l.export,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isExporting ? null : () => _savePdf(context),
              icon: const Icon(Icons.save_alt_rounded),
              label: const Text('Save PDF'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isExporting ? null : () => _sharePdf(context),
              icon: const Icon(Icons.share_rounded),
              label: const Text('Share PDF'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: _isExporting ? null : () => _saveCsv(context),
              icon: const Icon(Icons.save_alt_rounded),
              label: const Text('Save CSV'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isExporting ? null : () => _shareCsv(context),
              icon: const Icon(Icons.share_rounded),
              label: const Text('Share CSV'),
            ),
            if (_isExporting) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _savePdf(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportPdf(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
        salaryCalculation: widget.salaryCalculation,
        share: false,
      ),
    );
  }

  Future<void> _sharePdf(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportPdf(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
        salaryCalculation: widget.salaryCalculation,
        share: true,
      ),
    );
  }

  Future<void> _saveCsv(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportCsv(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
        salaryCalculation: widget.salaryCalculation,
        share: false,
      ),
    );
  }

  Future<void> _shareCsv(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportCsv(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
        salaryCalculation: widget.salaryCalculation,
        share: true,
      ),
    );
  }

  Future<void> _runExport(
      BuildContext context, Future<void> Function() action) async {
    setState(() => _isExporting = true);
    try {
      await action();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}
