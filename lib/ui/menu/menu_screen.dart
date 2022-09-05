import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key, required this.tableId});

  final String tableId;

  static const route = '/menu';

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.grey,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Image.network(
                      'https://www.eltiempo.com/files/article_main/uploads/2019/06/26/5d137de78c341.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.2)),
                ],
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    'https://theme.zdassets.com/theme_assets/9934480/ce461620239931658904a0c5b98eec8d0c3da0a9.png',
                    height: 45,
                    fit: BoxFit.fitHeight,
                  ),
                  const SizedBox(width: 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Crepes & Waffles',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Mesa: 1A',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 100,
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 15,
                      top: 2,
                      bottom: 2,
                      left: index == 0 ? 10 : 0,
                    ),
                    child: Material(
                      child: InkWell(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Ink(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? Colors.grey : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              FlutterLogo(size: isSelected ? 55 : 50),
                              const Spacer(),
                              Text(
                                'Category $index',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : null,
                                  fontSize: isSelected ? 16 : null,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                5,
                (i) => Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.only(
                      right: 5,
                      top: 10,
                      bottom: 10,
                    ),
                    horizontalTitleGap: 0,
                    leading: const FlutterLogo(size: 100),
                    title: Text('Item $i'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.',
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '\$${(i + 1) * 10000}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
