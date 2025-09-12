import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:google_fonts/google_fonts.dart';
import '../controllers/report_controller.dart';
import '../responsive/responsive.dart';
import '../widgets/utils.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReportController ctrl = Get.put(ReportController());
  final TextEditingController textCtrl = TextEditingController();

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  // ---------- HEADER ----------
  Widget buildGradingTitleAndDesc(
    BuildContext context, {
    bool desktop = false,
  }) {
    final subtitleSize = desktop ? 24.0 : 20.0;
    final descSize = desktop ? 16.0 : 14.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /* Text(
          "Grading App",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: subtitleSize,
            color: Color(0xFF10794C),
          ),
          textAlign: TextAlign.center,
        ),*/
        SizedBox(height: desktop ? 8 : 6),
        Text(
          "Scan  QR codes to instantly generate grade reports. Simply scan, click generate, and download your CSV report.",
          style: GoogleFonts.inter(
            fontSize: descSize,
            height: 1.45,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: desktop ? 24 : 14),
      ],
    );
  }

  Widget buildHeader(BuildContext context, {bool desktop = false}) {
    final titleSize = desktop ? 48.0 : 42.0;
    final logoSize = desktop ? 114.0 : 94.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: desktop ? 12 : 10, bottom: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at left
              Image.asset(
                "assets/images/logo.png",
                height: logoSize,
                width: logoSize,
                fit: BoxFit.contain,
              ),
              // Spacer for left gap
              SizedBox(width: desktop ? 24 : 12),
              // Centered title, using Expanded for central alignment
              Expanded(
                child: Center(
                  child: Text(
                    "Grading App",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                      height: 1.13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // To balance row visually if needed (keep empty or align right widgets here in future)
              SizedBox(width: logoSize + (desktop ? 24 : 12)),
            ],
          ),
        ),
        // Divider below header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Divider(
            thickness: 1.3,
            color: Colors.black26,
            height: desktop ? 28 : 18,
          ),
        ),
      ],
    );
  }

  Widget buildHeaderx(BuildContext context, {bool desktop = false}) {
    final titleSize = desktop ? 48.0 : 42.0;
    final logoSize = desktop ? 114.0 : 94.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: desktop ? 32 : 20, bottom: 0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: logoSize,
                  width: logoSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: desktop ? 40 : 12),
                Text(
                  "Grading App",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                    height: 1.13,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divider below header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: desktop ? 0 : 0),
          child: Divider(
            thickness: 1.3,
            color: Colors.black26,
            height: desktop ? 28 : 18,
          ),
        ),
      ],
    );
  }



  Widget buildSummaryBar(BuildContext context, {bool desktop = false}) {
    int ok = 0, total = 0;
    for (final code in ctrl.scannedCodes) {
      final parts = ctrl.partsMap[code];
      if (parts != null) {
        total += parts.length;
        ok += parts.where((p) => p.status.toLowerCase() == 'ok').length;
      }
    }

    Color barColor;
    String label;

    if (total == 0) {
      barColor = Colors.grey;
      label = 'No data';
    } else if (ok == total) {
      barColor = Colors.green;
      label = 'All OK';
    } else {
      barColor = Colors.red;
      label = 'Issues Found';
    }

    return Card(
      elevation: 0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(desktop ? 16 : 12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),

      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: desktop ? 22 : 14,
          vertical: desktop ? 20 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall',
                  style: GoogleFonts.inter(
                    fontSize: desktop ? 18.0 : 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: barColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: desktop ? 15.0 : 14.0,
                      fontWeight: FontWeight.w600,
                      color: barColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: desktop ? 18 : 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(desktop ? 12 : 10),
              child: SizedBox(
                height: desktop ? 76 : 70,
                child: LinearProgressIndicator(
                  minHeight: desktop ? 76 : 70,
                  value: 1.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMonitorCard(BuildContext context, {bool desktop = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Container(
            // <------ Force Card to use all given height
            height: constraints.maxHeight,
            // This makes the Card always stretch to match
            padding: EdgeInsets.all(desktop ? 22 : 20),
            child: Obx(() {
              if (ctrl.scannedCodes.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // <-- forces content to top
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.green,
                          size: desktop ? 32 : 24,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Part Status Monitor",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: desktop ? 22 : 16,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: desktop ? 32 : 20),
                    Icon(
                      Icons.people_outline,
                      size: desktop ? 54 : 38,
                      color: Colors.black12,
                    ),
                    SizedBox(height: desktop ? 16 : 10),
                    Text(
                      'No Part ID scanned yet',
                      style: GoogleFonts.inter(
                        fontSize: desktop ? 18 : 15,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Scan or pick a barcode image to see status updates',
                      style: GoogleFonts.inter(
                        fontSize: desktop ? 14 : 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }

              // ... DATA TABLE PART, unchanged ...
              final code = ctrl.scannedCodes.last;
              final parts = ctrl.partsMap[code] ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, color: Colors.green, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "Parts ID: $code",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: desktop ? 21 : 18,
                        ),
                      ),
                      SizedBox(width: 12),
                      Chip(
                        label: Text(
                          parts.any((p) => p.status.toLowerCase() != 'ok')
                              ? '⚠ Issues'
                              : 'All OK',
                        ),
                        backgroundColor:
                            parts.any((p) => p.status.toLowerCase() != 'ok')
                                ? Colors.red[100]
                                : Colors.green,
                      ),
                    ],
                  ),
                  Divider(height: desktop ? 32 : 20),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DataTable(
                            columnSpacing: 62,
                            headingRowColor: MaterialStateColor.resolveWith(
                              (_) => Colors.green!,
                            ),
                            columns: [

                              DataColumn(
                                label: Text(
                                  'Character Name',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: desktop ? 19 : 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: desktop ? 19 : 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: desktop ? 19 : 16,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Time',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: desktop ? 19 : 16,
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                parts
                                    .map<DataRow>(
                                      (p) => DataRow(
                                        cells: [

                                          DataCell(
                                            Text(
                                              p.characterName,
                                              style: GoogleFonts.inter(
                                                fontSize: desktop ? 17 : 15,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    (p.status.toUpperCase() ==
                                                            'OK')
                                                        ? Colors.green[100]
                                                        : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                p.status,
                                                style: GoogleFonts.inter(
                                                  fontSize: desktop ? 16 : 14,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      (p.status.toUpperCase() ==
                                                              'OK')
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              p.date,
                                              style: GoogleFonts.inter(
                                                fontSize: desktop ? 17 : 15,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              p.time,
                                              style: GoogleFonts.inter(
                                                fontSize: desktop ? 17 : 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget buildQrCard(BuildContext context, {bool desktop = false}) {
    final ctrl = Get.find<ReportController>();
    final TextEditingController textCtrl = TextEditingController(text: ctrl.inputText.value);
    final fieldHeight = desktop ? 50.0 : 42.0;
    final buttonHeight = fieldHeight;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(desktop ? 28 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QR Scanner header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: Colors.green[800], size: desktop ? 32 : 24),
                SizedBox(width: desktop ? 12 : 8),
                Text(
                  "QR Scanner",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: desktop ? 22 : 16,
                  ),
                ),
              ],
            ),
            Divider(height: desktop ? 32 : 20),
            Text(
              "Part ID",
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: desktop ? 16 : 13,
              ),
            ),
            SizedBox(height: desktop ? 12 : 6),
            // Input row (responsive)
            Row(
              children: [
                // The input fills available space, but not more than 630 (desktop)
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: desktop ? 630 : double.infinity,
                      minWidth: 0,
                    ),
                    child: SizedBox(
                      height: fieldHeight,
                      child: TextField(
                        controller: textCtrl,
                        onChanged: (v) {
                          ctrl.inputText.value = v;
                        },
                        style: GoogleFonts.inter(fontSize: desktop ? 16 : 14),
                        decoration: InputDecoration(
                          hintText: "Scan/Type QR code...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // "GO" button
                SizedBox(
                  height: buttonHeight,
                  child: Obx(
                        () => ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow_rounded, color: Colors.white),
                      label: Text("GO"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: ctrl.inputText.value.trim().isNotEmpty
                            ? Colors.green[700]
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        minimumSize: Size(54, buttonHeight), // Just for height enforcement
                      ),
                      onPressed: ctrl.inputText.value.trim().isNotEmpty
                          ? () async {
                        FocusScope.of(context).unfocus();
                        await ctrl.handleScan(ctrl.inputText.value.trim());
                        textCtrl.clear();
                        // This setState is needed if you want your UI to update text field
                      }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            // Generate report button
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {}, // Add your download logic here
                icon: Icon(Icons.download, color: Colors.white),
                label: Text("Generate Report"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(120, buttonHeight),
                ),
              ),
            ),
            // Error messages
            Obx(
                  () => ctrl.error.value.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  ctrl.error.value,
                  style: TextStyle(color: Colors.red),
                ),
              )
                  : SizedBox.shrink(),
            ),
            // Recent scanned chips
            const SizedBox(height: 10),
            Obx(
                  () => Wrap(
                spacing: 8,
                children: ctrl.scannedCodes.map(
                      (code) => Chip(
                    label: Text("Sample: $code"),
                    onDeleted: () {
                      ctrl.clearAll();
                      textCtrl.clear();
                    },
                  ),
                ).toList(),
              ),
            ),
            SizedBox(height: desktop ? 12 : 8),
            // Footer: "Ready to scan"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: Colors.grey[800], size: desktop ? 32 : 24),
                Text(
                  "Ready to scan",
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: desktop ? 14 : 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Responsive(
          mobile: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(context),
                SizedBox(height: 18),
                buildSummaryBar(context),
                SizedBox(height: 18),
                buildMonitorCard(context),
                SizedBox(height: 18),
                buildQrCard(context),
                SizedBox(height: 16),
              ],
            ),
          ),
          desktop: Center(
            child: Container(
              //  constraints: BoxConstraints(maxWidth: 1100),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              child: Column(
                children: [
                  buildHeader(context, desktop: true),
                  SizedBox(height: 12),
                  buildGradingTitleAndDesc(context, desktop: true),
                  // moved out of header
                  buildSummaryBar(context, desktop: true),
                  SizedBox(height: 32),
                  Expanded(
                    // critical!
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildMonitorCard(context, desktop: true),
                        ),
                        SizedBox(width: 32),
                        Expanded(child: buildQrCard(context, desktop: true)),
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
