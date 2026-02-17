import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/empty_state.dart';
import '../caregiver/add_activity_screen.dart';

/// Screen for viewing activity feed for a booking
class ActivityFeedScreen extends StatefulWidget {
  final String bookingId;
  final String petId;
  final bool isCaregiver;

  const ActivityFeedScreen({
    super.key,
    required this.bookingId,
    required this.petId,
    this.isCaregiver = false,
  });

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    final provider = Provider.of<ActivityProvider>(context, listen: false);
    provider.subscribeToActivities(widget.bookingId);
  }

  @override
  void dispose() {
    final provider = Provider.of<ActivityProvider>(context, listen: false);
    provider.unsubscribeFromActivities();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        actions: [
          if (widget.isCaregiver)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddActivityScreen(
                      bookingId: widget.bookingId,
                      petId: widget.petId,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LoadingSkeleton(height: 150),
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadActivities,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final activities = provider.activities;

          if (activities.isEmpty) {
            return EmptyState(
              icon: Icons.pets,
              message: 'No activities yet',
              description: widget.isCaregiver
                  ? 'Start sharing updates about the pet'
                  : 'Updates will appear here',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityCard(activity);
            },
          );
        },
      ),
      floatingActionButton: widget.isCaregiver
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddActivityScreen(
                      bookingId: widget.bookingId,
                      petId: widget.petId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Update'),
            )
          : null,
    );
  }

  Widget _buildActivityCard(ActivityModel activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _buildActivityIcon(activity.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getActivityTitle(activity.type),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimestamp(activity.timestamp),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isCaregiver)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteActivity(activity),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Photo
            if (activity.photoUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.photoUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error_outline, size: 48),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Description
            if (activity.description != null && activity.description!.isNotEmpty)
              Text(
                activity.description!,
                style: const TextStyle(fontSize: 14),
              ),

            // Location
            if (activity.location != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      activity.location!.address ?? 
                          '${activity.location!.latitude.toStringAsFixed(6)}, ${activity.location!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'photo':
        icon = Icons.photo_camera;
        color = Colors.blue;
        break;
      case 'milestone':
        icon = Icons.star;
        color = Colors.amber;
        break;
      case 'location':
        icon = Icons.location_on;
        color = Colors.green;
        break;
      default:
        icon = Icons.text_fields;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _getActivityTitle(String type) {
    switch (type) {
      case 'photo':
        return 'Photo Update';
      case 'milestone':
        return 'Milestone';
      case 'location':
        return 'Location Update';
      default:
        return 'Update';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Future<void> _deleteActivity(ActivityModel activity) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final provider = Provider.of<ActivityProvider>(context, listen: false);
      final success = await provider.deleteActivity(
        bookingId: widget.bookingId,
        activityId: activity.activityId,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Activity deleted')),
        );
      }
    }
  }
}
