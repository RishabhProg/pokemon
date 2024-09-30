//import 'package:first/shop.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/game.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

class start extends StatelessWidget {
  const start({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(11, 11, 11, 1),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: height * 0.1, // Set the top position
              left: width * 0.15, // Set the left position
              child: const Text(
                "平",
                style: TextStyle(
                    fontSize: 300,
                    fontWeight: FontWeight.w100,
                    color: Color.fromRGBO(246, 246, 246, 0.3)),
              ),
            ),
            Positioned(
              top: height * 0.15,
              left: width * 0.25,
              child: Image.asset(
                "assets/pikachu.png",
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: height * 0.35,
              left: width * 0.1,
              child: Image.asset(
                "assets/squirtle.png",
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: height * 0.32,
              left: width * 0.4,
              child: Image.asset(
                "assets/psyduck.png",
                width: 120,
                height: 120,
              ),
            ),
            Positioned(
              top: height * 0.45,
              left: width * 0.25,
              child: Image.asset(
                "assets/charlizard.png",
                width: 180,
                height: 180,
              ),
            ),
            Positioned(
              top: height * 0.23,
              left: width * 0.65,
              child: Image.asset(
                "assets/balbasaur.png",
                width: 100,
                height: 100,
              ),
            ),
            Positioned(
              top: height * 0.45,
              left: width * 0.68,
              child: Image.asset(
                "assets/gangar.png",
                width: 100,
                height: 100,
              ),
            ),
            Positioned(
              top: height * 0.6,
              left: width * 0.06,
              child: Image.asset(
                "assets/pokemon.png",
                width: 200,
                height: 200,
              ),
            ),
            Positioned(
              top: height * 0.78,
              bottom: height * 0.04,
              left: width * 0.1,
              right: width * 0.1,
              child: Text(
                "Dive into the world of Pokemon\nand test your knowledge.",
                style: TextStyle(
                  color: Color.fromRGBO(189, 187, 187, 1),
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              top: height * 0.9,
              bottom: height * 0.04,
              left: width * 0.1,
              right: width * 0.1,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const game()));
                },
                icon: const Icon(
                  Icons.arrow_right,
                  color: Color.fromRGBO(251, 250, 250, 1),
                ),
                label: const Text(
                  "Get Started",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(248, 243, 243, 1)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(213, 80, 80, 1),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Set the border radius
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
