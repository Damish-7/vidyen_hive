import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../utils/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common_widgets.dart';

class SubmissionFormSheet extends StatefulWidget {
  final String type;
  final String title;
  final List<String>? categories;
  final Future<void> Function({
    required String title,
    required String description,
    String? coAuthors,
    String? keywords,
    String? category,
    String? filePath,
  }) onSubmit;

  const SubmissionFormSheet({
    super.key,
    required this.type,
    required this.title,
    this.categories,
    required this.onSubmit,
  });

  @override
  State<SubmissionFormSheet> createState() => _SubmissionFormSheetState();
}

class _SubmissionFormSheetState extends State<SubmissionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _coAuthorsCtrl = TextEditingController();
  final _keywordsCtrl = TextEditingController();
  String? _selectedCategory;
  String? _filePath;
  String? _fileName;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.onSubmit(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        coAuthors: _coAuthorsCtrl.text.trim().isEmpty ? null : _coAuthorsCtrl.text.trim(),
        keywords: _keywordsCtrl.text.trim().isEmpty ? null : _keywordsCtrl.text.trim(),
        category: _selectedCategory,
        filePath: _filePath,
      );
      Get.back();
      Get.snackbar(
        'Submitted!', '${widget.title} submitted successfully',
        backgroundColor: AppColors.success.withOpacity(0.9),
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle_outline, color: AppColors.white),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: Responsive.isMobile ? 0.92 : 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            SizedBox(height: Responsive.sp(12)),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.white20, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: Responsive.sp(16)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Responsive.sp(24)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Submit ${widget.title}',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.white,
                        fontSize: Responsive.font(20),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.white50, size: Responsive.icon(22)),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: EdgeInsets.all(Responsive.sp(24)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // On tablet+, show title & desc side by side
                          if (Responsive.isTablet || Responsive.isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _titleField()),
                                SizedBox(width: Responsive.sp(14)),
                                Expanded(child: _categoryDropdown()),
                              ],
                            )
                          else ...[
                            _titleField(),
                            if (widget.categories != null) ...[
                              SizedBox(height: Responsive.sp(14)),
                              _categoryDropdown(),
                            ],
                          ],
                          SizedBox(height: Responsive.sp(14)),
                          _descField(),
                          SizedBox(height: Responsive.sp(14)),
                          if (Responsive.isTablet || Responsive.isDesktop)
                            Row(
                              children: [
                                Expanded(child: _coAuthorsField()),
                                if (widget.type != 'workshop') ...[
                                  SizedBox(width: Responsive.sp(14)),
                                  Expanded(child: _keywordsField()),
                                ],
                              ],
                            )
                          else ...[
                            _coAuthorsField(),
                            if (widget.type != 'workshop') ...[
                              SizedBox(height: Responsive.sp(14)),
                              _keywordsField(),
                            ],
                          ],
                          SizedBox(height: Responsive.sp(18)),
                          _filePicker(),
                          SizedBox(height: Responsive.sp(24)),
                          GradientButton(
                            label: 'Submit ${widget.title}',
                            icon: Icons.send_rounded,
                            onTap: _submit,
                            isLoading: _isLoading,
                          ),
                          SizedBox(height: Responsive.sp(16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleField() => TextFormField(
        controller: _titleCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Title *',
          prefixIcon: Icon(Icons.title_rounded, color: AppColors.white50, size: 20),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
      );

  Widget _descField() => TextFormField(
        controller: _descCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        maxLines: Responsive.isMobile ? 4 : 5,
        decoration: const InputDecoration(
          labelText: 'Description / Abstract *',
          prefixIcon: Icon(Icons.description_outlined, color: AppColors.white50, size: 20),
          alignLabelWithHint: true,
        ),
        validator: (v) => v == null || v.isEmpty ? 'Description is required' : null,
      );

  Widget _coAuthorsField() => TextFormField(
        controller: _coAuthorsCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        decoration: const InputDecoration(
          labelText: 'Co-Authors (optional)',
          prefixIcon: Icon(Icons.group_outlined, color: AppColors.white50, size: 20),
          hintText: 'Separate with commas',
        ),
      );

  Widget _keywordsField() => TextFormField(
        controller: _keywordsCtrl,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
        decoration: const InputDecoration(
          labelText: 'Keywords (optional)',
          prefixIcon: Icon(Icons.tag_rounded, color: AppColors.white50, size: 20),
          hintText: 'Separate with commas',
        ),
      );

  Widget _categoryDropdown() {
    if (widget.categories == null) return const SizedBox();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.sp(14), vertical: Responsive.sp(4)),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(Responsive.radius(12)),
        border: Border.all(color: AppColors.white20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: AppColors.cardBg,
          style: GoogleFonts.inter(color: AppColors.white, fontSize: Responsive.font(14)),
          icon: const Icon(Icons.expand_more_rounded, color: AppColors.white50),
          hint: Text('Select Category', style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(14))),
          items: widget.categories!.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedCategory = v),
        ),
      ),
    );
  }

  Widget _filePicker() => GestureDetector(
        onTap: _pickFile,
        child: Container(
          padding: EdgeInsets.all(Responsive.sp(16)),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(Responsive.radius(12)),
            border: Border.all(
              color: _filePath != null ? AppColors.success.withOpacity(0.4) : AppColors.white20,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _filePath != null ? Icons.check_circle_outline : Icons.upload_file_outlined,
                color: _filePath != null ? AppColors.success : AppColors.white50,
                size: Responsive.icon(22),
              ),
              SizedBox(width: Responsive.sp(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _filePath != null ? 'File Selected' : 'Attach File (optional)',
                      style: GoogleFonts.inter(
                        color: _filePath != null ? AppColors.success : AppColors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: Responsive.font(14),
                      ),
                    ),
                    Text(
                      _fileName ?? 'PDF, DOC, DOCX, PPT, PPTX',
                      style: GoogleFonts.inter(color: AppColors.white50, fontSize: Responsive.font(12)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: AppColors.white50, size: Responsive.icon(14)),
            ],
          ),
        ),
      );
}