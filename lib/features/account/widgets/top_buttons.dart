import 'package:flutter/material.dart';

import 'account_button.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: 'Your orders',
              onPressed: () {},
            ),
            AccountButton(
              text: 'Turn Seller',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: 'Log out',
              onPressed: () {},
            ),
            AccountButton(
              text: 'Your wishlist',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
