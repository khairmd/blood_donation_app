import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const CustomPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> pageButtons = [];
    Set<int> displayedPageNumbers = {}; // To track displayed page numbers

    // Previous Button
    pageButtons.add(
      _buildIconButton(
        icon: Icons.chevron_left,
        onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
      ),
    );

    // First Page Button
    if (totalPages > 1 && currentPage > 1) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: 1,
          isSelected: currentPage == 1,
          onPressed: () => onPageChanged(1),
        ),
      );
      displayedPageNumbers.add(1);
    }

    // Ellipsis after First Page
    if (totalPages > 3 && currentPage > 3 && !displayedPageNumbers.contains(1)) {
      pageButtons.add(const Text('...'));
    } else if (totalPages > 3 && currentPage > 2 && displayedPageNumbers.contains(1) && currentPage != 3) {
      pageButtons.add(const Text('...'));
    }

    // Current page - 2
    if (currentPage > 2 && !displayedPageNumbers.contains(currentPage - 2)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: currentPage - 2,
          isSelected: false,
          onPressed: () => onPageChanged(currentPage - 2),
        ),
      );
      displayedPageNumbers.add(currentPage - 2);
    }

    // Current page - 1
    if (currentPage > 1 && !displayedPageNumbers.contains(currentPage - 1)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: currentPage - 1,
          isSelected: false,
          onPressed: () => onPageChanged(currentPage - 1),
        ),
      );
      displayedPageNumbers.add(currentPage - 1);
    }

    // Current page
    if (!displayedPageNumbers.contains(currentPage)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: currentPage,
          isSelected: true,
          onPressed: () => onPageChanged(currentPage),
        ),
      );
      displayedPageNumbers.add(currentPage);
    }

    // Current page + 1
    if (currentPage < totalPages && !displayedPageNumbers.contains(currentPage + 1)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: currentPage + 1,
          isSelected: false,
          onPressed: () => onPageChanged(currentPage + 1),
        ),
      );
      displayedPageNumbers.add(currentPage + 1);
    }

    // Current page + 2
    if (currentPage < totalPages - 1 && !displayedPageNumbers.contains(currentPage + 2)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: currentPage + 2,
          isSelected: false,
          onPressed: () => onPageChanged(currentPage + 2),
        ),
      );
      displayedPageNumbers.add(currentPage + 2);
    }

    // Ellipsis before Last Page
    if (currentPage < totalPages - 2) pageButtons.add(const Text('...'));

    // Last Page
    if (totalPages > 1 && !displayedPageNumbers.contains(totalPages)) {
      pageButtons.add(
        _buildPageButton(
          pageNumber: totalPages,
          isSelected: currentPage == totalPages,
          onPressed: () => onPageChanged(totalPages),
        ),
      );
      displayedPageNumbers.add(totalPages);
    }

    // Next Button
    pageButtons.add(
      _buildIconButton(
        icon: Icons.chevron_right,
        onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageButtons,
    );
  }

  Widget _buildPageButton({
    required int pageNumber,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? AppColors.borderColor : Colors.white,
          minimumSize: const Size(36, 36),
          padding: pageNumber.toString().length >= 3
              ? const EdgeInsets.symmetric(horizontal: 4)
              : EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text('$pageNumber'),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Icon(icon),
      ),
    );
  }
}