import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

void main() {
  runApp(const EdgeAIFaceApp());
}

class EdgeAIFaceApp extends StatelessWidget {
  const EdgeAIFaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edge AI Face Analyzer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const FaceAnalyzerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FaceAnalyzerScreen extends StatefulWidget {
  const FaceAnalyzerScreen({super.key});

  @override
  State<FaceAnalyzerScreen> createState() => _FaceAnalyzerScreenState();
}

class _FaceAnalyzerScreenState extends State<FaceAnalyzerScreen> {
  File? _image;
  List<FaceData> _faces = [];
  bool _isLoading = false;
  String? _error;
  bool _hasProcessed = false;

  final ImagePicker _picker = ImagePicker();

  // Face Detector with classification ENABLED for smile + eye probabilities
  late FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();
    _initDetector();
  }

  void _initDetector() {
    final options = FaceDetectorOptions(
      enableClassification: true,
      enableTracking: false,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);
  }

  Future<void> _pickAndAnalyze() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
        _faces = [];
        _isLoading = true;
        _error = null;
        _hasProcessed = false;
      });

      final inputImage = InputImage.fromFile(_image!);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      final faceDataList = <FaceData>[];
      int index = 1;
      for (final face in faces) {
        faceDataList.add(FaceData(index: index, face: face));
        index++;
      }

      setState(() {
        _faces = faceDataList;
        _isLoading = false;
        _hasProcessed = true;
      });
    } catch (e) {
      setState(() {
        _error = "Error saat memproses gambar: $e";
        _isLoading = false;
        _hasProcessed = true;
      });
    }
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  String _getSmileText(Face face) {
    if (face.smilingProbability == null) {
      return "Tidak terdeteksi";
    }
    final prob = (face.smilingProbability! * 100).toStringAsFixed(0);
    final label = face.smilingProbability! > 0.5 ? "Senyum" : "Tanpa Senyum";
    return "$label ($prob%)";
  }

  String _getLeftEyeText(Face face) {
    if (face.leftEyeOpenProbability == null) {
      return "Tidak terdeteksi";
    }
    final prob = (face.leftEyeOpenProbability! * 100).toStringAsFixed(0);
    final label = face.leftEyeOpenProbability! > 0.5 ? "Terbuka" : "Tertutup";
    return "Mata Kiri $label ($prob%)";
  }

  String _getRightEyeText(Face face) {
    if (face.rightEyeOpenProbability == null) {
      return "Tidak terdeteksi";
    }
    final prob = (face.rightEyeOpenProbability! * 100).toStringAsFixed(0);
    final label = face.rightEyeOpenProbability! > 0.5 ? "Terbuka" : "Tertutup";
    return "Mata Kanan $label ($prob%)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edge AI Face Analyzer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Edge AI Badge
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.psychology, color: Colors.indigo.shade700, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Edge AI • 100% On-Device Processing',
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Preview
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face,
                            size: 64,
                            color: Colors.indigo.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Pilih foto wajah dari galeri',
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AI mendeteksi wajah & ekspresi',
                            style: TextStyle(
                              color: Colors.indigo.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Pick Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickAndAnalyze,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Pilih Foto dari Galeri'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Loading State
            if (_isLoading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'AI menganalisis wajah...',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],

            // Error State
            if (_error != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Results Section - Faces Found
            if (!_isLoading && _hasProcessed && _faces.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.face, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Hasil Analisis:',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_faces.length} wajah terdeteksi',
                      style: TextStyle(
                        color: Colors.indigo.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._faces.map((faceData) => _buildFaceCard(faceData)),
            ],

            // No Faces Found
            if (!_isLoading && _hasProcessed && _faces.isEmpty && _error == null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 48,
                      color: Colors.orange.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tidak ada wajah manusia yang terdeteksi.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih foto yang jelas menampilkan wajah.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFaceCard(FaceData faceData) {
    final face = faceData.face;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.indigo.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade50,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Face Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.face,
                  color: Colors.indigo.shade700,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Wajah ${faceData.index}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Smile Result
          _buildResultRow(
            icon: face.smilingProbability != null && face.smilingProbability! > 0.5
                ? Icons.sentiment_satisfied_alt
                : Icons.sentiment_neutral,
            iconColor: face.smilingProbability != null && face.smilingProbability! > 0.5
                ? Colors.green
                : Colors.grey,
            label: 'Ekspresi',
            value: _getSmileText(face),
            valueColor: face.smilingProbability != null && face.smilingProbability! > 0.5
                ? Colors.green
                : Colors.grey.shade700,
          ),

          const SizedBox(height: 10),

          // Left Eye
          _buildResultRow(
            icon: Icons.remove_red_eye_outlined,
            iconColor: Colors.blue.shade400,
            label: 'Mata Kiri',
            value: _getLeftEyeText(face),
            valueColor: Colors.grey.shade700,
          ),

          const SizedBox(height: 10),

          // Right Eye
          _buildResultRow(
            icon: Icons.remove_red_eye_outlined,
            iconColor: Colors.blue.shade400,
            label: 'Mata Kanan',
            value: _getRightEyeText(face),
            valueColor: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// Helper class to hold face data with index
class FaceData {
  final int index;
  final Face face;

  FaceData({required this.index, required this.face});
}