import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/person.dart';
import '../services/api_service.dart';
import 'person_form_screen.dart';

class PersonDetailScreen extends StatefulWidget {
  final int personId;
  final VoidCallback? onPersonUpdated;

  const PersonDetailScreen({
    super.key,
    required this.personId,
    this.onPersonUpdated,
  });

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final ApiService _api = ApiService();
  late Future<Person> _futurePerson;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadPerson();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  // ASENKRON HATAYI ORTADAN KALDIRAN KISIM
  void _loadPerson() {
    final future = _api.fetchPersonDetail(widget.personId);
    setState(() {
      _futurePerson = future;
    });
  }

  Future<void> _deletePerson() async {
    if (_isDeleting) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kişiyi Sil'),
        content: const Text('Bu kişiyi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      await _api.deletePerson(widget.personId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Silme başarısız: $e')));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _editPerson() async {
    try {
      final personData = await _futurePerson;
      if (!mounted) return;
      final refresh = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => PersonFormScreen(person: personData)),
      );
      if (mounted && refresh == true) {
        _loadPerson();
        widget.onPersonUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kişi bilgileri alınamadı: $e')));
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: const Text('Kişi Detayı'),
        // Actions moved to bottom buttons
      ),
      body: FutureBuilder<Person>(
        future: _futurePerson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: cs.primary));
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Hata: ${snapshot.error}',
                  style: TextStyle(color: cs.error, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Kişi bulunamadı.'));
          }

          final person = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: cs.primaryContainer,
                  backgroundImage: person.photoUrl.isNotEmpty
                      ? NetworkImage(person.photoUrl)
                      : null,
                  child: person.photoUrl.isEmpty
                      ? Text(
                          person.fullName.isNotEmpty
                              ? person.fullName[0].toUpperCase()
                              : '?',
                          style: TextStyle(fontSize: 36, color: cs.primary),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  person.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  person.department,
                  style: TextStyle(fontSize: 16, color: cs.primary),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone_rounded, color: cs.primary),
                          title: const Text('Telefon'),
                          subtitle: Text(
                            person.phone.isNotEmpty
                                ? person.phone
                                : 'Belirtilmemiş',
                          ),
                          onTap: person.phone.isNotEmpty
                              ? () => _makePhoneCall(person.phone)
                              : null,
                          trailing: person.phone.isNotEmpty
                              ? IconButton(
                                  tooltip: 'Ara',
                                  icon: Icon(Icons.call, color: cs.primary),
                                  onPressed: () => _makePhoneCall(person.phone),
                                )
                              : null,
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.email_rounded, color: cs.primary),
                          title: const Text('E-posta'),
                          subtitle: Text(person.email),
                          onTap: () => _sendEmail(person.email),
                          trailing: IconButton(
                            tooltip: 'E-posta gönder',
                            icon: Icon(Icons.send, color: cs.primary),
                            onPressed: () => _sendEmail(person.email),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.place_rounded, color: cs.primary),
                          title: const Text('Doğum Yeri'),
                          subtitle: Text(
                            person.birthPlace.isNotEmpty
                                ? person.birthPlace
                                : 'Belirtilmemiş',
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading: Icon(Icons.cake_rounded, color: cs.primary),
                          title: const Text('Doğum Tarihi'),
                          subtitle: Text(
                            '${person.birthDate.day.toString().padLeft(2, '0')}.${person.birthDate.month.toString().padLeft(2, '0')}.${person.birthDate.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Person>(
        future: _futurePerson,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isDeleting ? null : _editPerson,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('DÜZENLE'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isDeleting ? null : _deletePerson,
                      icon: _isDeleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.delete_outline),
                      label: Text(_isDeleting ? 'SİLİNİYOR' : 'KİŞİYİ SİL'),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.error,
                        foregroundColor: cs.onError,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
