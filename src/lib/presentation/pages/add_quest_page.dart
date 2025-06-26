import 'package:flutter/material.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/models/enums.dart';
import 'package:taskoria/services/quest_service.dart';
import 'package:taskoria/services/daily_quest_service.dart';

class AddQuestPage extends StatefulWidget {
  const AddQuestPage({super.key});

  @override
  State<AddQuestPage> createState() => _AddQuestPageState();
}

class _AddQuestPageState extends State<AddQuestPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'Main Quest';
  int _selectedImportance = 3; // 1-5 scale
  QuestFrequency _selectedFrequency = QuestFrequency.daily;
  int _selectedStartDay = 1; // Monday = 1
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  // Quest type mappings
  final Map<String, QuestType> _questTypeMap = {
    'Main Quest': QuestType.mainQuest,
    'Side Quest': QuestType.sideQuest,
    'Daily Quest':
        QuestType.mainQuest, // Daily quests use mainQuest type by default
    'Challenge': QuestType.challenge,
    'Urgent Quest': QuestType.urgentQuest,
    'Special Event': QuestType.specialEvent,
  };

  final Map<String, QuestFrequency> _frequencyMap = {
    'Daily': QuestFrequency.daily,
    'Every 2 Days': QuestFrequency.every2Days,
    'Every 3 Days': QuestFrequency.every3Days,
    'Every 4 Days': QuestFrequency.every4Days,
    'Every 5 Days': QuestFrequency.every5Days,
    'Every 6 Days': QuestFrequency.every6Days,
    'Weekly': QuestFrequency.weekly,
  };

  final Map<String, int> _dayMap = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Create New Quest'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveQuest,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryRed,
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quest Type Selection
              Text(
                'Quest Type',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildQuestTypeSelector(),

              // Recurrence settings (only for Daily Quest)
              if (_selectedType == 'Daily Quest') ...[
                const SizedBox(height: 24),
                Text(
                  'Recurrence Frequency',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecurrenceSelector(),

                const SizedBox(height: 24),
                Text(
                  'Starting Day',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStartDaySelector(),
              ],

              const SizedBox(height: 24),

              // Title
              Text(
                'Quest Title',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quest title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter quest title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryRed),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                'Description (Optional)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Describe your quest...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryRed),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Importance Level
              Text(
                'Importance Level',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildImportanceSelector(),

              // Due Date and Time (only for non-daily quests)
              if (_selectedType != 'Daily Quest') ...[
                const SizedBox(height: 24),
                Text(
                  'Due Date & Time',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateTimeButton(
                        label: _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Date',
                        icon: Icons.calendar_today_outlined,
                        onTap: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateTimeButton(
                        label: _selectedTime != null
                            ? _selectedTime!.format(context)
                            : 'Select Time',
                        icon: Icons.access_time_outlined,
                        onTap: _selectTime,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Create Quest Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveQuest,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _selectedType == 'Daily Quest'
                              ? 'Create Daily Quest'
                              : 'Create Quest',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Quest Preview
              _buildQuestPreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestTypeSelector() {
    final types = [
      'Main Quest',
      'Side Quest',
      'Daily Quest',
      'Challenge',
      'Urgent Quest',
      'Special Event',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = type == _selectedType;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedType = type;
              // Reset date/time for daily quests
              if (type == 'Daily Quest') {
                _selectedDate = null;
                _selectedTime = null;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryRed : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getQuestTypeIcon(type),
                  size: 16,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecurrenceSelector() {
    final frequencies = _frequencyMap.keys.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: frequencies.map((freq) {
        final isSelected = _frequencyMap[freq] == _selectedFrequency;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFrequency = _frequencyMap[freq]!;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryRed : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!,
              ),
            ),
            child: Text(
              freq,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStartDaySelector() {
    final days = _dayMap.keys.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final isSelected = _dayMap[day] == _selectedStartDay;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedStartDay = _dayMap[day]!;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryRed : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!,
              ),
            ),
            child: Text(
              day.substring(0, 3), // Show abbreviated day names
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImportanceSelector() {
    return Row(
      children: List.generate(5, (index) {
        final importance = index + 1;
        final isSelected = importance == _selectedImportance;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedImportance = importance;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryRed : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppTheme.primaryRed : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '$importance',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDateTimeButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestPreview() {
    if (_titleController.text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightRed.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview, color: AppTheme.primaryRed, size: 20),
              const SizedBox(width: 8),
              Text(
                'Quest Preview',
                style: TextStyle(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _titleController.text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          if (_descriptionController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _descriptionController.text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildPreviewChip(
                _selectedType,
                _getQuestTypeIcon(_selectedType),
              ),
              _buildPreviewChip('Importance: $_selectedImportance', Icons.star),
              if (_selectedType == 'Daily Quest')
                _buildPreviewChip(
                  _frequencyMap.keys.firstWhere(
                    (key) => _frequencyMap[key] == _selectedFrequency,
                  ),
                  Icons.repeat,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primaryRed),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryRed,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getQuestTypeIcon(String type) {
    switch (type) {
      case 'Main Quest':
        return Icons.flag;
      case 'Side Quest':
        return Icons.explore;
      case 'Daily Quest':
        return Icons.repeat;
      case 'Challenge':
        return Icons.emoji_events;
      case 'Urgent Quest':
        return Icons.priority_high;
      case 'Special Event':
        return Icons.celebration;
      default:
        return Icons.assignment;
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveQuest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final questType = _questTypeMap[_selectedType]!;

      if (_selectedType == 'Daily Quest') {
        // Create daily quest
        await DailyQuestService.createDailyQuest(
          title: title,
          description: description.isEmpty ? null : description,
          type: questType,
          frequency: _selectedFrequency,
          startWeekday: _selectedStartDay,
          importance: _selectedImportance,
        );
      } else {
        // Create regular quest
        DateTime? dueDateTime;
        if (_selectedDate != null) {
          if (_selectedTime != null) {
            dueDateTime = DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
              _selectedTime!.hour,
              _selectedTime!.minute,
            );
          } else {
            dueDateTime = DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
              23,
              59,
            );
          }
        }

        await QuestService.createQuest(
          title: title,
          description: description.isEmpty ? null : description,
          type: questType,
          dueDateTime: dueDateTime,
          importance: _selectedImportance,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedType == 'Daily Quest'
                  ? 'Daily quest created successfully!'
                  : 'Quest created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating quest: $e'),
            backgroundColor: AppTheme.primaryRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
