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

          if (state is InventoryLoaded) {
            try {
              final currentSpace = state.spaces.firstWhere(
                (s) => s.id == space.id,
              );
              currentStorage = currentSpace.storages.firstWhere(
                (st) => st.id == storage.id,
              );
            } catch (e) {
              return Center(
                child: Text('Storage not found', style: GoogleFonts.outfit()),
              );
            }
          }

          if (currentStorage == null) {
            return Center(
              child: Text('Storage not found', style: GoogleFonts.outfit()),
            );
          }

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
    final descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    final quantityController = TextEditingController(
      text: item?.quantity?.toString() ?? '',
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                final quantity = quantityController.text.trim().isEmpty
                    ? null
                    : int.tryParse(quantityController.text.trim());

                if (item == null) {
                  context.read<InventoryBloc>().add(
                    AddItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      quantity: quantity,
                    ),
                  );
                } else {
                  context.read<InventoryBloc>().add(
                    UpdateItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      itemId: item.id,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      quantity: quantity,
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
            if (item.description != null && item.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(item.description!),
            ],
            if (item.quantity != null) ...[
              const SizedBox(height: 4),
              Text(
                'Quantity: ${item.quantity}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
    final descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    final quantityController = TextEditingController(
      text: item?.quantity?.toString() ?? '',
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                final quantity = quantityController.text.trim().isEmpty
                    ? null
                    : int.tryParse(quantityController.text.trim());

                if (item == null) {
                  context.read<InventoryBloc>().add(
                    AddItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      quantity: quantity,
                    ),
                  );
                } else {
                  context.read<InventoryBloc>().add(
                    UpdateItemEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                      itemId: item.id,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim().isEmpty
                          ? null
                          : descriptionController.text.trim(),
                      quantity: quantity,
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
