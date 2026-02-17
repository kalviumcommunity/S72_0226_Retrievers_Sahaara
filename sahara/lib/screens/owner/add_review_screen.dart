import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/review_model.dart';
import '../../providers/review_provider.dart';
import '../../widgets/custom_button.dart';

/// Screen for owners to add reviews for caregivers
class AddReviewScreen extends StatefulWidget {
  final String bookingId;
  final String caregiverId;
  final String petId;

  const AddReviewScreen({
    super.key,
    required this.bookingId,
    required this.caregiverId,
    required this.petId,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  double _rating = 5.0;
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  final List<String> _availableTags = [
    'Punctual',
    'Caring',
    'Professional',
    'Communicative',
    'Trustworthy',
    'Experienced',
    'Patient',
    'Friendly',
    'Reliable',
    'Attentive',
  ];

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final review = ReviewModel(
      reviewId: '',
      bookingId: widget.bookingId,
      caregiverId: widget.caregiverId,
      ownerId: user.uid,
      petId: widget.petId,
      rating: _rating,
      comment: _commentController.text.trim(),
      tags: _selectedTags,
      createdAt: DateTime.now(),
    );

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    final reviewId = await reviewProvider.createReview(review);

    setState(() => _isSubmitting = false);

    if (reviewId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reviewProvider.error ?? 'Failed to submit review'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Rating Section
            Text(
              'How was your experience?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    _rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating.floor()
                              ? Icons.star
                              : index < _rating
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 40,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = (index + 1).toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 8,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tags Section
            Text(
              'What did you like?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Comment Section
            Text(
              'Share your experience',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _commentController,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Tell us about your experience with this caregiver...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please share your experience';
                }
                if (value.trim().length < 10) {
                  return 'Please write at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            CustomButton(
              text: 'Submit Review',
              onPressed: _isSubmitting ? null : _submitReview,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
