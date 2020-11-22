import 'package:flutter/material.dart';

class RecipeIngredientsCard extends StatelessWidget {
  final String name;
  final String image;
  final String amountKG;
  final String amountLR;
  final String amountN;
  final String amountAPI;
  final String unit;
  final Color textColor;

  RecipeIngredientsCard(
      {this.name,
      this.image,
      this.unit,
      this.amountKG,
      this.amountLR,
      this.amountN,
      this.amountAPI,
      this.textColor});

  ImageProvider getImage() {
    try {
      return NetworkImage(image.toString().trim());
    } catch (e) {
      return AssetImage("images/placeholder_food.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                image != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image(
                          image: getImage(),
                          height: 60,
                          width: 60,
                        ),
                      )
                    : Container(),
                Padding(
                  child: name.toString().length >= 25
                      ? Text(
                          name,
                          style: TextStyle(fontSize: 13, color: textColor),
                        )
                      : Text(
                          name,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                  padding: EdgeInsets.only(left: 8),
                ),
              ],
            ),
            Column(
              children: _getColumnChildren(),
            ),
          ],
        ),
        Divider(
          color: Colors.grey[500],
        )
      ],
    );
  }

  List<Widget> _getColumnChildren() {
    List<Widget> listToReturn = [];
    if (amountAPI != null)
      listToReturn.add(AmountWidget(amount: "$amountAPI", unit: unit));

    if (amountN != null) if (double.parse(amountN).toInt() > 0)
      listToReturn.add(AmountWidget(amount: "$amountN ${name}s"));

    if (amountKG != null) if (double.parse(amountKG) > 0)
      listToReturn.add(AmountWidget(amount: amountKG, unit: "mg"));

    if (amountLR != null) if (double.parse(amountLR) > 0)
      listToReturn.add(AmountWidget(amount: amountLR, unit: "ml"));

    return listToReturn;
  }
}

class AmountWidget extends StatelessWidget {
  final String unit;
  final String amount;

  const AmountWidget({Key key, this.unit, this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: unit != null
          ? Text(
              "${amount.toString()} $unit",
              style: TextStyle(fontSize: 15),
            )
          : Text(
              amount.toString(),
              style: TextStyle(fontSize: 15),
            ),
    );
  }
}
