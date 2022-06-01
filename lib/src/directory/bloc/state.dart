import 'package:equatable/equatable.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';

abstract class ExampleState extends Equatable {
  const ExampleState();

  @override
  List<Object> get props => [];
}

class EmptyExampleState extends ExampleState {
  const EmptyExampleState();
}

class FullExampleState extends ExampleState {
  final List<RegExample> data;

  const FullExampleState({required this.data});

  @override
  List<Object> get props => [data];
}
