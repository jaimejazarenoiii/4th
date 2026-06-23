import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../bloc/create_item_bloc.dart';
import '../bloc/create_item_event.dart';
import '../bloc/create_item_state.dart';
import '../../domain/entities/category_entity.dart';
import '../../../subscription/presentation/widgets/plan_limit_dialog.dart';

class CreateItemPage extends StatefulWidget {
  final String spaceId;
  final String spaceName;
  final String storageId;
  final String storageName;
  final VoidCallback? onItemCreated;
  final String? itemId; // Optional: if provided, this is edit mode

  const CreateItemPage({
    super.key,
    required this.spaceId,
    required this.spaceName,
    required this.storageId,
    required this.storageName,
    this.onItemCreated,
    this.itemId,
  });

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  File? _selectedImage;
  String? _selectedLocationId;
  String? _selectedLocationPath;
  String? _selectedLocationType;
  String? _selectedSpaceId;
  final List<String> _selectedCategories = [];
  List<CategoryEntity> _availableCategories = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _expiryDateController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Fetch categories when page loads
    context.read<CreateItemBloc>().add(const FetchCategories());
    
    // If itemId is provided, load item data for editing
    if (widget.itemId != null) {
      _loadItemForEdit();
    }
  }

  void _loadItemForEdit() {
    // Load item details using ItemDetailsBloc
    // We'll need to get the item from storage details
    // For now, we'll use a simpler approach - load from storage details
    // This will be handled by the parent (item details page) passing the data
    // But we can also load it here if needed
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateItemBloc, CreateItemState>(
      listener: (context, state) {
        if (state is CreateItemSuccess) {
          NavigationService.showSuccess(
            widget.itemId != null
                ? 'Item updated successfully!'
                : 'Item created successfully!',
          );
          widget.onItemCreated?.call();
          Navigator.of(context).pop();
        } else if (state is CreateItemPlanLimitReached) {
          NavigationService.showAppDialog(
            dialog: PlanLimitDialog(
              message: state.message,
              resource: state.resource,
              limit: state.limit,
            ),
          );
        } else if (state is CreateItemError) {
          NavigationService.showError(state.message);
        } else if (state is CreateItemValidationError) {
          String errorMessage = '';
          if (state.titleError != null) {
            errorMessage += state.titleError!;
          }
          if (state.descriptionError != null) {
            if (errorMessage.isNotEmpty) errorMessage += '\n';
            errorMessage += state.descriptionError!;
          }
          NavigationService.showError(errorMessage);
        } else if (state is CreateItemCategoriesLoaded) {
          setState(() {
            _availableCategories = state.categories;
          });
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
                            hintText: 'Enter name here...',
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
                          _selectedLocationPath ??
                              (widget.storageName.isNotEmpty
                                  ? '${widget.spaceName} > ${widget.storageName}'
                                  : 'Tap to select location'),
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

                // Image section
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : Image.asset(
                              AssetConstants.itemThumbnail,
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
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
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

                // Description and details section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Description here...',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 24),
                      // Expiry date field
                      TextField(
                        controller: _expiryDateController,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Expiry date',
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        readOnly: true,
                        onTap: () => _selectExpiryDate(),
                      ),
                      const SizedBox(height: 16),
                      // Quantity field
                      TextField(
                        controller: _quantityController,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Quantity',
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
                      const SizedBox(height: 16),
                      // Unit field
                      TextField(
                        controller: _unitController,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Unit name',
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
                    ],
                  ),
                ),

                // Categories section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showCategorySelectionDialog(),
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Add',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedCategories.isEmpty)
                        Text(
                          'No categories selected',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedCategories.map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategories.remove(category);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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
                    child: BlocBuilder<CreateItemBloc, CreateItemState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is CreateItemLoading
                              ? null
                              : () {
                                  _saveItem();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: state is CreateItemLoading
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

  void _saveItem() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final expiryDate = _expiryDateController.text.trim().isEmpty
        ? null
        : _expiryDateController.text.trim();
    final quantity = _quantityController.text.trim().isEmpty
        ? null
        : double.tryParse(_quantityController.text.trim());
    final unit = _unitController.text.trim().isEmpty
        ? null
        : _unitController.text.trim();

    // Determine the target space and storage IDs based on location type
    String targetSpaceId = widget.spaceId;
    String targetStorageId = widget.storageId;

    if (_selectedLocationType == 'storage') {
      targetStorageId = _selectedLocationId ?? widget.storageId;
      targetSpaceId = _selectedSpaceId ?? widget.spaceId;
    }

    // Validate that storage is selected
    if (targetStorageId.isEmpty) {
      NavigationService.showError(
        'Please select a storage location before saving',
      );
      return;
    }

    // Trigger the bloc event to create or update the item
    context.read<CreateItemBloc>().add(
          CreateItemSubmitted(
            title: name,
            description: description.isEmpty ? null : description,
            spaceId: targetSpaceId,
            storageId: targetStorageId,
            expiryDate: expiryDate,
            quantity: quantity,
            unit: unit,
            image: _selectedImage,
            categories: _selectedCategories,
            itemId: widget.itemId, // Pass itemId if in edit mode
          ),
        );
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showCategorySelectionDialog() {
    final TextEditingController newCategoryController =
        TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Select or Create Category',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Existing categories dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select existing category',
                    labelStyle: GoogleFonts.outfit(),
                    border: const OutlineInputBorder(),
                  ),
                  items: _availableCategories
                      .where((cat) =>
                          !_selectedCategories.contains(cat.name))
                      .map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Text(category.name, style: GoogleFonts.outfit()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Divider with "OR" text
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 16),
                // Create new category input
                TextField(
                  controller: newCategoryController,
                  decoration: InputDecoration(
                    labelText: 'Create new category',
                    labelStyle: GoogleFonts.outfit(),
                    border: const OutlineInputBorder(),
                  ),
                  style: GoogleFonts.outfit(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = null; // Clear dropdown selection
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(),
              ),
            ),
            FilledButton(
              onPressed: () {
                String? categoryToAdd;
                if (newCategoryController.text.trim().isNotEmpty) {
                  // Create new category - will be created via API when item is saved
                  final newCategory = newCategoryController.text.trim();
                  categoryToAdd = newCategory;
                } else if (selectedCategory != null) {
                  // Use selected category
                  categoryToAdd = selectedCategory;
                }

                if (categoryToAdd != null &&
                    !_selectedCategories.contains(categoryToAdd)) {
                  setState(() {
                    _selectedCategories.add(categoryToAdd!);
                  });
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.outfit(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLocationSelection() {
    Navigator.of(context).pushNamed(
      AppRoutes.locationSelection,
      arguments: {
        'title': 'Select Item Location',
        'currentLocationPath':
            '${widget.spaceName} > ${widget.storageName} > New Item',
        'onLocationSelected': (
          String locationId,
          String locationName,
          String locationPath,
          String locationType,
          String? spaceId,
        ) {
          setState(() {
            _selectedLocationId = locationId;
            _selectedLocationPath = locationPath;
            _selectedLocationType = locationType;
            _selectedSpaceId = spaceId;
          });
        },
      },
    );
  }
}

