import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Sidebar de navigation optimisée pour Android TV
class Sidebar extends StatefulWidget {
  final Function(int) onMenuItemSelected;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onMenuItemSelected,
    this.selectedIndex = 0,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceDark,
            AppColors.backgroundDark.withOpacity(0.8),
          ],
        ),
        border: Border(
          right: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          _buildHeader(),

          const SizedBox(height: 32),

          // Menu Items
          _buildMenuItem(
            index: 0,
            icon: Icons.search,
            label: AppStrings.navSearch,
          ),
          _buildMenuItem(
            index: 1,
            icon: Icons.live_tv,
            label: AppStrings.navLive,
          ),
          _buildMenuItem(
            index: 2,
            icon: Icons.movie,
            label: AppStrings.navMovies,
          ),
          _buildMenuItem(index: 3, icon: Icons.tv, label: AppStrings.navSeries),
          _buildMenuItem(
            index: 4,
            icon: Icons.favorite,
            label: AppStrings.navFavorites,
          ),

          const Spacer(),

          _buildMenuItem(
            index: 5,
            icon: Icons.settings,
            label: AppStrings.navSettings,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              foreground:
                  Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.accentBlue, AppColors.accentPurple],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.appTagline,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = index == widget.selectedIndex;
    final isFocused = index == _focusedIndex;

    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            _focusedIndex = index;
          });
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final isSelect =
              event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter;
          if (isSelect) {
            widget.onMenuItemSelected(index);
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.accentBlue.withOpacity(0.2)
                  : isFocused
                  ? AppColors.glassLight
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border:
              isFocused
                  ? Border.all(color: AppColors.focusBorder, width: 2)
                  : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onMenuItemSelected(index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color:
                        isSelected
                            ? AppColors.accentBlue
                            : AppColors.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color:
                            isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
