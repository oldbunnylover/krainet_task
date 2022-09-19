import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/presentation/di/injector.dart';
import 'package:krainet_task/presentation/pages/main/main_cubit.dart';
import 'package:krainet_task/presentation/utils/context_extensions.dart';
import 'package:krainet_task/presentation/widgets/keep_alive_page.dart';
import 'package:krainet_task/presentation/widgets/primary_appbar.dart';
import 'package:krainet_task/presentation/widgets/primary_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_button.dart';
import 'package:krainet_task/presentation/widgets/primary_text_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static Page<void> page() => const MaterialPage<void>(child: MainPage());

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainCubit _cubit = i.get<MainCubit>();

  @override
  void initState() {
    _cubit.init();
    super.initState();
  }

  String _getScreenName(int index) {
    switch (index) {
      case 1:
        return 'Профиль';
      default:
        return 'Главная';
    }
  }

  Widget _buildScreen(MainState state) {
    switch (state.currentPageIndex) {
      case 1:
        return _buildProfilePage(state.user);
      default:
        return _buildMainPage(state.images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: PrimaryAppbarWidget(
            title: _getScreenName(state.currentPageIndex),
            actions: kIsWeb
                ? [
                    PrimaryTextButtonWidget(
                      title: 'Главная',
                      onPressed: () => _cubit.changePageIndex(0),
                    ),
                    PrimaryTextButtonWidget(
                      title: 'Профиль',
                      onPressed: () => _cubit.changePageIndex(1),
                    ),
                  ]
                : null,
          ),
          backgroundColor: context.theme.primaryBackgroundColor,
          bottomNavigationBar: !kIsWeb
              ? _buildBottomNavigationBar(state.currentPageIndex, _cubit.changePageIndex)
              : null,
          floatingActionButton: state.currentPageIndex == 0
              ? FloatingActionButton(
                  onPressed: _cubit.pickImage,
                  backgroundColor: context.theme.actionColor,
                  child: const Icon(Icons.add),
                )
              : null,
          body: _buildScreen(state),
        );
      },
    );
  }

  Widget _buildMainPage(List<String> images) {
    if (images.isEmpty) {
      return Center(
        child: Text(
          'Нет загруженных изображений',
          style: TextStyle(color: context.theme.textColor),
        ),
      );
    } else {
      return KeepAlivePage(
        child: GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () => _showConfirmationDialog(
                'Удалить фото?',
                'Удалить',
                () => _cubit.removeImage(images[index]),
              ),
              child: Image.network(images[index], fit: BoxFit.cover),
            );
          },
        ),
      );
    }
  }

  Widget _buildProfilePage(User user) {
    if (user.isEmpty) {
      return Center(child: CircularProgressIndicator(color: context.theme.actionColor));
    } else {
      return KeepAlivePage(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                'Электронная почта:',
                style: TextStyle(color: context.theme.textColor, fontSize: 18),
              ),
              const SizedBox(height: 8),
              PrimaryTextFieldWidget(type: TextFieldType.simpleText, value: user.email),
              const SizedBox(height: 16),
              Text(
                'Имя пользователя:',
                style: TextStyle(color: context.theme.textColor, fontSize: 18),
              ),
              const SizedBox(height: 8),
              PrimaryTextFieldWidget(type: TextFieldType.simpleText, value: user.username),
              const SizedBox(height: 16),
              Text(
                'Дата рождения:',
                style: TextStyle(color: context.theme.textColor, fontSize: 18),
              ),
              const SizedBox(height: 8),
              PrimaryTextFieldWidget(
                type: TextFieldType.simpleText,
                value: DateFormat.yMd().format(user.dateOfBirth!),
              ),
              const SizedBox(height: 16),
              Center(
                child: PrimaryButtonWidget(
                  title: 'Выйти из аккаунта',
                  onPressed: () => _showConfirmationDialog(
                    'Выйти из аккаунта?',
                    'Выйти',
                    _cubit.logOut,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showConfirmationDialog(
      String title, String confirmButtonTitle, VoidCallback confirmAction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          backgroundColor: context.theme.primaryBackgroundColor,
          titlePadding: const EdgeInsets.only(top: 16, bottom: 8),
          title: Center(
            child: Text(title, style: TextStyle(color: context.theme.textColor)),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            PrimaryButtonWidget(title: 'Отмена', onPressed: Navigator.of(context).pop),
            PrimaryButtonWidget(
              title: confirmButtonTitle,
              onPressed: () {
                Navigator.of(context).pop();
                confirmAction();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(int currentIndex, ValueChanged<int> onItemTap) {
    return BottomNavigationBar(
      backgroundColor: context.theme.secondaryBackgroundColor,
      selectedItemColor: context.theme.actionColor,
      unselectedItemColor: context.theme.textColor,
      currentIndex: currentIndex,
      onTap: onItemTap,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
    );
  }
}
