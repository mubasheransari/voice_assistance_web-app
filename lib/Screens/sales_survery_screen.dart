import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voice_assistant_project/Data/product_data.dart';
import 'package:voice_assistant_project/Screens/login_screen.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


var storage = GetStorage();


class ProductSelection {
  final Map<String, dynamic> product;
  int quantity;

  ProductSelection({
    required this.product,
    this.quantity = 1,
  });
}



class SurveyScreenView extends StatefulWidget {
  const SurveyScreenView({super.key});

  @override
  State<SurveyScreenView> createState() => _SurveyScreenViewState();
}

class _SurveyScreenViewState extends State<SurveyScreenView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();

  bool _submitting = false;

  String? _selectedProductName;
  final List<ProductSelection> _selectedProducts = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cnicCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  // ---------- validators ----------

  String? _validateRequired(String? v, String field) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '$field is required';
    return null;
  }

  String? _validatePhone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Phone number is required';
    if (s.length < 8) return 'Enter a valid phone number';
    return null;
  }

  String? _validateCnic(String? v) {
    final s = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (s.isEmpty) return 'CNIC number is required';
    if (s.length != 13) return 'Enter 13-digit CNIC number';
    return null;
  }

  Future<void> _submitSurvey() async {
    final form = _formKey.currentState;
    if (form == null) return;

    FocusScope.of(context).unfocus();
    if (!form.validate()) return;

    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one product.')),
      );
      return;
    }

    setState(() => _submitting = true);

    // TODO: send to API with _selectedProducts data
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _submitting = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Survey submitted successfully!')),
    );

    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _phoneCtrl.clear();
    _cnicCtrl.clear();
    _addressCtrl.clear();
    _cityCtrl.clear();
    _commentCtrl.clear();

    setState(() {
      _selectedProductName = null;
      _selectedProducts.clear();
    });
  }

  void _onProductPicked(Map<String, dynamic> product) {
    final id = product['id'].toString();
    final name = (product['item_name'] ?? '').toString();

    setState(() {
      _selectedProductName = name;

      final idx = _selectedProducts.indexWhere(
        (p) => p.product['id'].toString() == id,
      );

      if (idx >= 0) {
        _selectedProducts[idx].quantity++;
      } else {
        _selectedProducts.add(ProductSelection(product: product, quantity: 1));
      }
    });
  }

  void _incrementQty(int index) {
    setState(() {
      _selectedProducts[index].quantity++;
    });
  }

  void _decrementQty(int index) {
    setState(() {
      if (_selectedProducts[index].quantity > 1) {
        _selectedProducts[index].quantity--;
      } else {
        _selectedProducts.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Daily Sales Survey',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,//AppTheme.primary,
          ),
        ),
        actions: [
            IconButton(onPressed: ()async{

              final shouldLogout = await showLogoutDialog(context);
if (shouldLogout == true) {
  storage.remove("supervisor");
 Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );

}
            }, icon: Icon(Icons.logout))
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fill today’s sales details',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    color: Color(0xFF75748A),
                  ),
                ),
                const SizedBox(height: 18),

                _InputCard(
                  hint: 'Name',
                  icon: Icons.person_outline_rounded,
                  controller: _nameCtrl,
                  validator: (v) => _validateRequired(v, 'Name'),
                ),
                const SizedBox(height: 12),

                _InputCard(
                  hint: 'Phone Number',
                  icon: Icons.phone_rounded,
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 12),

                _InputCard(
                  hint: 'CNIC Number (13 digits)',
                  icon: Icons.badge_outlined,
                  controller: _cnicCtrl,
                  keyboardType: TextInputType.number,
                  validator: _validateCnic,
                ),
                const SizedBox(height: 12),

                _InputCard(
                  hint: 'Address',
                  icon: Icons.home_outlined,
                  controller: _addressCtrl,
                  validator: (v) => _validateRequired(v, 'Address'),
                ),
                const SizedBox(height: 12),

                _InputCard(
                  hint: 'City',
                  icon: Icons.location_city_outlined,
                  controller: _cityCtrl,
                  validator: (v) => _validateRequired(v, 'City'),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Products sold',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search by item name, filter by brand, select product and adjust quantities below.',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12.5,
                    color: Color(0xFF75748A),
                  ),
                ),
                const SizedBox(height: 12),

                _SearchableProductDropdownCard(
                  label: 'Product (item name)',
                  icon: Icons.local_cafe_outlined,
                  selectedText: _selectedProductName,
                  products: ProductData.kTeaProducts,
                  onProductSelected: _onProductPicked,
                ),

                const SizedBox(height: 14),

                if (_selectedProducts.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected products',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _selectedProducts.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 10,
                            color: Color(0xFFE5E2F5),
                          ),
                          itemBuilder: (context, index) {
                            final sel = _selectedProducts[index];
                            final itemName =
                                (sel.product['item_name'] ?? '').toString();
                            final brand =
                                (sel.product['brand'] ?? '').toString();
                            final gramsMatch = RegExp(r'(\d+(\.\d+)?)GM')
                                .firstMatch(
                                    (sel.product['name'] ?? '')
                                        .toString()
                                        .toUpperCase());
                            final grams =
                                gramsMatch != null ? gramsMatch.group(0)! : '';

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemName,
                                        style: const TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F1235),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        [
                                          if (brand.isNotEmpty) brand,
                                          if (grams.isNotEmpty) grams,
                                        ].join(' • '),
                                        style: const TextStyle(
                                          fontFamily: AppTheme.fontFamily,
                                          fontSize: 11.5,
                                          color: Color(0xFF8A84A4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: const Color(0xFFF5F3FF),
                                    border: Border.all(
                                      color: AppTheme.primary.withOpacity(0.18),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                          color: AppTheme.primary,
                                        ),
                                        onPressed: () => _decrementQty(index),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Text(
                                          sel.quantity.toString(),
                                          style: const TextStyle(
                                            fontFamily: AppTheme.fontFamily,
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3E1E69),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                          color: AppTheme.primary,
                                        ),
                                        onPressed: () => _incrementQty(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 18),

                _MultilineInputCard(
                  hint: 'Comment (3 lines max)',
                  icon: Icons.notes_rounded,
                  controller: _commentCtrl,
                  maxLines: 3,
                  validator: (v) => _validateRequired(v, 'Comment'),
                ),

                const SizedBox(height: 22),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 44,
                    child: _PrimaryGradientButton(
                      text: _submitting ? 'PLEASE WAIT...' : 'SUBMIT',
                      loading: _submitting,
                      onPressed: _submitting ? null : _submitSurvey,
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

// ------------------ UI WIDGETS ------------------

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.hint,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.onToggleObscure,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(.08),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                obscureText: obscureText,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Color(0xFF1F1235),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10),
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: Color(0xFF9A8EB5),
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
            if (onToggleObscure != null)
              IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: const Color(0xFFB1A4CC),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final disabled = loading || onPressed == null;

    return Opacity(
      opacity: disabled ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.20),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        text,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MultilineInputCard extends StatelessWidget {
  const _MultilineInputCard({
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.maxLines = 3,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(.08),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Icon(icon, size: 20, color: AppTheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                maxLines: maxLines,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Color(0xFF1F1235),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isCollapsed: false,
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: Color(0xFF9A8EB5),
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Searchable dropdown styled like your _buildCitySelector (card + pill)
class _SearchableProductDropdownCard extends StatelessWidget {
  const _SearchableProductDropdownCard({
    required this.label,
    required this.icon,
    required this.products,
    required this.onProductSelected,
    this.selectedText,
  });

  final String label;
  final IconData icon;
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic> product) onProductSelected;
  final String? selectedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    color: Color(0xFF75748A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked =
                              await _showProductSearchBottomSheet(context);
                          if (picked != null) {
                            onProductSelected(picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.18),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedText ?? 'Select $label',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontFamily,
                                    fontSize: 13.5,
                                    color: selectedText == null
                                        ? const Color(0xFF9A8EB5)
                                        : const Color(0xFF3E1E69),
                                    fontWeight: selectedText == null
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.search_rounded,
                                size: 20,
                                color: AppTheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<Map<String, dynamic>?> _showProductSearchBottomSheet(
  BuildContext context,
) async {
  // distinct brands list + "All"
  final Set<String> brandSet = {};
  for (final p in products) {
    final b = (p['brand'] ?? '').toString().trim();
    if (b.isNotEmpty) brandSet.add(b);
  }
  final List<String> brands = ['All', ...brandSet.toList()];

  String searchTerm = '';
  String selectedBrand = 'All';

  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // 👈 half of the screen
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // drag handle
                  Container(
                    width: 42,
                    height: 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0D7F9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Select product',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),

                  // search
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: AppTheme.primary,
                        ),
                        hintText: 'Search item name…',
                        hintStyle: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          fontSize: 13.5,
                          color: Color(0xFF9A8EB5),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F5FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide(
                            color: AppTheme.primary.withOpacity(0.15),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                      ),
                      onChanged: (v) {
                        (context as Element).markNeedsBuild();
                        // we’ll handle state with StatefulBuilder below
                      },
                    ),
                  ),

                  // we wrap rest in StatefulBuilder for filtering state
                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        // keep searchTerm & selectedBrand in closure
                        final filtered = products.where((p) {
                          final name = (p['item_name'] ?? '')
                              .toString()
                              .toLowerCase();
                          final brand =
                              (p['brand'] ?? '').toString().trim();
                          if (searchTerm.isNotEmpty &&
                              !name.contains(searchTerm)) {
                            return false;
                          }
                          if (selectedBrand != 'All' &&
                              brand != selectedBrand) {
                            return false;
                          }
                          return true;
                        }).toList();

                        return Column(
                          children: [
                            // brand chips row
                            SizedBox(
                              height: 44,
                              child: ListView.separated(
                                controller: scrollController,
                                // use a separate controller for full sheet scroll?
                                // but for chips it's fine without
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                itemCount: brands.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final brand = brands[index];
                                  final selected =
                                      selectedBrand == brand;
                                  return ChoiceChip(
                                    label: Text(
                                      brand,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 12.5,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                    selected: selected,
                                    selectedColor: AppTheme.primary
                                        .withOpacity(0.12),
                                    showCheckmark: false,
                                    backgroundColor:
                                        const Color(0xFFF7F5FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(999),
                                      side: BorderSide(
                                        color: selected
                                            ? AppTheme.primary
                                            : AppTheme.primary
                                                .withOpacity(0.12),
                                      ),
                                    ),
                                    onSelected: (val) {
                                      if (!val) return;
                                      setModalState(() {
                                        selectedBrand = brand;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 6),

                            // product list
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final p = filtered[index];
                                  final itemName = (p['item_name'] ?? '')
                                      .toString();
                                  final brand =
                                      (p['brand'] ?? '').toString();
                                  return ListTile(
                                    title: Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: brand.isNotEmpty
                                        ? Text(
                                            brand,
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppTheme.fontFamily,
                                              fontSize: 11.5,
                                              color: Color(0xFF8A84A4),
                                            ),
                                          )
                                        : null,
                                    onTap: () =>
                                        Navigator.of(context).pop(p),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}



Future<bool?> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 14),

              // Title
              const Text(
                'Logout from app?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'You will be logged out from your account. '
                'You can log in again anytime.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13,
                  color: Color(0xFF75748A),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              // Buttons
              Row(
                children: [
                  // Cancel
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppTheme.primary.withOpacity(0.18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          backgroundColor: const Color(0xFFF7F8FA),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF75748A),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Logout (gradient)
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.of(ctx).pop(true),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: const LinearGradient(
                              colors: [AppTheme.primary, AppTheme.accent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.20),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
