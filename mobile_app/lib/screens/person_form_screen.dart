import 'package:flutter/material.dart';

import '../models/person.dart';
import '../services/api_service.dart';

class PersonFormScreen extends StatefulWidget {
  final Person? person;
  const PersonFormScreen({super.key, this.person});

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late final TextEditingController _name;
  late final TextEditingController _dept;
  late final TextEditingController _photo;
  late final TextEditingController _birthPlace;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  DateTime? _birthDate;
  bool _loading = false;

  bool get _isEdit => widget.person != null;

  @override
  void initState() {
    super.initState();
    final p = widget.person;
    _name = TextEditingController(text: p?.fullName ?? '');
    _dept = TextEditingController(text: p?.department ?? '');
    _photo = TextEditingController(text: p?.photoUrl ?? '');
    _birthPlace = TextEditingController(text: p?.birthPlace ?? '');
    _email = TextEditingController(text: p?.email ?? '');
    _phone = TextEditingController(text: p?.phone ?? '');
    _birthDate = p?.birthDate;
  }

  @override
  void dispose() {
    _name.dispose();
    _dept.dispose();
    _photo.dispose();
    _birthPlace.dispose();
    _email.dispose();
    _phone.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Doğum tarihini seçin',
    );
    if (d != null) setState(() => _birthDate = d);
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      _snack('Lütfen doğum tarihini seçin.', isError: true);
      return;
    }

    setState(() => _loading = true);

    final person = Person(
      id: widget.person?.id,
      fullName: _name.text.trim(),
      department: _dept.text.trim(),
      photoUrl: _photo.text.trim(),
      birthPlace: _birthPlace.text.trim(),
      birthDate: _birthDate!,
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );

    try {
      if (_isEdit) {
        await _api.updatePerson(person);
      } else {
        await _api.createPerson(person);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _snack('Hata: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    final cs = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? cs.error : cs.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(
          _isEdit ? 'Kişiyi Düzenle' : 'Yeni Kişi',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Fotoğraf URL önizleme
              if (_photo.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: cs.primaryContainer,
                    child: ClipOval(
                      child: Image.network(
                        _photo.text,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_rounded,
                          size: 44,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),

              _field(
                ctrl: _name,
                label: 'Ad Soyad',
                icon: Icons.person_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
              ),
              _field(
                ctrl: _dept,
                label: 'Departman',
                icon: Icons.business_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
              ),
              _field(
                ctrl: _photo,
                label: 'Fotoğraf URL',
                icon: Icons.image_rounded,
                keyboard: TextInputType.url,
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  final uri = Uri.tryParse(value);
                  if (value.isEmpty) return 'Fotoğraf URL zorunlu';
                  if (uri == null ||
                      !uri.hasAuthority ||
                      uri.host.isEmpty ||
                      !const {'http', 'https'}.contains(uri.scheme)) {
                    return 'http veya https ile başlayan geçerli bir URL girin';
                  }
                  return null;
                },
              ),
              _field(
                ctrl: _birthPlace,
                label: 'Doğum Yeri',
                icon: Icons.place_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Zorunlu alan' : null,
              ),

              // Doğum Tarihi
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: _birthDate != null ? _fmtDate(_birthDate!) : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Doğum Tarihi',
                      prefixIcon: Icon(Icons.cake_rounded, color: cs.primary),
                      suffixIcon: Icon(
                        Icons.calendar_today_rounded,
                        color: cs.primary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (_) =>
                        _birthDate == null ? 'Tarih seçiniz' : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _field(
                ctrl: _email,
                label: 'E-posta',
                icon: Icons.email_rounded,
                keyboard: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Zorunlu alan';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                      .hasMatch(v.trim())) {
                    return 'Geçerli bir e-posta girin';
                  }
                  return null;
                },
              ),
              _field(
                ctrl: _phone,
                label: 'Telefon',
                icon: Icons.phone_rounded,
                keyboard: TextInputType.phone,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Zorunlu alan';
                  if (value.length > 20) return 'En fazla 20 karakter girin';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _isEdit ? 'GÜNCELLE' : 'KAYDET',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: cs.primary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
