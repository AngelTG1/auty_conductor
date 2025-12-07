import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage_service.dart';

Future<bool> showTermsModal(BuildContext context) async {
  bool accepted = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: (context) {
      bool loading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final safeBottom = MediaQuery.of(context).viewPadding.bottom;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Text(
                      'He leído y acepto los Términos y Condiciones\n'
                      'y el Aviso de Privacidad.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Términos y Condiciones y Aviso de Privacidad',
                        style: TextStyle(
                          color: Color(0xFF1E329D),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: safeBottom - 25),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    setState(() => loading = true);
                                    await SecureStorageService.write(
                                      'acceptedTerms',
                                      'true',
                                    );
                                    accepted = true;
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E329D),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Aceptar y continuar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  return accepted;
}
