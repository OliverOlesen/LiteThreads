import 'package:flutter/material.dart';

Card groupCard(int i, String follow) {
  return Card(
    color: Colors.white,
    // You can customize the appearance of the card using the properties below
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7.0),
    ),
    child: InkWell(
      onTap: () {
        // POST Request to Follow group
        // Move to Following list
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Group Title',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (follow == "follow")
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Text(
                      "Following",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (follow != "follow") const Text("Click to Explore"),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
