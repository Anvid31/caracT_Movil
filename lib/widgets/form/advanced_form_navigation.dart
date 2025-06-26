import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/form_navigator.dart';

/// Widget avanzado para navegación entre formularios con indicadores de progreso animados
class AdvancedFormNavigation extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool showPrevious;
  final bool showNext;
  final String? nextLabel;
  final String? previousLabel;
  final bool isLoading;
  final int currentStep;
  final int totalSteps;
  final FormTransitionType transitionType;
  final Color? primaryColor;

  const AdvancedFormNavigation({
    super.key,
    this.onNext,
    this.onPrevious,
    this.showPrevious = true,
    this.showNext = true,
    this.nextLabel,
    this.previousLabel,
    this.isLoading = false,
    this.currentStep = 1,
    this.totalSteps = 5,
    this.transitionType = FormTransitionType.slideScale,
    this.primaryColor,
  });

  @override
  State<AdvancedFormNavigation> createState() => _AdvancedFormNavigationState();
}

class _AdvancedFormNavigationState extends State<AdvancedFormNavigation>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _progressController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentStep / widget.totalSteps,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AdvancedFormNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.currentStep / widget.totalSteps,
        end: widget.currentStep / widget.totalSteps,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ));
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Color get primaryColor => widget.primaryColor ?? const Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de progreso avanzado
          _buildAdvancedProgressIndicator(),
          const SizedBox(height: 24),
          
          // Botones de navegación
          Row(
            children: [
              if (widget.showPrevious) ...[
                Expanded(
                  flex: 2,
                  child: _buildPreviousButton(),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                flex: 3,
                child: _buildNextButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedProgressIndicator() {
    return Column(
      children: [
        // Barra de progreso principal
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width * _progressAnimation.value,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        
        // Indicadores de pasos
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompleted = stepNumber < widget.currentStep;
            final isCurrent = stepNumber == widget.currentStep;
            
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent ? primaryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: isCurrent ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                        key: ValueKey('check'),
                      )
                    : Text(
                        '$stepNumber',
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        key: ValueKey('number-$stepNumber'),
                      ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        
        // Texto de progreso
        Text(
          'Paso ${widget.currentStep} de ${widget.totalSteps}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.onPrevious != null ? 1.0 : _buttonScaleAnimation.value,
          child: OutlinedButton.icon(
            onPressed: widget.isLoading ? null : () {
              HapticFeedback.lightImpact();
              widget.onPrevious?.call();
            },
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(widget.previousLabel ?? 'Anterior'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: primaryColor.withOpacity(0.5),
                width: 1.5,
              ),
              foregroundColor: primaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.onNext != null ? 1.0 : _buttonScaleAnimation.value,
          child: ElevatedButton.icon(
            onPressed: widget.isLoading ? null : () {
              _onNextPressed();
            },
            icon: widget.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.arrow_forward, size: 18),
            label: Text(
              widget.isLoading ? 'Procesando...' : (widget.nextLabel ?? 'Siguiente'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shadowColor: primaryColor.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onNextPressed() {
    if (widget.onNext == null || widget.isLoading) return;
    
    // Animación de feedback al presionar
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });
    
    // Feedback háptico según el tipo de transición
    switch (widget.transitionType) {
      case FormTransitionType.slideScale:
        HapticFeedback.mediumImpact();
        break;
      case FormTransitionType.layered:
        HapticFeedback.heavyImpact();
        break;
      default:
        HapticFeedback.lightImpact();
    }
    
    widget.onNext!();
  }
}

/// Extensión para crear navegación avanzada fácilmente
extension AdvancedFormNavigationExt on Widget {
  Widget withAdvancedNavigation({
    VoidCallback? onNext,
    VoidCallback? onPrevious,
    bool showPrevious = true,
    bool showNext = true,
    String? nextLabel,
    String? previousLabel,
    bool isLoading = false,
    int currentStep = 1,
    int totalSteps = 5,
    FormTransitionType transitionType = FormTransitionType.slideScale,
    Color? primaryColor,
  }) {
    return Column(
      children: [
        Expanded(child: this),
        AdvancedFormNavigation(
          onNext: onNext,
          onPrevious: onPrevious,
          showPrevious: showPrevious,
          showNext: showNext,
          nextLabel: nextLabel,
          previousLabel: previousLabel,
          isLoading: isLoading,
          currentStep: currentStep,
          totalSteps: totalSteps,
          transitionType: transitionType,
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}
