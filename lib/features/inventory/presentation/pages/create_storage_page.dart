import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../bloc/create_storage_bloc.dart';
import '../bloc/create_storage_event.dart';
import '../bloc/create_storage_state.dart';
import '../../../subscription/presentation/widgets/plan_limit_dialog.dart';

class CreateStoragePage extends StatefulWidget {
  final String spaceId;
  final String spaceName;
  final VoidCallback? onStorageCreated;

  const CreateStoragePage({
    super.key,
    required this.spaceId,
    required this.spaceName,
    this.onStorageCreated,
  });

  @override
  State<CreateStoragePage> createState() => _CreateStoragePageState();
}

class _CreateStoragePageState extends State<CreateStoragePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;
  String? _selectedLocationId;
  String? _selectedLocationName;
  String? _selectedLocationType;
  String? _selectedSpaceId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateStorageBloc, CreateStorageState>(
      listener: (context, state) {
        if (state is CreateStorageSuccess) {
          NavigationService.showSuccess('Storage created successfully!');
          // Call the callback to reload dashboard
          widget.onStorageCreated?.call();
          Navigator.of(context).pop();
        } else if (state is CreateStoragePlanLimitReached) {
          NavigationService.showAppDialog(
            dialog: PlanLimitDialog(
              message: state.message,
              resource: state.resource,
              limit: state.limit,
            ),
          );
        } else if (state is CreateStorageError) {
          NavigationService.showError(state.message);
        } else if (state is CreateStorageValidationError) {
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
          actions: [
            TextButton(
              onPressed: () => _navigateToLocationSelection(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select location',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter storage name here..',
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
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(color: AppColors.black),
                        child: Text(
                          _selectedLocationName ?? "No location selected",
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
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
                              AssetConstants.storageDefaultImage,
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
                    child: BlocBuilder<CreateStorageBloc, CreateStorageState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is CreateStorageLoading
                              ? null
                              : () {
                                  _saveStorage();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: state is CreateStorageLoading
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

  void _saveStorage() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    // Determine the target space ID based on location type
    String targetSpaceId;
    String? parentStorageId;

    if (_selectedLocationType == 'space') {
      // Creating a top-level storage in a space
      targetSpaceId = _selectedLocationId ?? widget.spaceId;
      parentStorageId = null;
    } else if (_selectedLocationType == 'storage') {
      // Creating a substorage (child storage) in an existing storage
      targetSpaceId = _selectedSpaceId ?? widget.spaceId;
      parentStorageId = _selectedLocationId;
    } else {
      // Default to the provided space
      targetSpaceId = widget.spaceId;
      parentStorageId = null;
    }

    // Trigger the bloc event to create the storage
    context.read<CreateStorageBloc>().add(
      CreateStorageSubmitted(
        title: name,
        description: description,
        spaceId: targetSpaceId,
        parentStorageId: parentStorageId,
        image: _selectedImage,
      ),
    );
  }

  void _navigateToLocationSelection() {
    Navigator.of(context).pushNamed(
      AppRoutes.locationSelection,
      arguments: {
        'title': 'Select Storage Location',
        'currentLocationPath': '${widget.spaceName} > New Storage',
        'onLocationSelected':
            (
              String locationId,
              String locationName,
              String locationPath,
              String locationType,
              String? spaceId,
            ) {
              setState(() {
                _selectedLocationId = locationId;
                _selectedLocationName = locationName;
                _selectedLocationType = locationType;
                _selectedSpaceId = spaceId;
              });
            },
      },
    );
  }
}
