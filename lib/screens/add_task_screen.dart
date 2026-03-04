import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/difficulty_chip.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  String _difficulty = 'medium';
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _saving) return;

    setState(() => _saving = true);

    await context.read<TaskProvider>().addTask(
      title: title,
      difficulty: _difficulty,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final reward = xpRewards[_difficulty] ?? 0;
    final penalty = xpPenalties[_difficulty] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              maxLength: 100,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'What do you need to do?',
                hintStyle: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.6)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.surfaceLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.xpAmber),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Difficulty',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['easy', 'medium', 'hard'].map((d) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: DifficultyChip(
                    difficulty: d,
                    selected: _difficulty == d,
                    onTap: () => setState(() => _difficulty = d),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Complete: +$reward XP  ·  Miss: −$penalty XP',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.xpAmber,
                  foregroundColor: const Color(0xFF121220),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
