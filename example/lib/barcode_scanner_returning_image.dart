import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerReturningImage extends StatefulWidget {
  const BarcodeScannerReturningImage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerReturningImageState createState() =>
      _BarcodeScannerReturningImageState();
}

class _BarcodeScannerReturningImageState
    extends State<BarcodeScannerReturningImage>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcode;
  MobileScannerArguments? arguments;

  MobileScannerController controller = MobileScannerController(
    // torchEnabled: true,
    returnImage: true,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              Container(
                color: Colors.blueGrey,
                width: double.infinity,
                height: 0.33 * MediaQuery.of(context).size.height,
                child: barcode?.image != null
                    ? Transform.rotate(
                        angle: 90 * pi / 180,
                        child: Image(
                          gaplessPlayback: true,
                          image: MemoryImage(barcode!.image!),
                          fit: BoxFit.contain,
                        ),
                      )
                    : const ColoredBox(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'Your scanned barcode will appear here!',
                          ),
                        ),
                      ),
              ),
              Container(
                height: 0.66 * MediaQuery.of(context).size.height,
                color: Colors.grey,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      fit: BoxFit.contain,
                      // allowDuplicates: true,
                      // controller: MobileScannerController(
                      //   torchEnabled: true,
                      //   facing: CameraFacing.front,
                      // ),
                      onDetect: (barcode, arguments) {
                        setState(() {
                          this.arguments = arguments;
                          this.barcode = barcode;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: 100,
                        color: Colors.black.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ColoredBox(
                              color: arguments != null && !arguments!.hasTorch
                                  ? Colors.red
                                  : Colors.white,
                              child: IconButton(
                                // color: ,
                                icon: ValueListenableBuilder(
                                  valueListenable: controller.torchState,
                                  builder: (context, state, child) {
                                    if (state == null) {
                                      return const Icon(
                                        Icons.flash_off,
                                        color: Colors.grey,
                                      );
                                    }
                                    switch (state as TorchState) {
                                      case TorchState.off:
                                        return const Icon(
                                          Icons.flash_off,
                                          color: Colors.grey,
                                        );
                                      case TorchState.on:
                                        return const Icon(
                                          Icons.flash_on,
                                          color: Colors.yellow,
                                        );
                                    }
                                  },
                                ),
                                iconSize: 32.0,
                                onPressed: () => controller.toggleTorch(),
                              ),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: isStarted
                                  ? const Icon(Icons.stop)
                                  : const Icon(Icons.play_arrow),
                              iconSize: 32.0,
                              onPressed: () => setState(() {
                                isStarted
                                    ? controller.stop()
                                    : controller.start();
                                isStarted = !isStarted;
                              }),
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 200,
                                height: 50,
                                child: FittedBox(
                                  child: Text(
                                    barcode?.barcodes.first.rawValue ??
                                        'Scan something!',
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: ValueListenableBuilder(
                                valueListenable: controller.cameraFacingState,
                                builder: (context, state, child) {
                                  if (state == null) {
                                    return const Icon(Icons.camera_front);
                                  }
                                  switch (state as CameraFacing) {
                                    case CameraFacing.front:
                                      return const Icon(Icons.camera_front);
                                    case CameraFacing.back:
                                      return const Icon(Icons.camera_rear);
                                  }
                                },
                              ),
                              iconSize: 32.0,
                              onPressed: () => controller.switchCamera(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
