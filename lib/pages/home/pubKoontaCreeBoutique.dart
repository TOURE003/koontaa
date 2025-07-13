import 'package:flutter/material.dart';
import 'package:koontaa/functions/fonctions.dart';

class BoutonVenteKoontaa extends StatefulWidget {
  final VoidCallback? onPressed;

  const BoutonVenteKoontaa({super.key, this.onPressed});

  @override
  State<BoutonVenteKoontaa> createState() => _BoutonVenteKoontaaState();
}

class _BoutonVenteKoontaaState extends State<BoutonVenteKoontaa>
    with TickerProviderStateMixin {
  late final AnimationController _shineController;
  late final Animation<double> _shineAnimation;

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Lumière glissante
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shineAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _shineController, curve: Curves.linear));

    // Rebond fluide
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.95,
      upperBound: 1.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _shineController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.onPressed?.call();
  }

  void _triggerBounce() {
    _scaleController.reverse().then((_) {
      _scaleController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _triggerBounce();
        _onTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: long(context, ratio: 0.1),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 199, 184, 47), Color(0xFFBE4A00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            /*boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],*/
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Effet de lumière glissante
              AnimatedBuilder(
                animation: _shineAnimation,
                builder: (context, child) {
                  return FractionalTranslation(
                    translation: Offset(_shineAnimation.value, 0),
                    child: Container(
                      width: 100,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Contenu principal
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.storefront, color: Colors.white, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    "Cliquez pour Vendre sur Koontaa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: larg(context, ratio: 0.045),
                      /*shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 1),
                        ),
                      ],*/
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
