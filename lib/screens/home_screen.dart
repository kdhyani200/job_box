import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'about_screen.dart';
import 'add_edit_job_screen.dart';
import '../theme/app_theme.dart';
import '../models/job_model.dart';
import '../widgets/job_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobBox = Hive.box<Job>('jobs');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Box',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: const _AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditJobScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<Job>>(
        valueListenable: jobBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const _EmptyState();
          }

          final jobs = box.values.toList()
            ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    children: [
                      _TotalApplicationsCard(count: jobs.length),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "All Applications",
                          style: GoogleFonts.kanit(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...List.generate(jobs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: JobTile(job: jobs[index]),
                        );
                      }),
                    ],
                  ),
                ),

                // No padding at all
                const _HomeFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder<Box<Job>>(
        valueListenable: Hive.box<Job>('jobs').listenable(),
        builder: (context, box, _) {
          final jobs = box.values.toList();

          final total = jobs.length;
          final interviewing = jobs
              .where((e) => e.status == Status.interviewing)
              .length;
          final offered = jobs.where((e) => e.status == Status.offered).length;
          final rejected = jobs
              .where((e) => e.status == Status.rejected)
              .length;

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logos/in_app_icon.png", height: 90),
                    const SizedBox(width: 4),
                    Text(
                      "Job Box",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Keep track of every application",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Text(
                            "Application Summary",
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _SummaryTile(
                            title: "Total Applications",
                            value: total.toString(),
                            icon: Icons.work_outline,
                            color: AppColors.statusApplied,
                          ),

                          const Divider(),

                          _SummaryTile(
                            title: "Interviewing",
                            value: interviewing.toString(),
                            icon: Icons.groups_outlined,
                            color: AppColors.statusInterviewing,
                          ),

                          const Divider(),

                          _SummaryTile(
                            title: "Offered",
                            value: offered.toString(),
                            icon: Icons.check_circle_outline,
                            color: AppColors.statusOffered,
                          ),

                          const Divider(),

                          _SummaryTile(
                            title: "Rejected",
                            value: rejected.toString(),
                            icon: Icons.cancel_outlined,
                            color: AppColors.statusRejected,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(),
                ),

                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("About"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.star_outline),
                  title: const Text("Rate App"),
                  onTap: () {},
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TotalApplicationsCard extends StatelessWidget {
  const _TotalApplicationsCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: .15)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: colorScheme.primary,
          child: Icon(Icons.trending_up_rounded, color: Colors.white, size: 28),
        ),
        title: Text(
          "Total Applications",
          style: GoogleFonts.ibmPlexSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "Keep applying and track your progress",
            style: TextStyle(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
            ),
          ),
        ),
        trailing: Text(
          count.toString(),
          style: GoogleFonts.ibmPlexSans(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _EmptyStateIllustration(),

            const SizedBox(height: 28),

            Text(
              "No jobs added yet",
              style: GoogleFonts.ibmPlexSans(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Start tracking your job hunt — every application, "
              "interview, and offer in one place.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditJobScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Add your first application"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateIllustration extends StatelessWidget {
  const _EmptyStateIllustration();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 160,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Concentric rings give the badge some depth instead of a flat circle.
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: .16),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: .25),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.work_outline_rounded,
              size: 40,
              color: colorScheme.primary,
            ),
          ),

          // Small floating badges hint at the app's core actions: applying
          // and scheduling interviews.
          Positioned(
            top: 10,
            right: 12,
            child: const _FloatingBadge(icon: Icons.send_rounded),
          ),
          Positioned(
            bottom: 14,
            left: 4,
            child: const _FloatingBadge(icon: Icons.event_available_rounded),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.primary.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: .08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 16, color: colorScheme.primary),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: 12),

        Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),

        Text(
          value,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logos/footer.png",
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }
}
