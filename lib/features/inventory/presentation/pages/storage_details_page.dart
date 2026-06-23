import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../dashboard/presentation/widgets/storage_card.dart';
import '../../../dashboard/presentation/widgets/item_row.dart';
import '../bloc/storage_details_bloc.dart';
import '../bloc/storage_details_event.dart';
import '../bloc/storage_details_state.dart';

class StorageDetailsPage extends StatefulWidget {
  final String storageId;

  const StorageDetailsPage({super.key, required this.storageId});

  @override
  State<StorageDetailsPage> createState() => _StorageDetailsPageState();
}

class _StorageDetailsPageState extends State<StorageDetailsPage> {
  final ScrollController _itemsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StorageDetailsBloc>().add(
      LoadStorageDetails(storageId: widget.storageId),
    );

    // Set up scroll listener for items pagination
    _itemsScrollController.addListener(_onItemsScroll);
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    super.dispose();
  }

  void _onItemsScroll() {
    if (_itemsScrollController.position.pixels >=
        _itemsScrollController.position.maxScrollExtent - 200) {
      final state = context.read<StorageDetailsBloc>().state;
      if (state is StorageDetailsLoaded &&
          state.hasMoreItems &&
          !state.isLoadingItems) {
        context.read<StorageDetailsBloc>().add(
          LoadItems(
            storageId: widget.storageId,
            page: state.currentItemPage + 1,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // TODO: Show storage options menu
            },
          ),
        ],
      ),
      body: BlocListener<StorageDetailsBloc, StorageDetailsState>(
        listener: (context, state) {
          if (state is StorageDetailsError) {
            NavigationService.showError(state.message);
          }
        },
        child: BlocBuilder<StorageDetailsBloc, StorageDetailsState>(
          builder: (context, state) {
            if (state is StorageDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StorageDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading storage details',
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
                        context.read<StorageDetailsBloc>().add(
                          LoadStorageDetails(storageId: widget.storageId),
                        );
                      },
                      child: Text('Retry', style: GoogleFonts.outfit()),
                    ),
                  ],
                ),
              );
            } else if (state is StorageDetailsLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStorageDetailsSection(state),
                    _buildSubStoragesSection(state),
                    _buildItemsSection(state),
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

  Widget _buildStorageDetailsSection(StorageDetailsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Storage image
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: state.storage.name,
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: ' in ',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                    TextSpan(
                      text: state.storage.spaceName,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.storage.description != null &&
                  state.storage.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  state.storage.description!,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.7,
          child: Image.asset(
            AssetConstants.storageDefaultImage,
            fit: BoxFit.cover,
          ),
        ),

        // Storage info
      ],
    );
  }

  Widget _buildSubStoragesSection(StorageDetailsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub storages',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<StorageDetailsBloc>().add(
                        LoadSubStorages(
                          storageId: widget.storageId,
                          loadAll: true,
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to create sub-storage
                    },
                    child: Text(
                      'Add +',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: state.subStorages.isEmpty
              ? Center(
                  child: Text(
                    'No sub-storages yet',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      state.subStorages.length +
                      (state.hasMoreSubStorages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.subStorages.length) {
                      // Load more button
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Center(
                          child: state.isLoadingSubStorages
                              ? const CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () {
                                    context.read<StorageDetailsBloc>().add(
                                      LoadSubStorages(
                                        storageId: widget.storageId,
                                        page: state.currentSubStoragePage + 1,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Load more',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: AppColors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }

                    final subStorage = state.subStorages[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: StorageCard(
                          name: subStorage.name,
                          description: subStorage.description ?? '',
                          totalStorages:
                              0, // Sub-storages don't have sub-storages
                          totalItems: subStorage.items.length,
                          onTap: () {
                            // TODO: Navigate to sub-storage details
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildItemsSection(StorageDetailsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to create item
                },
                child: Text(
                  'Add +',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (state.items.isEmpty)
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'No items yet',
                style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            controller: _itemsScrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length + (state.isLoadingItems ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.items.length) {
                // Loading indicator at the bottom
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.items[index];
              return ItemRow(
                itemName: item.name,
                expiryDate: item.expirationDate ?? 'No expiry date',
                description: item.notes ?? '',
                locationPath:
                    '${state.storage.spaceName} > ${state.storage.name}',
                quantity: item.quantity.toInt(),
                onTap: () {
                  NavigationService.navigateTo(
                    AppRoutes.itemDetails,
                    arguments: {
                      'itemId': item.id,
                      'storageId': widget.storageId,
                      'spaceId': state.storage.spaceId,
                      'spaceName': state.storage.spaceName,
                      'storageName': state.storage.name,
                    },
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
