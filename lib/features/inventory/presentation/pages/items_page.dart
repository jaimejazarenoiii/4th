import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/entities/storage_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class ItemsPage extends StatelessWidget {
  final SpaceEntity space;
  final StorageEntity storage;

  const ItemsPage({super.key, required this.space, required this.storage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          storage.name,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 2,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          StorageEntity? currentStorage;

          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InventoryLoaded) {
            try {
              final currentSpace = state.spaces.firstWhere(
                (s) => s.id == space.id,
              );
              currentStorage = currentSpace.storages.firstWhere(
                (st) => st.id == storage.id,
              );
            } catch (e) {
              // If storage not found in bloc state, use the passed-in storage as fallback
              currentStorage = storage;
            }
          } else if (state is InventoryInitial || state is InventoryError) {
            // If state is initial or error, use the passed-in storage
            currentStorage = storage;
          }

          // Final fallback - use passed-in storage if still null
          currentStorage ??= storage;

          if (currentStorage.items.isEmpty) {
            return Center(
              child: AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                offsetY: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items yet',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first item',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: currentStorage.items.length,
            itemBuilder: (context, index) {
              final item = currentStorage!.items[index];
              return AnimatedFadeSlide(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 50 * index),
                offsetY: 20,
                child: _ItemCard(
                  space: space,
                  storage: currentStorage,
                  item: item,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditItemDialog(BuildContext context, {ItemEntity? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final notesController = TextEditingController(text: item?.notes ?? '');
    final quantityController = TextEditingController(
      text: item?.quantity.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          item == null ? 'Add Item' : 'Edit Item',
          style: GoogleFonts.outfit(),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.outfit()),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final quantityText = quantityController.text.trim();
                final quantity = quantityText.isEmpty
                    ? 0.0
                    : double.tryParse(quantityText) ?? 0.0;

                if (item == null) {
                  context.read<InventoryBloc>().add(
                    AddItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      name: nameController.text.trim(),
                      description: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      quantity: quantity.toInt(),
                    ),
                  );
                } else {
                  context.read<InventoryBloc>().add(
                    UpdateItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      itemId: item.id,
                      name: nameController.text.trim(),
                      description: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      quantity: quantity.toInt(),
                    ),
                  );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              item == null ? 'Add' : 'Save',
              style: GoogleFonts.outfit(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final SpaceEntity space;
  final StorageEntity storage;
  final ItemEntity item;

  const _ItemCard({
    required this.space,
    required this.storage,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.inventory_2, color: Colors.green[700]),
        ),
        title: Text(
          item.name,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.notes!),
            ],
            const SizedBox(height: 4),
            Text(
              'Quantity: ${item.quantity} ${item.unit}',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 20),
                  const SizedBox(width: 8),
                  Text('Edit', style: GoogleFonts.outfit()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 20, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Delete', style: GoogleFonts.outfit(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showAddEditItemDialog(context, item: item);
            } else if (value == 'delete') {
              _confirmDelete(context);
            }
          },
        ),
      ),
    );
  }

  void _showAddEditItemDialog(BuildContext context, {ItemEntity? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final notesController = TextEditingController(text: item?.notes ?? '');
    final quantityController = TextEditingController(
      text: item?.quantity.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          item == null ? 'Add Item' : 'Edit Item',
          style: GoogleFonts.outfit(),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.outfit()),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final quantityText = quantityController.text.trim();
                final quantity = quantityText.isEmpty
                    ? 0.0
                    : double.tryParse(quantityText) ?? 0.0;

                if (item == null) {
                  context.read<InventoryBloc>().add(
                    AddItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      name: nameController.text.trim(),
                      description: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      quantity: quantity.toInt(),
                    ),
                  );
                } else {
                  context.read<InventoryBloc>().add(
                    UpdateItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      itemId: item.id,
                      name: nameController.text.trim(),
                      description: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                      quantity: quantity.toInt(),
                    ),
                  );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              item == null ? 'Add' : 'Save',
              style: GoogleFonts.outfit(),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Item', style: GoogleFonts.outfit()),
        content: Text(
          'Are you sure you want to delete "${item.name}"?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: GoogleFonts.outfit()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<InventoryBloc>().add(
                DeleteItemEvent(
                  spaceId: space.id,
                  storageId: storage.id,
                  itemId: item.id,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: Text('Delete', style: GoogleFonts.outfit()),
          ),
        ],
      ),
    );
  }
}
