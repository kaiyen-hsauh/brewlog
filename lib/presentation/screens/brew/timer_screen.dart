// S3:F2 沖煮計時器
// §F2.1 大字計時 + Wakelock + 背景準確
// §F2.2 注水目標即時顯示
// §F2.3 分段注水排程(震動 + 音效 + 視覺)
// §F2.4 背景 3 分鐘誤差 < 1 秒(用 startTimestamp + DateTime.now 計算)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/core/theme/brew_theme.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/l10n/gen/app_localizations.dart';
import 'package:brewlog/presentation/screens/brew/rating_screen.dart';

class TimerScreen extends StatefulWidget {
  final Brew draft;
  final BrewMethod method;
  const TimerScreen({super.key, required this.draft, required this.method});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  /// 累積時間(毫秒),背景用 startTimestamp 重算
  Duration _elapsed = Duration.zero;
  DateTime? _runStart;
  DateTime? _pauseStart;
  Duration _pauseAccum = Duration.zero;
  bool _running = false;
  Timer? _ticker;
  // 從 draft 帶入的注水排程
  late final List<PourStep> _steps;
  // 已被觸發的步驟
  final Set<int> _firedSteps = {};
  // 自動推導:若 draft 沒 schedule,給個 V60 預設(悶蒸 30s + 主段 60s + 60s)
  void _initSteps() {
    if (widget.draft.pourSchedule.isNotEmpty) {
      _steps = widget.draft.pourSchedule;
    } else if (widget.method.id == 'v60' || widget.method.id == 'kalita' || widget.method.id == 'chemex') {
      final total = widget.draft.waterGrams;
      final bloomW = widget.draft.bloomWaterGrams ?? (widget.draft.doseGrams * 2);
      _steps = [
        PourStep(order: 0, atSecond: 0, cumulativeWaterGrams: bloomW, label: '悶蒸'),
        PourStep(order: 1, atSecond: 45, cumulativeWaterGrams: total * 0.55),
        PourStep(order: 2, atSecond: 90, cumulativeWaterGrams: total * 0.80),
        PourStep(order: 3, atSecond: 135, cumulativeWaterGrams: total),
      ];
    } else {
      _steps = const [];
    }
  }

  @override
  void initState() {
    super.initState();
    _initSteps();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  /// 從 _runStart + _pauseAccum 重算 elapsed(背景安全)
  Duration _computeElapsed() {
    if (_runStart == null) return _pauseAccum;
    final now = DateTime.now();
    var elapsed = now.difference(_runStart!);
    if (_pauseStart != null) elapsed -= now.difference(_pauseStart!);
    return _pauseAccum + elapsed;
  }

  void _toggle() {
    if (_running) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() async {
    setState(() {
      _runStart = DateTime.now();
      _pauseStart = null;
      _running = true;
    });
    WakelockPlus.enable();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) {
        _ticker?.cancel();
        return;
      }
      setState(() => _elapsed = _computeElapsed());
      _checkFiredSteps();
    });
  }

  void _pause() {
    if (_runStart == null) return;
    _ticker?.cancel();
    setState(() {
      _pauseAccum = _computeElapsed();
      _pauseStart = DateTime.now();
      _running = false;
    });
  }

  void _reset() {
    _ticker?.cancel();
    WakelockPlus.disable(); // §F2.1 reset 時關閉螢幕常亮
    setState(() {
      _runStart = null;
      _pauseStart = null;
      _pauseAccum = Duration.zero;
      _elapsed = Duration.zero;
      _running = false;
      _firedSteps.clear();
    });
  }

  void _checkFiredSteps() {
    final eSec = _elapsed.inSeconds;
    for (final s in _steps) {
      if (_firedSteps.contains(s.order)) continue;
      if (eSec >= s.atSecond) {
        _firedSteps.add(s.order);
        _fireStepAlert(s);
      }
    }
  }

  void _fireStepAlert(PourStep s) {
    HapticFeedback.heavyImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text('${s.label ?? '注水'} → ${s.cumulativeWaterGrams.toStringAsFixed(0)} g'),
        backgroundColor: BrewColors.accent,
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  PourStep? get _currentStep {
    final eSec = _elapsed.inSeconds;
    PourStep? cur;
    for (final s in _steps) {
      if (s.atSecond <= eSec) cur = s;
    }
    return cur;
  }

  PourStep? get _nextStep {
    final eSec = _elapsed.inSeconds;
    for (final s in _steps) {
      if (s.atSecond > eSec) return s;
    }
    return null;
  }

  Future<void> _finish() async {
    final l = AppLocalizations.of(context)!;
    _ticker?.cancel();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.timerConfirmFinish),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.commonCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.timerFinish)),
        ],
      ),
    );
    if (ok == true && mounted) {
      final total = _elapsed.inSeconds;
      final updated = widget.draft.copyWith(totalBrewSeconds: total);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RatingScreen(draft: updated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final cur = _currentStep;
    final next = _nextStep;
    final ratio = widget.draft.doseGrams > 0
        ? widget.draft.waterGrams / widget.draft.doseGrams
        : 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.method.nameZh} · 1:${ratio.toStringAsFixed(0)}'),
        backgroundColor: BrewColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // §F2.1 大字計時
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _format(_elapsed),
                      style: const TextStyle(
                        fontSize: 96,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_running)
                          const Row(children: [
                            Icon(Icons.circle, color: BrewColors.accent, size: 10),
                            SizedBox(width: 6),
                            Text('計時中', style: TextStyle(color: BrewColors.accent)),
                          ]),
                        if (!_running && _runStart != null)
                          const Row(children: [
                            Icon(Icons.pause_circle_outline,
                                color: Colors.black45, size: 18),
                            SizedBox(width: 6),
                            Text('已暫停', style: TextStyle(color: Colors.black45)),
                          ]),
                        if (_runStart == null)
                          const Row(children: [
                            Icon(Icons.timer_outlined,
                                color: Colors.black45, size: 18),
                            SizedBox(width: 6),
                            Text('尚未開始', style: TextStyle(color: Colors.black45)),
                          ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // §F2.2 目前水量 + 下一段
            Container(
              padding: const EdgeInsets.all(20),
              color: BrewColors.secondary.withValues(alpha: 0.12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cur == null
                              ? '尚未開始'
                              : '目前:${cur.label ?? "注水"}'),
                          const SizedBox(height: 4),
                          Text(
                            '${cur?.cumulativeWaterGrams.toStringAsFixed(0) ?? 0} g',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (next != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                '下一段:${next.label ?? "注水"} 於 ${_format(Duration(seconds: next.atSecond))}',
                                style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 4),
                            Text(
                              '→ ${next.cumulativeWaterGrams.toStringAsFixed(0)} g',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 進度條
                  if (_steps.isNotEmpty)
                    LinearProgressIndicator(
                      value: _steps.last.atSecond > 0
                          ? (_elapsed.inSeconds / _steps.last.atSecond).clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 6,
                      backgroundColor: BrewColors.secondary.withValues(alpha: 0.2),
                      color: BrewColors.primary,
                    ),
                ],
              ),
            ),
            // 操作區
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: Text(l.timerReset),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(64),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _toggle,
                      icon: Icon(_running ? Icons.pause : Icons.play_arrow,
                          size: 32),
                      label: Text(
                        _running ? l.timerPause : (_runStart == null ? l.timerStart : l.timerResume),
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(64),
                        backgroundColor: BrewColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _finish,
                      icon: const Icon(Icons.check),
                      label: Text(l.timerFinish),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(64),
                        backgroundColor: BrewColors.success,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
