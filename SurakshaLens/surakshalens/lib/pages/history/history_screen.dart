import 'package:flutter/material.dart';

import '../../services/history_service.dart';
import '../result/result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await HistoryService.getAll();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Color _colorFor(String level) {
    if (level == 'HIGH CONCERN') return Colors.red.shade300;
    if (level == 'UNKNOWN') return Colors.grey.shade400;
    return Colors.orange.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear history',
            onPressed: () async {
              await HistoryService.clear();
              _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text('No scans yet.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final result = Map<String, dynamic>.from(
                      item['result'] as Map,
                    );
                    final data =
                        result['data'] as Map<String, dynamic>;
                    final level =
                        data['riskLevel']?.toString() ?? 'UNKNOWN';
                    final input =
                        data['input']?.toString() ?? '';
                    final date = DateTime.tryParse(
                          item['date']?.toString() ?? '',
                        ) ??
                        DateTime.now();

                    return Card(
                      color: const Color(0xFF22242A),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Icon(
                          Icons.shield_outlined,
                          color: _colorFor(level),
                        ),
                        title: Text(
                          level,
                          style: TextStyle(
                            color: _colorFor(level),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          input.length > 60
                              ? '${input.substring(0, 60)}...'
                              : input,
                          maxLines: 1,
                        ),
                        trailing: Text(
                          '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ResultScreen(result: result),
                            ),
                          ).then((_) => _load());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
