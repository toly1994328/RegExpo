import 'package:equatable/equatable.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';

abstract class ExampleEvent extends Equatable {
  const ExampleEvent();

  @override
  List<Object?> get props => [];
}

class FetchExample extends ExampleEvent {
  const FetchExample();
}

class AddExample extends ExampleEvent {
  final RegExample example;
  const AddExample(this.example);
}

class RemoveExample extends ExampleEvent {
  final int id;
  const RemoveExample(this.id);
}