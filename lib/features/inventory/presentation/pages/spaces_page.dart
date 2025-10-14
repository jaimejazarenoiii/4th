import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/widgets/animated_page_wrapper.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/space_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class SpacesPage extends StatelessWidget {
  const SpacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaces'),
        elevation: 2,
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is InventoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<InventoryBloc>().add(LoadSpacesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is InventoryLoaded) {
            if (state.spaces.isEmpty) {
              return Center(
                child: AnimatedFadeSlide(
                  duration: const Duration(milliseconds: 600),
                  offsetY: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 80,
                        color: AppColors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No spaces yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first space',
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
              itemCount: state.spaces.length,
              itemBuilder: (context, index) {
                final space = state.spaces[index];
                return AnimatedFadeSlide(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: 50 * index),
                  offsetY: 20,
                  child: _SpaceCard(space: space),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSpaceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditSpaceDialog(BuildContext context, {SpaceEntity? space}) {
    final nameController = TextEditingController(text: space?.name ?? '');
    final descriptionController = TextEditingController(text: space?.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(space == null ? 'Add Space' : 'Edit Space'),
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
                if (space == null) {
                  context.read<InventoryBloc>().add(
                        AddSpaceEvent(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                } else {
                  context.read<InventoryBloc>().add(
                        UpdateSpaceEvent(
                          id: space.id,
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
            child: Text(space == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _SpaceCard extends StatelessWidget {
  final SpaceEntity space;

  const _SpaceCard({required this.space});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            space.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          space.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (space.description != null && space.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(space.description!),
            ],
            const SizedBox(height: 4),
            Text(
              '${space.storages.length} storage${space.storages.length != 1 ? 's' : ''}',
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
              _showAddEditSpaceDialog(context, space: space);
            } else if (value == 'delete') {
              _confirmDelete(context);
            }
          },
        ),
        onTap: () {
          // Navigate using named route
          NavigationService.navigateTo(
            AppRoutes.storages,
            arguments: space,
          );
        },
      ),
    );
  }

  void _showAddEditSpaceDialog(BuildContext context, {SpaceEntity? space}) {
    final nameController = TextEditingController(text: space?.name ?? '');
    final descriptionController = TextEditingController(text: space?.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(space == null ? 'Add Space' : 'Edit Space'),
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
                if (space == null) {
                  context.read<InventoryBloc>().add(
                        AddSpaceEvent(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? null
                              : descriptionController.text.trim(),
                        ),
                      );
                } else {
                  context.read<InventoryBloc>().add(
                        UpdateSpaceEvent(
                          id: space.id,
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
            child: Text(space == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Space'),
        content: Text('Are you sure you want to delete "${space.name}"? This will also delete all storages and items within it.'),
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
              context.read<InventoryBloc>().add(DeleteSpaceEvent(id: space.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

