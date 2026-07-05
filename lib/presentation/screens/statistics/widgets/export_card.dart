import 'package:flutter/material.dart';

import '../../../../application/export/report_export_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/month_statistics.dart';
import '../../../../l10n/app_localizations.dart';

final class ExportCard extends StatefulWidget {
  const ExportCard({required this.statistics, required this.settings, required this.month, super.key});

  final MonthStatistics statistics;
  final AppSettings settings;
  final DateTime month;

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
                Text(l.export, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _isExporting ? null : () => _exportPdf(context),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Report'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isExporting ? null : () => _exportCsv(context),
              icon: const Icon(Icons.table_chart_outlined),
              label: const Text('CSV Report'),
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

  Future<void> _exportPdf(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportPdf(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    await _runExport(
      context,
      () => ReportExportService.exportCsv(
        statistics: widget.statistics,
        settings: widget.settings,
        month: widget.month,
      ),
    );
  }

  Future<void> _runExport(BuildContext context, Future<void> Function() action) async {
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
