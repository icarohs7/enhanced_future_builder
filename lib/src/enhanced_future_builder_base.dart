import 'package:flutter/widgets.dart';

class EnhancedFutureBuilder<T> extends StatefulWidget {
  /// Future to resolve.
  final Future<T?> future;

  /// Whether or not the future result should be stored.
  final bool rememberFutureResult;

  /// Widget to display when connected to an asynchronous computation.
  final Widget? whenActive;

  /// Widget to display when connected to an asynchronous computation and awaiting interaction.
  final Widget? whenWaiting;

  /// Widget to display when not connected to n asynchronous computation.
  final Widget? whenNone;

  /// Widget to display when the asynchronous computation is not done yet.
  final Widget whenNotDone;

  /// Function to call when the asynchronous computation is done.
  final Widget Function(T snapshotData) whenDone;

  /// Function to call when the asynchronous computation is done with error.
  /// If no function is passed, whenNotDone() will be used instead
  final Widget Function(Object? error)? whenError;

  /// The data that will be used until a non-null [future] has completed.
  ///
  /// See [FutureBuilder] for more info
  final T? initialData;

  const EnhancedFutureBuilder({
    Key? key,
    required this.future,
    required this.rememberFutureResult,
    required this.whenDone,
    required this.whenNotDone,
    this.whenError,
    this.whenActive,
    this.whenNone,
    this.whenWaiting,
    this.initialData,
  }) : super(key: key);

  @override
  _EnhancedFutureBuilderState createState() => _EnhancedFutureBuilderState<T>();
}

class _EnhancedFutureBuilderState<T> extends State<EnhancedFutureBuilder<T?>> {
  late Future<T?> _cachedFuture = widget.future;

  @override
  void initState() {
    super.initState();
    _cachedFuture = widget.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: widget.rememberFutureResult ? _cachedFuture : widget.future,
      initialData: widget.initialData,
      builder: (context, snapshot) {
        if (widget.whenActive != null &&
            snapshot.connectionState == ConnectionState.active) {
          return widget.whenActive!;
        }

        if (widget.whenNone != null &&
            snapshot.connectionState == ConnectionState.none) {
          return widget.whenNone!;
        }

        if (widget.whenWaiting != null &&
            snapshot.connectionState == ConnectionState.waiting) {
          return widget.whenWaiting!;
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            if (widget.whenError != null) {
              return widget.whenError!(snapshot.error);
            } else {
              return widget.whenNotDone;
            }
          }
          return widget.whenDone(snapshot.data);
        }

        return widget.whenNotDone;
      },
    );
  }
}
