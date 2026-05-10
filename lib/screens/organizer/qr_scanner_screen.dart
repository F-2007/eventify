import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../models/ticket_model.dart';
import '../../services/ticket_service.dart';
import '../../services/qr_service.dart';
import '../../theme/app_colors.dart';

class QRScannerScreen extends StatefulWidget {
  final String? eventId;

  const QRScannerScreen({super.key, this.eventId});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;
  String? _resultMessage;
  bool? _isSuccess;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isProcessing = true);

    final qrCode = barcode.rawValue!;

    try {
      // Look up the ticket by QR code
      final TicketModel? ticket =
          await TicketService.getTicketByQrCode(qrCode);

      if (ticket == null) {
        setState(() {
          _resultMessage = 'Invalid QR Code\nNo ticket found for this code.';
          _isSuccess = false;
        });
      } else if (ticket.isCheckedIn) {
        setState(() {
          _resultMessage =
              'Already Checked In\n${ticket.event.title}\nChecked in at: ${ticket.checkInTime?.toString().substring(0, 16) ?? "Unknown"}';
          _isSuccess = false;
        });
      } else {
        // Check if this ticket belongs to the selected event
        if (widget.eventId != null &&
            ticket.event.id != widget.eventId) {
          setState(() {
            _resultMessage =
                'Wrong Event\nThis ticket is for "${ticket.event.title}"';
            _isSuccess = false;
          });
        } else {
          // Perform check-in
          await QRService.checkIn(
            eventId: ticket.event.id,
            userId: ticket.userId,
            qrCode: qrCode,
          );
          await TicketService.markCheckedIn(ticket.id);

          setState(() {
            _resultMessage =
                'Check-In Successful! ✓\n${ticket.event.title}\nTicket: ${ticket.id.substring(0, 8)}...';
            _isSuccess = true;
          });
        }
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Error processing QR code\n$e';
        _isSuccess = false;
      });
    }

    // Auto-reset after 3 seconds to allow scanning again
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _resultMessage = null;
        _isSuccess = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on, color: Colors.white),
          ),
          IconButton(
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.camera_front, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),

          // Scan overlay frame
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isSuccess == true
                      ? Colors.green
                      : _isSuccess == false
                          ? Colors.red
                          : AppColors.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Instructions at the top
          if (_resultMessage == null)
            Positioned(
              top: 20,
              left: 40,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Point camera at attendee\'s QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          // Result overlay
          if (_resultMessage != null)
            Positioned(
              bottom: 80,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: _isSuccess == true
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: (_isSuccess == true
                              ? Colors.green
                              : Colors.red)
                          .withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isSuccess == true
                          ? Icons.check_circle
                          : Icons.error,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _resultMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
