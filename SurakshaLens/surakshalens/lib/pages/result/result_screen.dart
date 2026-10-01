import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../util/strings.dart';
import '../../util/speech.dart';
import '../../services/history_service.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    HistoryService.add(widget.result);
  }

  Future<void> _openUrl(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid source link.'),
        ),
      );
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the source.'),
        ),
      );
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'telegram':
        return Icons.send;
      case 'whatsapp':
        return Icons.chat;
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email_outlined;
      case 'upi':
        return Icons.account_balance_wallet_outlined;
      case 'apk':
        return Icons.android;
      default:
        return Icons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        widget.result['data'] as Map<String, dynamic>;

    final String riskLevelRaw = data['riskLevel'] ?? 'UNKNOWN';

    final int signalCount =
        data['signalCount'] ?? 0;

    final List signals =
        data['signals'] ?? [];

    final String explanation =
        data['explanation'] ?? '';

    final List actions =
        data['recommendedActions'] ?? [];

    final List evidence =
        data['evidence'] ?? [];

    final List claims =
        data['claims'] ?? [];

    final List identifiers =
        data['identifiers'] ?? [];

    final bool isHigh =
        riskLevelRaw == 'HIGH CONCERN';

    final String riskLevel = isHigh
        ? AppStrings.t('highConcern')
        : (riskLevelRaw == 'UNKNOWN'
            ? AppStrings.t('unknown')
            : riskLevelRaw);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.t('analysisResult'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Read result aloud',
            onPressed: () async {
              await TtsHelper.speak('$riskLevel. $explanation');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(22),
                    color: isHigh
                        ? const Color(0xFF3B1F22)
                        : const Color(0xFF3A2A17),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isHigh
                            ? Icons.warning_rounded
                            : Icons.info_rounded,
                        size: 55,
                        color: isHigh
                            ? Colors.red.shade300
                            : Colors.orange.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        riskLevel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: isHigh
                              ? Colors.red.shade200
                              : Colors.orange.shade200,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$signalCount warning signs detected',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  AppStrings.t('warningSigns'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...signals.map(
                  (signal) => _SignalCard(
                    title:
                        signal['title'] ?? '',
                    description:
                        signal['description'] ?? '',
                    severity:
                        signal['severity'] ?? '',
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  AppStrings.t('whyMatters'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  explanation,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                if (claims.isNotEmpty) ...[
                  const Text(
                    'Claims Detected',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...claims.map(
                    (claim) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      color: const Color(0xFF2A2A33),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.shade800,
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.gpp_maybe_outlined,
                          color: Colors.orange,
                        ),
                        title: Text(
                          claim['label'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          claim['description'] ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],

                if (evidence.isNotEmpty) ...[
                  Text(
                    AppStrings.t('evidence'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    AppStrings.t('evidenceSub'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ...evidence.map(
                    (item) => _EvidenceCard(
                      title:
                          item['title'] ?? '',
                      explanation:
                          item['explanation'] ?? '',
                      sourceName:
                          item['sourceName'] ?? '',
                      sourceUrl:
                          item['sourceUrl'] ?? '',
                      onOpen: () {
                        _openUrl(
                          context,
                          item['sourceUrl'] ?? '',
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                if (identifiers.isNotEmpty) ...[
                  Text(
                    AppStrings.t('identifiers'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    AppStrings.t('identifiersSub'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ...identifiers.map(
                    (item) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.shade800,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          _iconForType(item['type'] ?? ''),
                          color: Colors.blue.shade300,
                        ),
                        title: Text(
                          item['label'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['value'] ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),
                            if ((item['riskHint'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4),
                                child: Text(
                                  item['riskHint'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade300,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            if ((item['verdict'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    Icon(
                                      item['verdict'] ==
                                              'suspicious'
                                          ? Icons.warning_amber_rounded
                                          : Icons.help_outline,
                                      size: 14,
                                      color: item['verdict'] ==
                                              'suspicious'
                                          ? Colors.red.shade300
                                          : Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item['verdictNote'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: item['verdict'] ==
                                                  'suspicious'
                                              ? Colors.red.shade300
                                              : Colors.grey.shade400,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        trailing: (item['type'] == 'url' ||
                                item['type'] == 'telegram' ||
                                item['type'] == 'whatsapp' ||
                                item['type'] == 'apk')
                            ? IconButton(
                                icon: const Icon(Icons.open_in_new, size: 20),
                                onPressed: () {
                                  var value = item['value'] ?? '';
                                  if (!value.startsWith('http')) {
                                    value = 'https://$value';
                                  }
                                  _openUrl(context, value);
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '⚠️ Verify these identifiers through official sources before trusting or paying.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade300,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],

                const Text(
                  'What should you do?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...actions.map(
                  (action) => Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            action.toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(16),
                    color: const Color(0xFF26282E),
                  ),
                  child: Text(
                    AppStrings.t('safety'),
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  final String title;
  final String description;
  final String severity;

  const _SignalCard({
    required this.title,
    required this.description,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade800,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              '🚩',
              style: TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: TextStyle(
                      color:
                          Colors.grey.shade400,
                      height: 1.35,
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

class _EvidenceCard extends StatelessWidget {
  final String title;
  final String explanation;
  final String sourceName;
  final String sourceUrl;
  final VoidCallback onOpen;

  const _EvidenceCard({
    required this.title,
    required this.explanation,
    required this.sourceName,
    required this.sourceUrl,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.grey.shade800,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12),
                    color:
                        const Color(0xFF1F2A3D),
                  ),
                  child: Icon(
                    Icons.verified_outlined,
                    color:
                        Colors.blue.shade300,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              explanation,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 18,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    sourceName,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpen,
                icon: const Icon(
                  Icons.open_in_new,
                  size: 18,
                ),
                label: const Text(
                  'Open Official Source',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}