import 'package:flutter/material.dart';
import 'dart:async';

class StopWatch extends StatefulWidget {
  final String name;
  final String email;
  const StopWatch({super.key, required this.name, required this.email});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int milliseconds = 0;
  Timer? timer;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  bool isTicking = false;

  void _onTick(Timer time) {
    if (mounted) {
      setState(() {
        milliseconds += 100;
      });
    }
  }

  String _secondsText(int milliseconds) {
    final seconds = (milliseconds / 1000).toStringAsFixed(1);
    return '$seconds seconds';
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final milliseconds = laps[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsText(milliseconds)),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.blue,
        elevation: 8,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
          Text(
            _secondsText(milliseconds),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: _startTimer,
          child: const Text("Start"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
          onPressed: _lap,
          child: const Text("Lap"),
        ),
        const SizedBox(width: 20),
        Builder(
          builder: (context) => AbsorbPointer(
            absorbing: !isTicking, 
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _stopTimer(context),
              child: const Text("Stop"),
            ),
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);

    setState(() {
      isTicking = true;
      laps.clear();
      milliseconds = 0;
    });
  }

  void _stopTimer(BuildContext context) {
    if (!isTicking) return;
    timer?.cancel();
    setState(() {
      isTicking = false;
    });

    final controller = showBottomSheet(
      context: context,
      builder: _buildRunCompleteSheet,
    );
    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (mounted) {
        controller.close();
      }
    });
  }

  Widget _buildRunCompleteSheet(BuildContext context) {
    final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Container(
        color: Theme.of(context).cardColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Run Finished!', style: textTheme.headlineSmall),
              Text('Total Run Time is ${_secondsText(totalRuntime)}.'),
            ],
          ),
        ),
      ),
    );
  }

  void _lap() {
    if (!isTicking) return;
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });
    scrollController.animateTo(
      itemHeight * laps.length,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
