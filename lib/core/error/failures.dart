import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class PlanLimitFailure extends Failure {
  final String resource;
  final int? limit;

  const PlanLimitFailure({
    required String message,
    required this.resource,
    this.limit,
  }) : super(message);

  @override
  List<Object?> get props => [message, resource, limit];
}
