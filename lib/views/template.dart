import 'package:flutter/material.dart';
import 'package:saverp_app/models/konfigurasiApps.dart';

class FormTemplate extends StatelessWidget {
  final String header1, header2;
  final Widget formInputs;
  final GlobalKey<FormState> formKey;
  final String? buttonText;
  final Function? onSave;
  final Function? onDelete;

  const FormTemplate(
      {required this.header1,
      this.header2 = '',
      required this.formInputs,
      required this.formKey,
      this.buttonText,
      this.onSave,
      this.onDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight,
        ),
        color: AppColors.base200,
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).viewPadding.top + 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(32)),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.base100,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormTitle(
                    header1: header1,
                    header2: header2,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: formInputs,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (buttonText == null) {
                              Navigator.pop(context);
                            } else if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              onDelete!();
                              Navigator.pop(context);
                            }
                          },
                          child: buttonText != null
                              ? FormSubmitButton(
                                  buttonText: 'Hapus',
                                  buttonColor: AppColors.base300)
                              : FormSubmitButton(
                                  buttonText: 'Batal',
                                  buttonColor: AppColors.base300),
                        ),
                      ),
                      Container(
                        width: 24,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              onSave!();
                              Navigator.pop(context);
                            }
                          },
                          child: buttonText != null
                              ? FormSubmitButton(
                                  buttonText: 'Update',
                                  buttonColor: AppColors.primary)
                              : FormSubmitButton(
                                  buttonText: 'Simpan',
                                  buttonColor: AppColors.primary),
                        ),
                      ),
                    ],
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

class FormTitle extends StatelessWidget {
  final String header1;
  final String? header2;

  const FormTitle({required this.header1, this.header2, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: header1,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
          header2 != null
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        text: header2,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14)),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class FormSubmitButton extends StatelessWidget {
  String buttonText;
  Color buttonColor;

  FormSubmitButton({
    required this.buttonText,
    required this.buttonColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      margin: const EdgeInsets.only(top: 64, bottom: 100),
      decoration: BoxDecoration(
          color: buttonColor, borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
              text: buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
