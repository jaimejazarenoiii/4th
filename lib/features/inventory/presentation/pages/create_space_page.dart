import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../bloc/create_space_bloc.dart';
import '../bloc/create_space_event.dart';
import '../bloc/create_space_state.dart';
import '../../../subscription/presentation/widgets/plan_limit_dialog.dart';

class CreateSpacePage extends StatefulWidget {
  final VoidCallback? onSpaceCreated;

  const CreateSpacePage({super.key, this.onSpaceCreated});

  @override
  State<CreateSpacePage> createState() => _CreateSpacePageState();
}

class _CreateSpacePageState extends State<CreateSpacePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateSpaceBloc, CreateSpaceState>(
      listener: (context, state) {
        if (state is CreateSpaceSuccess) {
          NavigationService.showSuccess('Space created successfully!');
          // Call the callback to reload dashboard
          widget.onSpaceCreated?.call();
          Navigator.of(context).pop();
        } else if (state is CreateSpacePlanLimitReached) {
          NavigationService.showAppDialog(
            dialog: PlanLimitDialog(
              message: state.message,
              resource: state.resource,
              limit: state.limit,
            ),
          );
        } else if (state is CreateSpaceError) {
          NavigationService.showError(state.message);
        } else if (state is CreateSpaceValidationError) {
          String errorMessage = '';
          if (state.titleError != null) {
            errorMessage += state.titleError!;
          }
          if (state.descriptionError != null) {
            if (errorMessage.isNotEmpty) errorMessage += '\n';
            errorMessage += state.descriptionError!;
          }
          NavigationService.showError(errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Create Space',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name input section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: TextField(
                    controller: _nameController,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter name here..',
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // Image section with "Change image" button overlaying the image using Stack
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : Image.asset(
                              AssetConstants.spaceDefaultImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.black),
                        child: InkWell(
                          onTap: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(
                              context,
                            );
                            try {
                              final picked = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (picked != null) {
                                setState(() {
                                  _selectedImage = File(picked.path);
                                });
                              }
                            } catch (e) {
                              // Handle the error gracefully
                              if (mounted) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to pick image: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Change image',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Description input section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          expands: false,
                          textAlignVertical: TextAlignVertical.top,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Description here...',
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 24,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Save button section
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                    right: 16,
                    left: 16,
                    top: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: BlocBuilder<CreateSpaceBloc, CreateSpaceState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is CreateSpaceLoading
                              ? null
                              : () {
                                  _saveSpace();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: state is CreateSpaceLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Save',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSpace() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Trigger the bloc event to create the space
    context.read<CreateSpaceBloc>().add(
      CreateSpaceSubmitted(
        title: name,
        description: description,
        image: _selectedImage,
      ),
    );
  }
}
