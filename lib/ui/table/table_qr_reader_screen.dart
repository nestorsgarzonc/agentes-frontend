import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/widgets/snackbar/custom_snackbar.dart';

class TableQrReaderScreen extends ConsumerStatefulWidget {
  const TableQrReaderScreen({Key? key}) : super(key: key);

  static const route = '/qr-table-reader';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: handleOnDetect,
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
              onPressed: GoRouter.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }

  void handleOnDetect(Barcode barcode, MobileScannerArguments? args) {
    if (barcode.rawValue != null) {
      ref.read(tableProvider.notifier).onReadTableCode(barcode.rawValue!);
    } else {
      CustomSnackbar.showSnackBar(context, 'Ha ocurrido un error leyendo el codigo QR');
    }
  }
}
