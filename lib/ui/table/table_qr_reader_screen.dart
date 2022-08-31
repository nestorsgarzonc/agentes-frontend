import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TableQrReaderScreen extends ConsumerStatefulWidget {
  const TableQrReaderScreen({Key? key}) : super(key: key);

  static const route = '/table-qr-reader';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableQrReaderScreenState();
}

class _TableQrReaderScreenState extends ConsumerState<TableQrReaderScreen> {
  late MobileScannerController _controller;
  static const iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                debugPrint('Barcode found! $code');
              }
            },
            controller: _controller,
          ),
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: ValueListenableBuilder(
                    valueListenable: _controller.torchState,
                    builder: (context, value, child) {
                      switch (value as TorchState) {
                        case TorchState.on:
                          return const Icon(Icons.flash_on, color: iconColor);
                        case TorchState.off:
                          return const Icon(Icons.flash_off, color: iconColor);
                      }
                    }),
              ),
              onPressed: _controller.toggleTorch,
            ),
          ),
          Positioned(
            top: 80,
            right: 20,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: ValueListenableBuilder(
                    valueListenable: _controller.cameraFacingState,
                    builder: (context, value, child) {
                      switch (value as CameraFacing) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front, color: iconColor);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear, color: iconColor);
                      }
                    }),
              ),
              onPressed: _controller.switchCamera,
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.5),
                child: const Icon(Icons.close, color: Colors.white),
              ),
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}
