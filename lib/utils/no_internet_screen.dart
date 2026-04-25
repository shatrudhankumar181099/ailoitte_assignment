import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  final bool isConnected;

  const NoInternetScreen({super.key, required this.isConnected});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    visible = !widget.isConnected;
  }

  @override
  void didUpdateWidget(covariant NoInternetScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isConnected) {
      setState(() => visible = true);
    }

    if (widget.isConnected && !oldWidget.isConnected) {
      setState(() => visible = true);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => visible = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      top: visible ? 10 : -100,
      left: 12,
      right: 12,
      child: SafeArea(
        bottom: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isConnected
                ? Colors.green.shade600
                : Colors.red.shade600,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.isConnected ? Icons.wifi : Icons.wifi_off,
                  key: ValueKey(widget.isConnected),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  widget.isConnected
                      ? "You're back online"
                      : "No internet connection",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              if (widget.isConnected)
                const Icon(Icons.check_circle, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}