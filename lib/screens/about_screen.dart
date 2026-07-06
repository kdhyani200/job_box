import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String url) async {
      final uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Could not launch $url");
      }
    }

    Future<void> _sendEmail() async {
      final email = Uri(
        scheme: 'mailto',
        path: 'kdhyani1200@gmail.com',
        queryParameters: {'subject': 'Regarding Job Box'},
      );

      await launchUrl(email, mode: LaunchMode.externalApplication);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
          style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Header
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work, size: 30, color: AppColors.azure),
                  SizedBox(width: 4),
                  Text(
                    "Job Box",
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Track every job application with confidence.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          _SectionCard(
            title: "About",
            child: Text(
              "Job Box is a lightweight offline application that helps you organize your job applications, monitor hiring progress, and keep job details together in one place.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: "Features",
            child: const Column(
              children: [
                _FeatureTile("Track unlimited job applications"),
                _FeatureTile("Hiring progress timeline"),
                _FeatureTile("Save job URLs"),
                _FeatureTile("Store JD screenshots"),
                _FeatureTile("Works completely offline"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: "Built With",
            child: const Column(
              children: [
                _TechTile("Flutter"),
                _TechTile("Dart"),
                _TechTile("Hive Database"),
                _TechTile("Material 3"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: "Privacy",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your data stays on your device.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                const _FeatureTile("No account required"),
                const _FeatureTile("No cloud storage"),
                const _FeatureTile("No tracking"),
                const _FeatureTile("No ads"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: "Developer",
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                "Karan Dhyani",
                style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Flutter Developer"),
            ),
          ),

          const SizedBox(height: 16),

          _SectionCard(
            title: "Contact",
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset(
                    "assets/logos/github-sign.png",
                    height: 20,
                  ),
                  title: const Text("GitHub"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _launchUrl("https://github.com/karan-dhyani"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset("assets/logos/linkedin.png", height: 20),
                  title: const Text("LinkedIn"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _launchUrl("https://linkedin.com/in/karan-dhyani"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.asset("assets/logos/email.png", height: 20),
                  title: const Text("Email"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _sendEmail,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "Made with ❤️ using Flutter",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              "© 2026 Job Box",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TechTile extends StatelessWidget {
  const _TechTile(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.circle, size: 10),
      title: Text(text),
      dense: true,
    );
  }
}
