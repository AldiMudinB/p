import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:saverp_app/bloc/pemasukanKategori/pemasukanKategori_bloc.dart';
import 'package:saverp_app/bloc/pengeluaranKategori/pengeluaranKategori_bloc.dart';
import 'package:saverp_app/bloc/rencanaAnggaran/rencanaAnggaran_bloc.dart';
import 'package:saverp_app/models/functions.dart';
import 'package:saverp_app/models/konfigurasiApps.dart';
import 'package:saverp_app/models/pemasukanKategori.dart';
import 'package:saverp_app/models/pengeluaranKategori.dart';
import 'package:saverp_app/models/rencanaAnggaran.dart';
import 'package:saverp_app/models/widget.dart';

class BottomModalCategory extends StatefulWidget {
  final Function(int)? changeScreen;

  const BottomModalCategory({this.changeScreen, Key? key}) : super(key: key);

  @override
  State<BottomModalCategory> createState() => _BottomModalCategoryState();
}

class _BottomModalCategoryState extends State<BottomModalCategory>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Pengeluaran'),
    Tab(text: 'Pemasukan'),
    Tab(text: 'Rencana'),
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: AppColors.neutral,
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 32,
              width: 280,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.base300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 2, color: AppColors.accent),
                      color: AppColors.accent),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2,
                  labelColor: AppColors.base100,
                  unselectedLabelColor: AppColors.base300,
                  tabs: myTabs),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: TabBarView(controller: _tabController, children: [
                BlocBuilder<ExpenseCategoryBloc, ExpenseCategoryState>(
                  builder: (context, state) {
                    if (state is ExpenseCategoryInitial ||
                        state is ExpenseCategoryUpdated) {
                      context
                          .read<ExpenseCategoryBloc>()
                          .add(const GetExpenseCategories());
                    }
                    if (state is ExpenseCategoryLoaded) {
                      if (state.category.isNotEmpty) {
                        return GridView.count(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                          children: state.category
                              .map((categoryItem) => ExpenseCategoryButton(
                                  category: categoryItem,
                                  changeScreen: widget.changeScreen))
                              .toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
                  },
                ),
                BlocBuilder<IncomeCategoryBloc, IncomeCategoryState>(
                  builder: (context, state) {
                    if (state is IncomeCategoryInitial ||
                        state is IncomeCategoryUpdated) {
                      context
                          .read<IncomeCategoryBloc>()
                          .add(const GetIncomeCategories());
                    }
                    if (state is IncomeCategoryLoaded) {
                      if (state.category.isNotEmpty) {
                        return GridView.count(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                          children: state.category
                              .map((categoryItem) => IncomeCategoryButton(
                                  category: categoryItem,
                                  changeScreen: widget.changeScreen))
                              .toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
                  },
                ),
                BlocBuilder<GoalBloc, GoalState>(
                  builder: (context, state) {
                    if (state is GoalInitial || state is GoalUpdated) {
                      context.read<GoalBloc>().add(const GetGoals());
                    }
                    if (state is GoalLoaded) {
                      if (state.goal.isNotEmpty) {
                        return GridView.count(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 1,
                          children: state.goal
                              .map((goalItem) => GoalButton(
                                  goal: goalItem,
                                  changeScreen: widget.changeScreen))
                              .toList(),
                        );
                      }
                    }
                    return const NoDataWidget();
                  },
                ),
              ]),
            ),
          ],
        ));
  }
}

class GoalButton extends StatelessWidget {
  final Goal goal;
  final Function(int)? changeScreen;

  const GoalButton({required this.goal, this.changeScreen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        openBottomModalAmount(context, goal, changeScreen: changeScreen!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  text: goal.name),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 24,
            child: Text(
              goal.name.isNotEmpty
                  ? goal.name
                      .split(" ")
                      .map((e) => e[0])
                      .take(2)
                      .join()
                      .toUpperCase()
                  : "",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategoryButton extends StatelessWidget {
  final ExpenseCategory category;
  final Function(int)? changeScreen;

  const ExpenseCategoryButton(
      {required this.category, this.changeScreen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        openBottomModalAmount(context, category, changeScreen: changeScreen!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  text: category.name),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 24,
            child: category.icon != null
                ? Icon(
                    deserializeIcon(jsonDecode(category.icon!)),
                    color: AppColors.primary,
                  )
                : Text(
                    category.name.isNotEmpty
                        ? category.name
                            .split(" ")
                            .map((e) => e[0])
                            .take(2)
                            .join()
                            .toUpperCase()
                        : "",
                    style: TextStyle(color: AppColors.primary),
                  ),
          ),
        ],
      ),
    );
  }
}

class IncomeCategoryButton extends StatelessWidget {
  final IncomeCategory category;
  final Function(int)? changeScreen;

  const IncomeCategoryButton(
      {required this.category, this.changeScreen, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        openBottomModalAmount(context, category, changeScreen: changeScreen!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  text: category.name),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 24,
            child: category.icon != null
                ? Icon(
                    deserializeIcon(jsonDecode(category.icon!)),
                    color: AppColors.primary,
                  )
                : Text(
                    category.name.isNotEmpty
                        ? category.name
                            .split(" ")
                            .map((e) => e[0])
                            .take(2)
                            .join()
                            .toUpperCase()
                        : "",
                    style: TextStyle(color: AppColors.primary),
                  ),
          ),
        ],
      ),
    );
  }
}
