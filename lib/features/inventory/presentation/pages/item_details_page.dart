import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/item_details_bloc.dart';
import '../bloc/item_details_event.dart';
import '../bloc/item_details_state.dart';
import '../bloc/create_item_bloc.dart';
import 'edit_item_page.dart';

class ItemDetailsPage extends StatefulWidget {
  final String itemId;
  final String? storageId; // Optional: for faster loading
  final String? spaceId;
  final String? spaceName;
  final String? storageName;

  const ItemDetailsPage({
    super.key,
    required this.itemId,
    this.storageId,
    this.spaceId,
    this.spaceName,
    this.storageName,
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ItemDetailsBloc>().add(
          LoadItemDetails(
            itemId: widget.itemId,
            storageId: widget.storageId,
            spaceId: widget.spaceId,
            spaceName: widget.spaceName,
            storageName: widget.storageName,
          ),
        );
  }

  void _showEditDialog(ItemDetailsLoaded state) {
    // Navigate to edit item page with pre-filled data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (editContext) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<CreateItemBloc>()),
          ],
          child: EditItemPage(
            spaceId: state.spaceId,
            spaceName: state.spaceName,
            storageId: state.storageId,
            storageName: state.storageName,
            item: state.item,
            categories: state.categories,
            onItemUpdated: () {
              // Refresh item details after edit
              context.read<ItemDetailsBloc>().add(
                    RefreshItemDetails(
                      itemId: widget.itemId,
                      storageId: widget.storageId,
                      spaceId: widget.spaceId,
                      spaceName: widget.spaceName,
                      storageName: widget.storageName,
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToLocationSelection(ItemDetailsLoaded state) {
    Navigator.of(context).pushNamed(
      AppRoutes.locationSelection,
      arguments: {
        'title': 'Move Item Location',
        'currentLocationPath': state.locationPath,
        'onLocationSelected': (
          String locationId,
          String locationName,
          String locationPath,
          String locationType,
          String? spaceId,
        ) {
          // TODO: Implement move item to new location
          // This would require an API call to update item's storage_id
          NavigationService.showInfo('Move location functionality coming soon');
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemDetailsBloc, ItemDetailsState>(
      listener: (context, state) {
        if (state is ItemDetailsError) {
          NavigationService.showError(state.message);
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
            BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
              builder: (context, state) {
                if (state is ItemDetailsLoaded) {
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(state);
                      } else if (value == 'move') {
                        _navigateToLocationSelection(state);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Edit',
                              style: GoogleFonts.outfit(),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'move',
                        child: Row(
                          children: [
                            const Icon(Icons.drive_file_move, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Move location',
                              style: GoogleFonts.outfit(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
          builder: (context, state) {
            if (state is ItemDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ItemDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading item details',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ItemDetailsBloc>().add(
                              LoadItemDetails(
                                itemId: widget.itemId,
                                storageId: widget.storageId,
                                spaceId: widget.spaceId,
                                spaceName: widget.spaceName,
                                storageName: widget.storageName,
                              ),
                            );
                      },
                      child: Text('Retry', style: GoogleFonts.outfit()),
                    ),
                  ],
                ),
              );
            } else if (state is ItemDetailsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and location section
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
                            child: Text(
                              state.item.name,
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
                              state.locationPath,
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
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.7,
                      child: state.item.imageUrl != null &&
                              state.item.imageUrl!.isNotEmpty
                          ? Image.network(
                              state.item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AssetConstants.itemThumbnail,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              AssetConstants.itemThumbnail,
                              fit: BoxFit.cover,
                            ),
                    ),

                    // Description and details section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          if (state.item.notes != null &&
                              state.item.notes!.isNotEmpty) ...[
                            Text(
                              'Description',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.item.notes!,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Expiry date field
                          if (state.item.expirationDate != null &&
                              state.item.expirationDate!.isNotEmpty) ...[
                            Text(
                              'Expiry date',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.item.expirationDate!,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                          // Quantity field
                          Text(
                            'Quantity',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.item.quantity.toStringAsFixed(state.item.quantity.truncateToDouble() == state.item.quantity ? 0 : 1)} ${state.item.unit}',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Stock status
                          if (state.item.lowStock || state.item.outOfStock) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: state.item.outOfStock
                                    ? Colors.red[100]
                                    : Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    state.item.outOfStock
                                        ? Icons.error_outline
                                        : Icons.warning_amber_rounded,
                                    color: state.item.outOfStock
                                        ? Colors.red
                                        : Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.item.outOfStock
                                        ? 'Out of Stock'
                                        : 'Low Stock',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      color: state.item.outOfStock
                                          ? Colors.red
                                          : Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),

                    // Categories section
                    if (state.categories.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categories',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.categories.map((category) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

