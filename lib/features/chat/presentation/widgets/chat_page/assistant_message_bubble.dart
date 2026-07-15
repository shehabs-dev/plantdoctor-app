import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/error_message_key.dart';
import '../../../../../core/helpers/error_message_key_x.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../domain/entities/message_entity.dart';

class AssistantMessageBubble extends StatelessWidget {
  const AssistantMessageBubble({super.key, required this.message});

  final MessageEntity message;

  bool _isErrorKey(String? response) {
    if (response == null) return false;
    return ErrorMessageKey.values.any((k) => k.name == response);
  }

  bool _isLabelResult(String? response) {
    return response != null && response.startsWith('label:');
  }

  ErrorMessageKey _getErrorKey(String response) {
    return ErrorMessageKey.values.firstWhere(
      (k) => k.name == response,
      orElse: () => ErrorMessageKey.unexpected,
    );
  }

  TextDirection _detectDirection(String text) {
    final rtlRegex = RegExp(
      r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\uFB1D-\uFB4F\uFE70-\uFEFF]',
    );
    return rtlRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  void _copyToClipboard(BuildContext context, String text) {
    final plainText = text
        .replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'\*(.*?)\*'), (m) => m[1] ?? '')
        .replaceAllMapped(RegExp(r'`(.*?)`'), (m) => m[1] ?? '')
        .replaceAll(RegExp(r'#{1,6}\s'), '')
        .replaceAll(RegExp(r'^label:'), '')
        .trim();
    Clipboard.setData(ClipboardData(text: plainText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final response = message.ragResponse ?? '';
    final isError = _isErrorKey(response);
    final isLabel = _isLabelResult(response);

    // Bubble always occupies the full available width (screen − own margins).
    // Tables that exceed this width scroll horizontally inside the bubble.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1.0.sw - 32.w),
        child: Container(
          margin: EdgeInsetsDirectional.only(
            start: 8.w,
            end: 24.w,
            top: 4.h,
            bottom: 4.h,
          ),
          decoration: BoxDecoration(
            color: isError
                ? theme.colorScheme.errorContainer
                : isLabel
                ? theme.brightness == Brightness.light
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        )
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(AppSizes.radiusSm),
              topEnd: Radius.circular(AppSizes.radiusLg),
              bottomStart: Radius.circular(AppSizes.radiusLg),
              bottomEnd: Radius.circular(AppSizes.radiusLg),
            ),
          ),
          child: isError
              ? _buildError(context, theme, response)
              : isLabel
              ? _buildClassificationResult(context, theme, response)
              : _buildResponse(context, theme, response),
        ),
      ),
    );
  }

  /// Shared [MarkdownStyleSheet] used by every [MarkdownBody] in this cbubble.
  /// Pass [withBlockquote] true only for the main response path which renders
  /// blockquotes; the AI path does not need it.
  MarkdownStyleSheet _markdownStyleSheet(
    ThemeData theme, {
    bool withBlockquote = false,
  }) {
    final base = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      strong: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      em: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontStyle: FontStyle.italic,
      ),
      code: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primaryContainer.withValues(
          alpha: 0.4,
        ),
        fontFamily: 'monospace',
      ),
    );
    if (!withBlockquote) return base;
    return base.copyWith(
      blockquoteDecoration: BoxDecoration(
        border: BorderDirectional(
          start: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, ThemeData theme, String response) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: AppSizes.iconSm,
            color: theme.colorScheme.onErrorContainer,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Builder(
              builder: (context) {
                final errorText = _getErrorKey(response).tr(context);
                return Directionality(
                  textDirection: _detectDirection(errorText),
                  child: Text(
                    errorText,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationResult(
    BuildContext context,
    ThemeData theme,
    String response,
  ) {
    // Remove 'label:' prefix
    String content = response.replaceFirst('label:', '').trim();

    // Check if AI response is appended (separator: ---)
    final hasRagResponse = content.contains('\n\n---\n\n');
    String classificationPart = content;
    String? ragPart;

    if (hasRagResponse) {
      final parts = content.split('\n\n---\n\n');
      classificationPart = parts[0];
      ragPart = parts.length > 1 ? parts[1] : null;
    }

    // Parse classification (label and confidence)
    final match = RegExp(
      r'^(.*?)\s*\((\d+\.\d+)%\)$',
    ).firstMatch(classificationPart);
    final labelText = match?.group(1) ?? classificationPart;
    final confidenceText = match?.group(2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Classification Card (always visible) ──────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_florist_rounded,
                size: AppSizes.iconSm,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  labelText,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // ── Confidence Bar ───────────────────────────────────────────
          if (confidenceText != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    child: LinearProgressIndicator(
                      value: double.parse(confidenceText) / 100,
                      backgroundColor: theme.colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
                      color: theme.colorScheme.primary,
                      minHeight: 4.h,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '$confidenceText%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          // ── AI Response or error (if available) ───────────────────────
          if (ragPart != null && ragPart.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
            SizedBox(height: 8.h),
            if (_isErrorKey(ragPart))
              _buildError(context, theme, ragPart)
            else
              Directionality(
                textDirection: _detectDirection(ragPart),
                child: MarkdownBody(
                  data: ragPart,
                  selectable: true,
                  builders: {'table': _ScrollableTableBuilder(theme: theme)},
                  styleSheet: _markdownStyleSheet(theme),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildResponse(
    BuildContext context,
    ThemeData theme,
    String response,
  ) {
    final direction = _detectDirection(response);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(14.w, 10.h, 14.w, 4.h),
          child: Directionality(
            textDirection: direction,
            child: MarkdownBody(
              data: response,
              selectable: true,
              builders: {'table': _ScrollableTableBuilder(theme: theme)},
              styleSheet: _markdownStyleSheet(theme, withBlockquote: true),
            ),
          ),
        ),
        if (response.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 6.w, 4.h),
            child: InkWell(
              onTap: () => _copyToClipboard(context, response),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  Icons.copy_rounded,
                  size: AppSizes.iconSm.r,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Table builder wired into MarkdownBody ───────────────────────────────────

/// Intercepts markdown `<table>` nodes and delegates to [_MarkdownTableWidget].
class _ScrollableTableBuilder extends MarkdownElementBuilder {
  _ScrollableTableBuilder({required this.theme});
  final ThemeData theme;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final parsed = _parseTable(element);
    if (parsed == null) return const SizedBox.shrink();
    return _MarkdownTableWidget(parsed: parsed, theme: theme);
  }

  _ParsedTable? _parseTable(md.Element table) {
    final List<String> headers = [];
    final List<List<String>> rows = [];
    for (final section in table.children ?? []) {
      if (section is! md.Element) continue;
      final isHead = section.tag == 'thead';
      for (final row in section.children ?? []) {
        if (row is! md.Element) continue;
        final cells = (row.children ?? [])
            .whereType<md.Element>()
            .map(_innerText)
            .toList();
        if (isHead) {
          headers.addAll(cells);
        } else {
          rows.add(cells);
        }
      }
    }
    if (headers.isEmpty) return null;
    return _ParsedTable(headers: headers, rows: rows);
  }

  String _innerText(md.Node node) {
    if (node is md.Text) return node.text;
    if (node is md.Element) return (node.children ?? []).map(_innerText).join();
    return '';
  }
}

// ── Data ────────────────────────────────────────────────────────────────────

class _ParsedTable {
  const _ParsedTable({required this.headers, required this.rows});
  final List<String> headers;
  final List<List<String>> rows;
}

// ── Widget ──────────────────────────────────────────────────────────────────

/// Renders a markdown table as a native Flutter [Table].
///
/// The bubble is always at max width (screen − margins). Columns fill it
/// evenly via [FlexColumnWidth]. If the table's estimated natural width
/// exceeds the available space (many columns), falls back to
/// [IntrinsicColumnWidth] + horizontal [SingleChildScrollView].
class _MarkdownTableWidget extends StatelessWidget {
  const _MarkdownTableWidget({required this.parsed, required this.theme});

  final _ParsedTable parsed;
  final ThemeData theme;

  // ── Shared style helpers ─────────────────────────────────────────────────

  TextStyle get _headerStyle =>
      (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      );

  TextStyle get _bodyStyle => (theme.textTheme.bodySmall ?? const TextStyle())
      .copyWith(color: theme.colorScheme.onSurface, height: 1.4);

  Color get _headerBg => theme.colorScheme.primary.withValues(alpha: 0.10);
  Color get _evenBg => theme.colorScheme.surface;
  Color get _oddBg => theme.colorScheme.surfaceContainerLow;
  Color get _borderColor => theme.colorScheme.outline.withValues(alpha: 0.40);

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colCount = parsed.headers.length;
    // Bubble is always at max width. Use FlexColumnWidth so columns share
    // space evenly. If content truly overflows (very many columns), the
    // SingleChildScrollView in _buildScrollableTable handles it.
    // We use a simple heuristic: if estimated natural width fits, fill;
    // otherwise scroll.
    final naturalWidth = _estimateNaturalWidth();
    // Actual space the table has = screen − outer margins (32.w) − bubble
    // internal horizontal padding (14.w each side = 28.w from _buildResponse
    // and _buildClassificationResult, both use the same 14.w padding).
    final availableWidth = 1.0.sw - 32.w - 28.w;
    return naturalWidth <= availableWidth
        ? _buildFillTable(colCount)
        : _buildScrollableTable(colCount);
  }

  double _estimateNaturalWidth() {
    const charPx = 7.5;
    const cellPadding = 24.0;
    double total = 0;
    for (var col = 0; col < parsed.headers.length; col++) {
      double colMax = parsed.headers[col].length * charPx + cellPadding;
      for (final row in parsed.rows) {
        if (col < row.length) {
          final w = row[col].length * charPx + cellPadding;
          if (w > colMax) colMax = w;
        }
      }
      total += colMax;
    }
    return total + parsed.headers.length + 1; // +1 px per column border line
  }

  // ── Table that fills available width (FlexColumnWidth) ───────────────────

  Widget _buildFillTable(int colCount) {
    return _TableShell(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        // All columns share space equally — clean, balanced look.
        columnWidths: {
          for (var i = 0; i < colCount; i++) i: const FlexColumnWidth(),
        },
        border: _innerBorder,
        children: _tableRows(colCount),
      ),
    );
  }

  // ── Table that needs horizontal scroll (IntrinsicColumnWidth) ────────────

  Widget _buildScrollableTable(int colCount) {
    return _TableShell(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        // IntrinsicWidth removed: it caused expensive multi-pass layout
        // calculations and unstable scroll-extent values on first render,
        // contributing to the downward scroll shift on chat open.
        // IntrinsicColumnWidth already sizes each column to its content;
        // the horizontal SingleChildScrollView handles overflow without
        // needing an extra IntrinsicWidth wrapper.
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            for (var i = 0; i < colCount; i++) i: const IntrinsicColumnWidth(),
          },
          border: _innerBorder,
          children: _tableRows(colCount),
        ),
      ),
    );
  }

  // ── Shared row builder ───────────────────────────────────────────────────

  TableBorder get _innerBorder => TableBorder(
    top: BorderSide(color: _borderColor),
    bottom: BorderSide(color: _borderColor),
    left: BorderSide(color: _borderColor),
    right: BorderSide(color: _borderColor),
    horizontalInside: BorderSide(color: _borderColor),
    verticalInside: BorderSide(color: _borderColor),
    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
  );

  List<TableRow> _tableRows(int colCount) => [
    _headerRow(colCount),
    ...parsed.rows.asMap().entries.map(
      (e) => _bodyRow(e.value, colCount, e.key.isEven),
    ),
  ];

  TableRow _headerRow(int colCount) => TableRow(
    // Note: Border on TableRow.decoration is ignored by Flutter's Table
    // widget — only color/image/gradient are painted. The header bottom
    // border is handled by TableBorder.horizontalInside instead.
    decoration: BoxDecoration(color: _headerBg),
    children: List.generate(colCount, (i) {
      final text = i < parsed.headers.length ? parsed.headers[i] : '';
      return _Cell(text: text, style: _headerStyle, isHeader: true);
    }),
  );

  TableRow _bodyRow(List<String> cells, int colCount, bool isEven) => TableRow(
    decoration: BoxDecoration(color: isEven ? _evenBg : _oddBg),
    children: List.generate(colCount, (i) {
      final text = i < cells.length ? cells[i] : '';
      return _Cell(text: text, style: _bodyStyle);
    }),
  );
}

// ── Shared cell ─────────────────────────────────────────────────────────────

class _Cell extends StatelessWidget {
  const _Cell({required this.text, required this.style, this.isHeader = false});

  final String text;
  final TextStyle style;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd.w,
        vertical: AppSizes.spaceMd.h,
      ),
      child: Text(
        text,
        style: style,
        textAlign: isHeader ? TextAlign.center : TextAlign.start,
        softWrap: true,
      ),
    );
  }
}

// ── Rounded border shell ─────────────────────────────────────────────────────

/// Clips the Table into a rounded rectangle and draws an outer border.
/// Extracted so both fill and scrollable variants share identical chrome.
class _TableShell extends StatelessWidget {
  const _TableShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Vertical breathing room between table and surrounding text.
    // The outer border comes from TableBorder (top/bottom/left/right), which
    // Flutter paints inside the table's own bounds — so ClipRRect correctly
    // clips the rounded corners without cutting off the border.
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spaceXs.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: child,
      ),
    );
  }
}
