import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'package:taskoria/data/models/quest.dart';
import 'package:taskoria/presentation/providers/quest_provider.dart';

class AddQuestPage extends ConsumerStatefulWidget {
  const AddQuestPage({super.key});

  @override
  ConsumerState<AddQuestPage> createState() => _AddQuestPageState();
}

class _AddQuestPageState extends ConsumerState<AddQuestPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Work 💼';
  Priority _selectedPriority = Priority.medium;
  QuestType _selectedType = QuestType.main;
  String? _selectedRecurrence = 'Daily';
  String? _selectedStartDay = 'Monday';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Create New Quest'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: _saveQuest,
            child: Text(
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
      body: SingleChildScrollView(
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

            // Recurrence Frequency and Starting Day (for Recurrent Quest)
            if (_selectedType == QuestType.recurrent) ...[
              const SizedBox(height: 24),
              Text(
                'Recurrence Frequency',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildRecurrenceSelector(),
              const SizedBox(height: 24),
              Text(
                'Starting From Day',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildStartDaySelector(),
            ],

            const SizedBox(height: 24),
            Text(
              'Quest Title',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter quest title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryRed),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Description',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
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
                  borderSide: BorderSide(color: AppTheme.primaryRed),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        value: _selectedCategory,
                        items: [
                          'Work 💼',
                          'Personal 😊',
                          'Health 💪',
                          'Learning 📚',
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Priority',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        value:
                            _selectedPriority.name[0].toUpperCase() +
                            _selectedPriority.name.substring(1),
                        items: ['Low', 'Medium', 'High'],
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = Priority.values.firstWhere(
                              (p) =>
                                  p.name.toLowerCase() == value!.toLowerCase(),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Due Date & Time',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveQuest,
                child: const Text(
                  'Create Quest',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestTypeSelector() {
    final types = [
      {'label': 'Main Quest', 'type': QuestType.main},
      {'label': 'Side Quest', 'type': QuestType.side},
      {'label': 'Daily Quest', 'type': QuestType.recurrent},
      {'label': 'Challenge', 'type': QuestType.challenge},
      {'label': 'Urgent Quest', 'type': QuestType.urgent},
      {'label': 'Special Event', 'type': QuestType.event},
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((typeMap) {
        final isSelected = _selectedType == typeMap['type'];
        return GestureDetector(
          onTap: () =>
              setState(() => _selectedType = typeMap['type'] as QuestType),
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
              typeMap['label'] as String,
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

  Widget _buildRecurrenceSelector() {
    final frequencies = [
      'Daily',
      'Every 2 Days',
      'Every 3 Days',
      'Every 4 Days',
      'Every 5 Days',
      'Every 6 Days',
      'Weekly',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: frequencies.map((freq) {
        final isSelected = freq == _selectedRecurrence;
        return GestureDetector(
          onTap: () => setState(() => _selectedRecurrence = freq),
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
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final isSelected = day == _selectedStartDay;
        return GestureDetector(
          onTap: () => setState(() => _selectedStartDay = day),
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
              day,
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
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
            Text(
              label,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
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

  void _saveQuest() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a quest title'),
          backgroundColor: AppTheme.primaryRed,
        ),
      );
      return;
    }

    final description = _descriptionController.text.trim();
    final dueDate = (_selectedDate != null && _selectedTime != null)
        ? DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          )
        : null;

    // XP assignment (could be improved with XPService)
    int baseXP;
    switch (_selectedType) {
      case QuestType.main:
        baseXP = 100;
        break;
      case QuestType.side:
        baseXP = 60;
        break;
      case QuestType.challenge:
        baseXP = 30;
        break;
      case QuestType.urgent:
        baseXP = 80;
        break;
      case QuestType.event:
        baseXP = 200;
        break;
      case QuestType.recurrent:
        baseXP = _getRecurrentBaseXP(_selectedRecurrence);
        break;
    }

    RecurrencePattern? recurrencePattern;
    if (_selectedType == QuestType.recurrent) {
      recurrencePattern = RecurrencePattern(
        type: _getRecurrenceType(_selectedRecurrence),
        interval: _getRecurrenceInterval(_selectedRecurrence),
        startDay: _selectedStartDay,
      );
    }

    final quest = Quest(
      title: title,
      description: description,
      type: _selectedType,
      baseXP: baseXP,
      priority: _selectedPriority,
      category: _selectedCategory,
      dueDate: dueDate,
      recurrencePattern: recurrencePattern,
    );

    ref.read(questListProvider.notifier).addQuest(quest);
    Navigator.of(context).pop();
  }

  int _getRecurrentBaseXP(String? recurrence) {
    switch (recurrence) {
      case 'Daily':
        return 40;
      case 'Every 2 Days':
        return 60;
      case 'Every 3 Days':
        return 80;
      case 'Every 4 Days':
        return 90;
      case 'Every 5 Days':
        return 100;
      case 'Every 6 Days':
        return 110;
      case 'Weekly':
        return 150;
      default:
        return 40;
    }
  }

  RecurrenceType _getRecurrenceType(String? recurrence) {
    if (recurrence == 'Weekly') return RecurrenceType.weekly;
    if (recurrence == 'Daily') return RecurrenceType.daily;
    return RecurrenceType.interval;
  }

  int? _getRecurrenceInterval(String? recurrence) {
    switch (recurrence) {
      case 'Every 2 Days':
        return 2;
      case 'Every 3 Days':
        return 3;
      case 'Every 4 Days':
        return 4;
      case 'Every 5 Days':
        return 5;
      case 'Every 6 Days':
        return 6;
      default:
        return null;
    }
  }
}
