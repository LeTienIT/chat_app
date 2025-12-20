import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/my_group_bloc/my_group_bloc.dart';
import '../../../bloc/my_group_bloc/my_group_event.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  State<CreateGroupBottomSheet> createState() =>
      _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tạo nhóm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Tên',
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Mô tả',
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isValid
                ? () {
              context.read<MyGroupBloc>().add(
                CreateGroupEvent(
                  name: _nameController.text.trim(),
                  description:
                  _descController.text.trim().isEmpty
                      ? null
                      : _descController.text.trim(),
                  creatorId: userId,
                ),
              );
              Navigator.pop(context);
            }
                : null,
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
