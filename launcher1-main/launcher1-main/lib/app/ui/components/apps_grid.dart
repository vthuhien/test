import 'package:flutter/material.dart';
import 'package:launcher1/app/ui/components/apps_item_view.dart';
import 'package:launcher1/app/ui/components/scroll_effect.dart';
import 'package:launcher1/gen/assets.gen.dart';

class AppItem {
  final String title;
  final String package;
  final String icon;

  AppItem({
    required this.title,
    required this.package,
    required this.icon,
  });
}

class AppsGrid extends StatefulWidget {
  const AppsGrid({super.key});

  @override
  State<AppsGrid> createState() => _AppsGridState();
}

class _AppsGridState extends State<AppsGrid> {
  final List<AppItem> _apps = [
    AppItem(
      title: 'Телефон',
      package: 'com.android.dialer',
      icon: Assets.images.icCall,
    ),
    AppItem(
      title: 'SMS',
      package: 'com.android.mms',
      icon: Assets.images.icMessage,
    ),
    AppItem(
      title: 'Калькулятор',
      package: 'com.sprd.sprdcalculator',
      icon: Assets.images.icMath,
    ),
    AppItem(
      title: 'Календарь',
      package: 'com.android.calendar',
      icon: Assets.images.icCalendar,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Для маленьких экранов 2 столбца, иначе 3
    // final crossAxisCount = screenWidth < 600 ? 2 : 3;

    // Вычисляем количество столбцов
    // Минимальное количество столбцов - 1
    final crossAxisCount = (screenWidth / 150).floor().clamp(1, 5);

    final spacing = crossAxisCount * 6.0;

    return AbsorbPointer(
      // Disable Touch
      child: Center(
        child: ScrollConfiguration(
          behavior: ScrollEffect(),
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Количество столбцов
              crossAxisSpacing: spacing, // Расстояние между столбцами
              mainAxisSpacing: spacing, // Расстояние между строками
            ),
            itemCount: _apps.length,
            itemBuilder: (context, index) => AppsItemView(item: _apps[index]),
          ),
        ),
      ),
    );
  }
}
