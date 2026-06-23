import 'package:equatable/equatable.dart';

abstract class StorageDetailsEvent extends Equatable {
  const StorageDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadStorageDetails extends StorageDetailsEvent {
  final String storageId;

  const LoadStorageDetails({required this.storageId});

  @override
  List<Object> get props => [storageId];
}

class LoadSubStorages extends StorageDetailsEvent {
  final String storageId;
  final int page;
  final bool loadAll;

  const LoadSubStorages({
    required this.storageId,
    this.page = 1,
    this.loadAll = false,
  });

  @override
  List<Object> get props => [storageId, page, loadAll];
}

class LoadItems extends StorageDetailsEvent {
  final String storageId;
  final int page;

  const LoadItems({required this.storageId, this.page = 1});

  @override
  List<Object> get props => [storageId, page];
}

class RefreshStorageDetails extends StorageDetailsEvent {
  final String storageId;

  const RefreshStorageDetails({required this.storageId});

  @override
  List<Object> get props => [storageId];
}
