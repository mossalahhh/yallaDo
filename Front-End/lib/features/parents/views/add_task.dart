import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/core/helper/app_popup.dart';
import 'package:yallado/core/utils/app_colors.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_cubit.dart';
import 'package:yallado/features/parents/cubit/children_cubit/children_state.dart';
import 'package:yallado/features/parents/views/widgets/add_task_widget.dart';
import 'package:yallado/features/tasks/cubit/create_task_cubit/create_task_cubit.dart';

class AddTaskBottomSheet extends StatelessWidget {
  const AddTaskBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChildrenCubit()..loadChildren()),
        BlocProvider(create: (_) => CreateTaskCubit()),
      ],
      child: const _AddTaskBody(),
    );
  }
}

class _AddTaskBody extends StatefulWidget {
  const _AddTaskBody();

  @override
  State<_AddTaskBody> createState() => _AddTaskBodyState();
}

class _AddTaskBodyState extends State<_AddTaskBody> {
  bool photoChecked = false;
  bool _isPrivate = true; // private = personal (needs a child); public = open
  String? selectedChildId;
  int? selectedCategoryIndex;
  String _priority = 'medium';
  DateTime? _dueDate;

  final _taskNameController = TextEditingController();
  final _pointsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _photoCountController = TextEditingController();

  List<Map<String, dynamic>> categories = [
    {"title": "Education", "imagePath": "images/eduction.png"},
    {"title": "Sports", "imagePath": "images/sport.png"},
    {"title": "Chores", "imagePath": "images/chores.png"},
  ];

  @override
  void dispose() {
    _taskNameController.dispose();
    _pointsController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _photoCountController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text("Add Category",
            style: TextStyle(color: AppColor.secondary)),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Category name.."),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.secondary),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() => categories
                    .add({"title": nameController.text, "imagePath": null}));
                Navigator.pop(dctx);
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onCreate(BuildContext context) {
    final title = _taskNameController.text.trim();
    final points = int.tryParse(_pointsController.text.trim()) ?? 0;
    if (title.isEmpty) {
      _warn(context, "Please enter a task name");
      return;
    }
    if (points <= 0) {
      _warn(context, "Please enter valid points");
      return;
    }
    if (selectedCategoryIndex == null) {
      _warn(context, "Please select a category");
      return;
    }
    if (_isPrivate && selectedChildId == null) {
      _warn(context, "Please choose a child for a private task");
      return;
    }
    final category =
        (categories[selectedCategoryIndex!]["title"] as String).toLowerCase();
    // Photo unchecked → 0 (no photo required). Server derives submissionType.
    final minImages = photoChecked
        ? (int.tryParse(_photoCountController.text.trim()) ?? 1)
        : 0;

    context.read<CreateTaskCubit>().create(
          title: title,
          type: _isPrivate ? 'personal' : 'open',
          points: points,
          category: category,
          priority: _priority,
          minImages: minImages,
          description: _descriptionController.text.trim(),
          assignedTo: _isPrivate ? selectedChildId : null,
          dueDate: _dueDate == null
              ? null
              : "${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}",
        );
  }

  void _warn(BuildContext context, String msg) => SnackBarPopUp()
      .show(context: context, message: msg, state: PopUpState.warning);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTaskCubit, CreateTaskState>(
      listener: (context, state) {
        if (state is CreateTaskSuccess) {
          Navigator.pop(context);
          SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.success);
        } else if (state is CreateTaskError) {
          SnackBarPopUp().show(
              context: context,
              message: state.message,
              state: PopUpState.error);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF9F7F0),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Text("Add Task",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondary)),
              ),
              const SizedBox(height: 24),
              const SectionLabel("Task Visibility"),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _visibilityPill(
                      label: "Private",
                      icon: Icons.lock_outline,
                      selected: _isPrivate,
                      onTap: () => setState(() => _isPrivate = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _visibilityPill(
                      label: "Public",
                      icon: Icons.public,
                      selected: !_isPrivate,
                      onTap: () => setState(() => _isPrivate = false),
                    ),
                  ),
                ],
              ),
              if (_isPrivate) ...[
                const SizedBox(height: 24),
                const SectionLabel("Choose Child"),
                const SizedBox(height: 12),
                _childrenRow(),
              ],
              const SizedBox(height: 24),
              const SectionLabel("Category"),
              const SizedBox(height: 12),
              _categoryRow(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel("Task Name"),
                        const SizedBox(height: 8),
                        customField(controller: _taskNameController, hint: ""),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const SectionLabel("Points "),
                          Image.asset("images/star.png", height: 18, width: 18),
                        ]),
                        const SizedBox(height: 8),
                        customField(controller: _pointsController, hint: ""),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel("Description"),
                        const SizedBox(height: 8),
                        customField(
                            controller: _descriptionController, hint: ""),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel("Due Date"),
                        const SizedBox(height: 8),
                        customField(
                          controller: _durationController,
                          hint: "",
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _dueDate = picked;
                                _durationController.text =
                                    "${picked.day}/${picked.month}/${picked.year}";
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel("Priority"),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _priority,
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                    value: 'low', child: Text('Low')),
                                DropdownMenuItem(
                                    value: 'medium', child: Text('Medium')),
                                DropdownMenuItem(
                                    value: 'high', child: Text('High')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _priority = v ?? 'medium'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: PhotoSection(
                      photoChecked: photoChecked,
                      photoCountController: _photoCountController,
                      onChanged: (val) =>
                          setState(() => photoChecked = val ?? false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              BlocBuilder<CreateTaskCubit, CreateTaskState>(
                builder: (context, state) {
                  final busy = state is CreateTaskLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: busy ? null : () => _onCreate(context),
                      child: busy
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Text("Add",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _visibilityPill({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD8E4CC) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected ? AppColor.secondary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColor.secondary, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _childrenRow() {
    return BlocBuilder<ChildrenCubit, ChildrenState>(
      builder: (context, state) {
        final children = context.read<ChildrenCubit>().children;
        if (children.isEmpty && state is ChildrenLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColor.secondary));
        }
        if (children.isEmpty) {
          return const Text("No children linked",
              style: TextStyle(color: Colors.grey));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: children.map((child) {
              final selected = selectedChildId == child.childId;
              return GestureDetector(
                onTap: () => setState(() => selectedChildId = child.childId),
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            selected ? AppColor.secondary : Colors.grey.shade200,
                        backgroundImage: child.avatarUrl.isNotEmpty
                            ? NetworkImage(child.avatarUrl)
                            : const AssetImage("images/avatar1.png")
                                as ImageProvider,
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(height: 5),
                      Text(child.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                            color:
                                selected ? AppColor.secondary : Colors.grey,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _categoryRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showAddCategoryDialog,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.add,
                      color: AppColor.secondary, size: 32),
                ),
                const SizedBox(height: 6),
                const Text("Add",
                    style:
                        TextStyle(fontSize: 12, color: AppColor.secondary)),
              ],
            ),
          ),
          const SizedBox(width: 18),
          ...categories.asMap().entries.map((entry) {
            return CategoryItem2(
              index: entry.key,
              selectedIndex: selectedCategoryIndex,
              category: entry.value,
              onTap: () => setState(() => selectedCategoryIndex = entry.key),
            );
          }),
        ],
      ),
    );
  }
}
