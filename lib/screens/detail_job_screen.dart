import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_edit_job_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/image_preview.dart';
import '../widgets/info_card.dart';
import '../models/job_model.dart';

class DetailJobScreen extends StatefulWidget {
  const DetailJobScreen({super.key, required this.job});

  final Job job;

  @override
  State<DetailJobScreen> createState() => _DetailJobScreenState();
}

class _DetailJobScreenState extends State<DetailJobScreen> {
  Color get statusColor {
    switch (widget.job.status) {
      case Status.applied:
        return AppColors.statusApplied;

      case Status.interviewing:
        return AppColors.statusInterviewing;

      case Status.offered:
        return AppColors.statusOffered;

      case Status.rejected:
        return AppColors.statusRejected;
    }
  }

  Future<void> _openJobUrl() async {
    var url = widget.job.jobUrl?.trim();

    if (url == null || url.isEmpty) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the job URL.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appliedDate = DateFormat.yMMMMd().format(widget.job.appliedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Job Details",
          style: GoogleFonts.ibmPlexSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),

          const SizedBox(height: 24),

          _buildPipeline(context),

          const SizedBox(height: 24),

          InfoCard(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: widget.job.location,
          ),

          const SizedBox(height: 12),

          InfoCard(
            icon: Icons.calendar_today_outlined,
            title: "Applied On",
            value: appliedDate,
          ),

          const SizedBox(height: 12),

          InfoCard(
            icon: Icons.public,
            title: "Job Portal",
            value: widget.job.portal,
          ),

          if (widget.job.jobUrl != null && widget.job.jobUrl!.isNotEmpty) ...[
            const SizedBox(height: 12),

            InkWell(
              onTap: _openJobUrl,
              child: InfoCard(
                icon: Icons.link,
                title: "Job URL",
                value: widget.job.jobUrl!,
              ),
            ),
          ],

          if (widget.job.jobDescriptionImages.isNotEmpty) ...[
            const SizedBox(height: 24),

            const Text(
              "JD Screenshots",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.job.jobDescriptionImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final image = widget.job.jobDescriptionImages[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagePreview(image: image),
                        ),
                      );
                    },
                    child: Hero(
                      tag: image,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(image),
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          if (widget.job.notes != null && widget.job.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),

            InfoCard(
              icon: Icons.notes,
              title: 'Note',
              value: widget.job.notes!,
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: FilledButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditJobScreen(job: widget.job),
                    ),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                label: const Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: .15),
                  foregroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Job"),
                        content: const Text(
                          "Are you sure you want to delete this job application?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    await widget.job.delete();

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 25,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Builder(
          builder: (context) {
            final theme = Theme.of(context);
            return Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.business,
                size: 42,
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        Text(
          widget.job.company,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Builder(
          builder: (context) => Text(
            widget.job.role,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPipeline(BuildContext context) {
    int currentStep;

    switch (widget.job.status) {
      case Status.applied:
        currentStep = 0;
        break;
      case Status.interviewing:
        currentStep = 1;
        break;
      case Status.offered:
        currentStep = 2;
        break;
      case Status.rejected:
        currentStep = 1;
        break;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hiring Progress",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                _step(0, currentStep),
                _line(currentStep >= 1),
                _step(1, currentStep),
                _line(currentStep >= 2),
                _step(2, currentStep),
              ],
            ),

            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Applied"),
                Text("Interviewing"),
                Text("Offered"),
              ],
            ),

            if (widget.job.status == Status.rejected) ...[
              const SizedBox(height: 16),

              Center(
                child: Chip(
                  backgroundColor: AppColors.statusRejected.withValues(
                    alpha: .15,
                  ),
                  label: const Text("Rejected"),
                  labelStyle: const TextStyle(
                    color: AppColors.statusRejected,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _step(int index, int currentStep) {
    final completed = index <= currentStep;

    return Builder(
      builder: (context) => Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: completed ? statusColor : Theme.of(context).dividerColor,
          shape: BoxShape.circle,
        ),
        child: completed
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  Widget _line(bool completed) {
    return Expanded(
      child: Builder(
        builder: (context) => Container(
          height: 3,
          color: completed ? statusColor : Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}
