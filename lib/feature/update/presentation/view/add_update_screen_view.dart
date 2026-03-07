
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repo/post_repostory_impl.dart';
import '../../domain/repo/post_report_repo.dart';
import '../controller/add_update_post_controller.dart';

class AddUpdateScreenView extends StatefulWidget {
  const AddUpdateScreenView({super.key});

  @override
  State<AddUpdateScreenView> createState() => _AddUpdateScreenViewState();
}

class _AddUpdateScreenViewState extends State<AddUpdateScreenView> {
  final TextEditingController _descriptionController = TextEditingController();
  late final AddUpdateController _controller;

  @override
  void initState() {
    super.initState();

    // Repo + RepoImpl + Controller wiring
    final repo = PostRepositoryImpl(ImagePicker());
    _controller = AddUpdateController(repo: repo);

    _controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showPickSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF132028),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(ctx);
                await _controller.pickPhoto(PhotoSource.camera); // ✅ controller call
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(ctx);
                await _controller.pickPhoto(PhotoSource.gallery); // ✅ controller call
              },
            ),
            if (_controller.draft.imageFile != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.white70),
                title: const Text('Remove', style: TextStyle(color: Colors.white70)),
                onTap: () {
                  Navigator.pop(ctx);
                  _controller.removePhoto(); // ✅ controller call
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPost() async {
    // description controller -> controller draft sync
    _controller.setDescription(_descriptionController.text);

    await _controller.submit(); // ✅ controller -> repo.createPost()

    if (!mounted) return;

    if (_controller.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted!')));
      Navigator.of(context).maybePop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_controller.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF08151C);
    const card = Color(0xFF132028);
    const accent = Color(0xFFD7C5A4);

    final isPosting = _controller.isLoading;
    final canPost = _controller.draft.canPost;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: isPosting ? null : () => Navigator.of(context).maybePop(),
                          style: TextButton.styleFrom(
                            foregroundColor: accent,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(56, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        const Spacer(),
                        const Text(
                          'New Post',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: (isPosting || !canPost) ? null : _onPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: accent.withValues(alpha: 0.6),
                              disabledForegroundColor: Colors.white70,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                              elevation: 0,
                            ),
                            child: isPosting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                                  )
                                : const Text('Post', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ✅ Image area (preview if selected)
                    CustomPaint(
                      painter: const _DashedRRectPainter(color: accent, borderRadius: 22, strokeWidth: 2, dashWidth: 8, dashSpace: 6),
                      child: Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(color: card.withValues(alpha: 0.35), borderRadius: BorderRadius.circular(22)),
                        child: _controller.draft.imageFile == null
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: isPosting ? null : _showPickSheet,
                                      borderRadius: BorderRadius.circular(26),
                                      child: Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                                        child: const Icon(Icons.add_rounded, color: Colors.white70, size: 34),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Add site photo',
                                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.file(
                                  _controller.draft.imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222A31).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        onChanged: _controller.setDescription, // ✅ controller call
                        maxLines: 5,
                        minLines: 5,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: 'Enter description...',
                          hintStyle: TextStyle(color: Color(0xFF7C7F84), fontSize: 20),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),

                    if (_controller.error != null) ...[
                      const SizedBox(height: 12),
                      Text(_controller.error!, style: const TextStyle(color: Colors.redAccent)),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect.deflate(strokeWidth / 2), Radius.circular(borderRadius));
    final path = Path()..addRRect(rRect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
