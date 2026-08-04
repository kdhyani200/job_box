import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';
import '../models/job_model.dart';

class AddEditJobScreen extends StatefulWidget {
  final Job? job;

  const AddEditJobScreen({super.key, this.job});

  bool get isEditing => job != null;

  @override
  State<AddEditJobScreen> createState() => _AddEditJobScreenState();
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _locationController = TextEditingController();
  final _portalController = TextEditingController();
  final _jobUrlController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _appliedDate = DateTime.now();

  Status _status = Status.applied;

  final ImagePicker _picker = ImagePicker();

  List<String> images = [];

  late final Box<Job> jobBox;

  @override
  void initState() {
    super.initState();

    jobBox = Hive.box<Job>('jobs');

    if (widget.job != null) {
      final job = widget.job!;

      _companyController.text = job.company;
      _roleController.text = job.role;
      _locationController.text = job.location;
      _portalController.text = job.portal;
      _jobUrlController.text = job.jobUrl ?? "";
      _notesController.text = job.notes ?? "";

      _status = job.status;
      _appliedDate = job.appliedDate;

      images = List.from(job.jobDescriptionImages);
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _portalController.dispose();
    _jobUrlController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      if (index < images.length) {
        images[index] = file.path;
      } else {
        images.add(file.path);
      }
    });
  }

  void _deleteImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _appliedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _appliedDate = picked;
      });
    }
  }

  InputDecoration _buildInputDecoration({
    required IconData prefixIcon,
    String? hintText,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: theme.dividerColor),
      prefixIcon: Icon(prefixIcon, size: 22),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Edit Job" : "Add Job",
          style: GoogleFonts.ibmPlexSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    if (widget.isEditing) {
                      final job = widget.job!;

                      job
                        ..company = _companyController.text.trim()
                        ..role = _roleController.text.trim()
                        ..location = _locationController.text.trim()
                        ..appliedDate = _appliedDate
                        ..portal = _portalController.text.trim()
                        ..status = _status
                        ..jobUrl = _jobUrlController.text.trim().isEmpty
                            ? null
                            : _jobUrlController.text.trim()
                        ..jobDescriptionImages = List.from(images)
                        ..notes = _notesController.text.trim();

                      await job.save();
                    } else {
                      await jobBox.add(
                        Job(
                          company: _companyController.text.trim(),
                          role: _roleController.text.trim(),
                          location: _locationController.text.trim(),
                          appliedDate: _appliedDate,
                          portal: _portalController.text.trim(),
                          status: _status,
                          jobUrl: _jobUrlController.text.trim().isEmpty
                              ? null
                              : _jobUrlController.text.trim(),
                          jobDescriptionImages: List.from(images),
                          notes: _notesController.text.trim(),
                        ),
                      );
                    }

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.isEditing ? "Update Job" : "Save Job"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  "Company Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                TextFormField(
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  controller: _companyController,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.business_outlined,
                    hintText: "e.g., Zoho",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter company name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  "Role",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  maxLength: 24,
                  controller: _roleController,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.badge_outlined,
                    hintText: "e.g., SWE",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter role";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  "Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                TextFormField(
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  controller: _locationController,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.location_on_outlined,
                    hintText: "e.g., Seattle",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  "Applied Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: _buildInputDecoration(
                      prefixIcon: Icons.calendar_month,
                      hintText: "Select date",
                    ),
                    child: Text(
                      "${_appliedDate.day}/${_appliedDate.month}/${_appliedDate.year}",
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Job Portal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                TextFormField(
                  maxLength: 20,
                  textCapitalization: TextCapitalization.words,
                  controller: _portalController,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.web_outlined,
                    hintText: "e.g., Indeed",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  "Status",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                DropdownButtonFormField<Status>(
                  initialValue: _status,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.check_box_outlined,
                    hintText: "Status",
                  ),
                  items: Status.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(
                        status.name[0].toUpperCase() + status.name.substring(1),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _status = value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                Text(
                  "Job URL",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 6),

                TextFormField(
                  keyboardType: TextInputType.url,
                  controller: _jobUrlController,
                  decoration: _buildInputDecoration(
                    prefixIcon: Icons.link_outlined,
                    hintText: "e.g., https://example.com",
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "JD Screenshots",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 12),

                Row(
                  children: List.generate(3, (index) {
                    final hasImage = index < images.length;

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!hasImage) {
                                  _pickImage(index);
                                }
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: hasImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.file(
                                              File(images[index]),
                                              fit: BoxFit.cover,
                                            ),

                                            /// Bottom overlay
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                    ),
                                                color: Colors.black54,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          _pickImage(index),
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          _deleteImage(index),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.error,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                Text(
                  "Notes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  maxLength: 100,
                  decoration: _buildInputDecoration(prefixIcon: Icons.notes)
                      .copyWith(
                        alignLabelWithHint: true,
                        hintText: "Example: HR said they'll respond next week.",
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
