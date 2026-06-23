import 'package:equatable/equatable.dart';

enum BrowseNodeType { space, storage }

class BrowseNode extends Equatable {
  final String id;
  final String name;
  final BrowseNodeType type;
  final bool hasChildren;
  final int? childrenCount;
  final String? spaceId; // for storages
  final String? parentId; // for child storages

  const BrowseNode({
    required this.id,
    required this.name,
    required this.type,
    required this.hasChildren,
    this.childrenCount,
    this.spaceId,
    this.parentId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    hasChildren,
    childrenCount,
    spaceId,
    parentId,
  ];
}
