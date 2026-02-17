# Legal Pages Implementation - TODO

## Completed Tasks ✅

- [x] Created Privacy Policy View (`lib/modules/legal/view/privacy_policy_view.dart`)
  - [x] Added comprehensive privacy policy content
  - [x] Included data collection, storage, and security information
  - [x] Added Indian IT Act 2000 compliance section
  - [x] Implemented clean, scrollable UI with proper styling
  - [x] Used theme colors and text styles

- [x] Created Terms & Conditions View (`lib/modules/legal/view/terms_conditions_view.dart`)
  - [x] Added order and payment (COD) terms
  - [x] Included delivery policy
  - [x] Added cancellation policy
  - [x] Included refund/replacement policy
  - [x] Added product quality responsibility
  - [x] Included right to modify terms
  - [x] Implemented clean, scrollable UI with proper styling

- [x] Updated Routes Configuration
  - [x] Added route constants in `lib/res/routes/routes_name.dart`
    - `/privacy-policy`
    - `/terms-conditions`
  - [x] Added route pages in `lib/res/routes/routes.dart`
    - Imported new views
    - Added GetPage entries with proper transitions

- [x] **Linked Legal Pages to Profile Page** ✨
  - [x] Updated `lib/modules/profile/view/profile_view.dart`
  - [x] Connected "Privacy Policy" option to actual Privacy Policy page
  - [x] Connected "Terms & Conditions" option to actual Terms & Conditions page
  - [x] Removed "Coming Soon" dialogs
  - [x] Used proper RoutesName constants for navigation

- [x] **Added Legal Links to Authentication Pages** 🔐
  - [x] Updated `lib/modules/auth/view/register_view.dart`
    - Added "By creating an account, you agree to..." text
    - Clickable links to Terms & Conditions and Privacy Policy
    - Positioned above "Create Account" button
  - [x] Updated `lib/modules/auth/view/login_view.dart`
    - Added footer links to Terms & Conditions and Privacy Policy
    - Positioned at bottom of login form
    - Clean, minimal design with bullet separator

- [x] **Created Help & Support Page** 🆘
  - [x] Created `lib/modules/legal/view/help_support_view.dart`
    - 6 comprehensive support sections
    - Order issues, payment support, cancellation & refund
    - Product issues, technical support
    - Contact information with email, phone, support hours
    - Professional UI with icons and color-coded sections
  - [x] Added route in `lib/res/routes/routes_name.dart`
  - [x] Registered route in `lib/res/routes/routes.dart`
  - [x] Linked from Profile page (replaced "Coming Soon" dialog)

## Implementation Details

### File Structure
```
lib/modules/legal/
├── view/
│   ├── privacy_policy_view.dart
│   └── terms_conditions_view.dart
```

### Routes Added
- Privacy Policy: `/privacy-policy` (RoutesName.privacyPolicy)
- Terms & Conditions: `/terms-conditions` (RoutesName.termsConditions)

### Navigation Usage
```dart
// Navigate to Privacy Policy
Get.toNamed(RoutesName.privacyPolicy);

// Navigate to Terms & Conditions
Get.toNamed(RoutesName.termsConditions);
```

## Testing Checklist

### Completed Tests ✅

- [x] **Unit Tests Created and Passed** (5/5 tests passed)
  - [x] Privacy Policy View renders correctly
  - [x] Terms & Conditions View renders correctly
  - [x] Privacy Policy View has back button
  - [x] Terms & Conditions View has back button
  - [x] Route names are correctly defined

- [x] **Code Analysis** - No errors found
  - [x] Flutter analyze passed with only minor info warnings
  - [x] Legal module files have no critical issues
  - [x] Fixed deprecated `withOpacity` warnings

- [x] **Compilation Test** - App compiles successfully
  - [x] App runs on Chrome web platform
  - [x] No compilation errors
  - [x] Routes are properly registered

### Manual Testing Recommended

- [ ] Test navigation to Privacy Policy page from app UI
- [ ] Test navigation to Terms & Conditions page from app UI
- [ ] Verify scrolling works smoothly on both pages
- [ ] Check text readability on different screen sizes
- [ ] Test on physical Android/iOS devices
- [ ] Verify theme consistency across the app

## Notes

- Both pages follow MVVM architecture (View only, no controller needed)
- No Firebase dependencies added
- Clean, production-ready code with proper formatting
- Uses existing theme colors and text styles
- Follows GetX routing conventions
- All existing routes remain intact
