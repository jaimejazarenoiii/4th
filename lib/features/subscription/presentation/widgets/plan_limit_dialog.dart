import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/subscription_service.dart';

class PlanLimitDialog extends StatefulWidget {
  final String message;
  final String resource;
  final int? limit;

  const PlanLimitDialog({
    super.key,
    required this.message,
    required this.resource,
    this.limit,
  });

  @override
  State<PlanLimitDialog> createState() => _PlanLimitDialogState();
}

class _PlanLimitDialogState extends State<PlanLimitDialog> {
  bool _isProcessing = false;
  String? _error;

  Future<void> _handleSubscribe() async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final platform = Platform.isIOS ? PurchasePlatform.apple : PurchasePlatform.google;
      await SubscriptionService.instance.purchasePremium(platform: platform);

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Opening store to complete your subscription.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    final isAndroid = Platform.isAndroid;
    final isSupported = isIOS || isAndroid;

    final buttonLabel = isIOS ? 'Subscribe with Apple Pay' : 'Subscribe with Google Play';
    final iconData = isIOS ? Icons.apple : Icons.android;

    return AlertDialog(
      title: const Text('Upgrade Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          const SizedBox(height: 12),
          Text(
            widget.limit != null
                ? 'Your current plan allows up to ${widget.limit} ${widget.resource}.'
                : 'You have reached the maximum number of ${widget.resource} for your current plan.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Upgrade now to continue creating ${widget.resource}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (!isSupported)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'In-app purchases are only available on iOS and Android devices.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _error!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(false),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: !_isProcessing && isSupported ? _handleSubscribe : null,
          child: _isProcessing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(iconData),
                    const SizedBox(width: 8),
                    Text(buttonLabel),
                  ],
                ),
        ),
      ],
    );
  }
}

