import 'package:flutter/material.dart';
import 'package:vidyen_hive/utils/responsive.dart';
//import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100, right: -80,
              child: _Orb(size: r.width * 0.6,
                   color: const Color.fromARGB(255, 51, 108, 230).withOpacity(0.3)
              ),
            ),
            Positioned(
              bottom: -80, left: -60,
              child: _Orb(size: r.width * 0.5,
              color: const Color.fromARGB(255, 56, 122, 238).withOpacity(0.3)) 
              ),

              Center(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) => Opacity(
                    opacity: _fadeAnim.value,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //logo
                          Container(
                            width: r.logoSize + 24,
                             height: r.logoSize + 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color.fromARGB(255, 249, 249, 250),
                                  const Color(0xFF2A5298),
                                ],
                                ),
                                borderRadius: BorderRadius.circular((r.logoSize + 20) * 0.27),
                                boxShadow: [BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 36,
                                  spreadRadius: 4,
                                )],
                            ),

                            child: Center(
                            child: Text('V',
                                style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: (r.logoSize + 24) * 0.47,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            ),
                          ),

                           const SizedBox(height: 28),
                        Text('VIDYEN',
                            style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: r.appNameSize + 8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 9)),
                        const SizedBox(height: 12),
                        Opacity(
                          opacity: _taglineFade.value,
                          child: Text('C O N F E R E N C E   P O R T A L',
                              style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: r.sp(11),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 3)),
                         ),   
                        ],
                      ),
                    ),
                    ) 
                  ),
              ),
          ],
        ),
      ),
    );
  }
}


class _Orb extends StatelessWidget {
   final double size;
   final Color color;
   const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container (
     width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}



