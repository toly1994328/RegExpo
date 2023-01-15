class TaskResult<T> {
  final bool success;
  final String? msg;
  final T? data;

  const TaskResult(this.success, this.msg, this.data);

  const TaskResult.error({this.msg})
      : success = false,
        data = null;

  const TaskResult.success({
    this.data,
    this.msg,
  }) : success = true;
}
