import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/entities/storage_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class StoragesPage extends StatelessWidget {
  final SpaceEntity space;

  const StoragesPage({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(space.name),
        elevation: 2,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          SpaceEntity? currentSpace;

          if (state is InventoryLoaded) {
            try {
              currentSpace = state.spaces.firstWhere((s) => s.id == space.id);
            } catch (e) {
              return const Center(child: Text('Space not found'));
            }
          }

          if (currentSpace == null) {
            return const Center(child: Text('Space not found'));
          }

          if (currentSpace.storages.isEmpty) {
            return Center(
              child: AnimatedFadeSlide(
                duration: const Duration(milliseconds: 600),
                offsetY: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storage_outlined,
                      size: 80,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No storages yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to create your first storage',
                      style: TextStyle(
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
            itemCount: currentSpace.storages.length,
            itemBuilder: (context, index) {
              final storage = currentSpace!.storages[index];
              return AnimatedFadeSlide(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 50 * index),
                offsetY: 20,
                child: _StorageCard(
                  space: currentSpace,
                  storage: storage,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditStorageDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditStorageDialog(BuildContext context, {StorageEntity? storage}) {
    final nameController = TextEditingController(text: storage?.name ?? '');
    final descriptionController = TextEditingController(text: storage?.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(storage == null ? 'Add Storage' : 'Edit Storage'),
        content: Column(
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                if (storage == null) {
                  context.read<InventoryBloc>().add(
                        AddStorageEvent(
                          spaceId: space.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                } else {
                  context.read<InventoryBloc>().add(
                        UpdateStorageEvent(
                          spaceId: space.id,
                          storageId: storage.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(storage == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _StorageCard extends StatelessWidget {
  final SpaceEntity space;
  final StorageEntity storage;

  const _StorageCard({
    required this.space,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = storage.items.length;
    final totalQuantity = storage.items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity ?? 0),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.storage,
            color: Colors.blue[700],
          ),
        ),
        title: Text(
          storage.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (storage.description != null && storage.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(storage.description!),
            ],
            const SizedBox(height: 4),
            Text(
              '$totalItems item${totalItems != 1 ? 's' : ''}${totalQuantity > 0 ? ' · $totalQuantity total qty' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showAddEditStorageDialog(context, storage: storage);
            } else if (value == 'delete') {
              _confirmDelete(context);
            }
          },
        ),
        onTap: () {
          // Navigate using named route
          NavigationService.navigateTo(
            AppRoutes.items,
            arguments: {
              'space': space,
              'storage': storage,
            },
          );
        },
      ),
    );
  }

  void _showAddEditStorageDialog(BuildContext context, {StorageEntity? storage}) {
    final nameController = TextEditingController(text: storage?.name ?? '');
    final descriptionController = TextEditingController(text: storage?.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(storage == null ? 'Add Storage' : 'Edit Storage'),
        content: Column(
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                if (storage == null) {
                  context.read<InventoryBloc>().add(
                        AddStorageEvent(
                          spaceId: space.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                } else {
                  context.read<InventoryBloc>().add(
                        UpdateStorageEvent(
                          spaceId: space.id,
                          storageId: storage.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(storage == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Storage'),
        content: Text('Are you sure you want to delete "${storage.name}"? This will also delete all items within it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context.read<InventoryBloc>().add(
                    DeleteStorageEvent(
                      spaceId: space.id,
                      storageId: storage.id,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

