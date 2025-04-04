class IbanValidator {
  static bool validateSaudiIban(String iban) {
    final saudiIbanPattern = RegExp(r'^SA\d{22}$');
    return saudiIbanPattern.hasMatch(iban.trim().toUpperCase());
  }
}