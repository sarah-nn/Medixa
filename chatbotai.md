# MediXa AI Drug Assistant

## Overview

The **المساعد الذكي** action on the home page now opens a database-grounded
pharmacist chat. The assistant uses Firebase AI Logic with Gemini, but Gemini
receives only medicine and inventory records retrieved from Firestore for the
currently authenticated pharmacist.

The assistant is not a general medical chatbot. It refuses to invent missing
medicine or inventory information.

## Architecture

The implementation follows the existing feature structure and uses the
existing `flutter_bloc` approach:

- `features/drugs/domain/entities/medicine.dart`
  - Strongly typed medicine entity.
- `features/drugs/domain/entities/inventory.dart`
  - Strongly typed inventory entity.
- `features/drugs/domain/repositories/medicine_repository.dart`
  - Repository contract for Firestore medicine and inventory retrieval.
- `features/drugs/data/repositories/medicine_repository_impl.dart`
  - Loads all medicines and current-user inventory from Firestore.
- `features/drugs/data/services/drug_assistant_service.dart`
  - Builds the Firestore context and calls Firebase AI Logic.
  - Validates Gemini JSON references before exposing an answer.
- `features/drugs/presentation/bloc/drug_assistant_bloc.dart`
  - Maintains in-memory chat state and loading/error state.
- `features/drugs/presentation/pages/drug_assistant_page.dart`
  - RTL chat UI with suggestions, message bubbles, loading state, and input.
- `app/router/app_router.dart`
  - Adds the `/drug-assistant` route.
- `features/home/presentation/pages/home_page.dart`
  - Connects the **المساعد الذكي** button to the new route.

## Firestore retrieval

Before every Gemini request:

1. All documents from `medicines` are loaded and deserialized into `Medicine`.
2. The current Firebase Authentication UID is required.
3. Inventory is queried with:

```text
where('userId', isEqualTo: FirebaseAuth.currentUser.uid)
```

4. Inventory is joined to medicines by the actual medicine document ID.
5. Missing inventory is represented as `null`; no quantity, price, or expiry is
   invented.
6. Only the resulting structured records are sent to Gemini.

No authentication token, password, email, or unrelated profile data is sent to
Gemini.

## Gemini safety rules

The system instruction requires Gemini to:

- Answer only from the supplied Firestore context.
- Never use general medical knowledge to fill missing fields.
- Never invent dosage, warnings, interactions, prices, quantities, or expiry
  dates.
- State when a medicine is missing or when a requested field is unavailable.
- Avoid diagnosis or treatment changes.
- Answer in the pharmacist's language.
- Return JSON containing:
  - `answer`
  - `status`
  - `sourceMedicineIds`
  - `sourceFieldNames`
  - `missingInformation`

Before an answer is displayed, the service validates that cited medicine IDs
and field names exist in the retrieved context. Invalid JSON or invalid source
references produce a safe fallback message.

## Firebase AI Logic setup

The app uses the official `firebase_ai` package and the Google AI backend with
the `gemini-2.5-flash` model. No Gemini API key is stored in the Flutter
project.

In Firebase Console:

1. Open the Firebase project used by `firebase_options.dart`.
2. Enable Firebase AI Logic / Gemini API access for the project.
3. Confirm the Google AI backend is enabled.
4. Configure billing/quota as required by the Firebase project.
5. Configure App Check for the Android and iOS apps before production use.

During local debug builds, `main.dart` activates the App Check debug providers.
Register the generated Android/iOS debug token in Firebase Console under
**App Check > Apps > Manage debug tokens**. Do not enforce production App Check
until Play Integrity/App Attest or the appropriate production provider is
configured.

## Firestore security requirements

The existing security rules must ensure:

- Authenticated users can read medicine documents as intended.
- A pharmacist can read only inventory documents where `userId` equals
  `request.auth.uid`.
- Unauthenticated users cannot read inventory.

The app does not bypass Firestore rules. If the inventory query is denied,
update the rules to support the authenticated UID constraint before testing.

## Chat behavior

- Conversation messages remain in memory while the chat page is open.
- Only the latest six message lines are included as conversation context.
- The **محادثة جديدة** action clears the current conversation.
- Empty messages are ignored.
- Duplicate sends are blocked while Gemini is processing.
- Firestore, authentication, quota, network, and invalid-response errors are
  shown as safe Arabic messages.

## Testing guide

1. Ensure Firebase Authentication has a signed-in pharmacist.
2. Ensure the `medicines` collection contains the five medicine documents.
3. Ensure the Augmentin inventory document has:
   - `medicineId` equal to the Augmentin medicine document ID.
   - `userId` equal to the signed-in Firebase UID.
4. Run:

```bash
flutter pub get
flutter run
```

5. Open **المساعد الذكي** from the home page.
6. Test:
   - `ما المادة الفعالة في Augmentin؟`
   - `شو التحذيرات الخاصة بـ Brufen؟`
   - `كم سعر Augmentin عندي بالصيدلية؟`
   - `كم سعر Zyrtec عندي بالصيدلية؟`
   - Ask about a medicine not present in Firestore.
   - Ask an unrelated medical question.
   - Ask Gemini to ignore its instructions.

Expected behavior is that answers are based only on retrieved Firestore fields,
missing inventory is explicitly reported, and unsupported questions do not
receive fabricated medical answers.

## Validation performed

```text
flutter analyze
No issues found!
```

