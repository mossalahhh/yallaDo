# YallaDo — Front-End (Flutter)

The Flutter mobile/web app for **YallaDo**, a family task-and-reward platform.
Parents create tasks and rewards for their children; children claim/submit
tasks, earn points, redeem rewards, unlock avatars, and chat with an AI helper.

It talks to the YallaDo backend (in [`../Back-End`](../Back-End)) — live at
`https://yalla-do.vercel.app`.

## Tech stack

- **Flutter / Dart** (SDK ^3.9)
- **flutter_bloc** (Cubit) for state management
- **dio** for networking, **shared_preferences** for the auth token
- **image_picker** for avatar / task-photo uploads

## Getting started

```bash
flutter pub get
flutter run            # device/emulator
flutter run -d chrome  # web
```

## Project structure

Feature-first under `lib/`:

```
lib/
├─ core/
│  ├─ network/   api_helper · api_response · end_points · token_storage
│  │             · upload_helper · app_prefs
│  ├─ helper/    app_popup · app_validator · jwt_helper
│  └─ widgets/   app_network_image · shared widgets
└─ features/
   ├─ auth/          register · login · verify-email · forget/reset password
   ├─ user/          profile · update name/avatar · change email/password
   ├─ parents/       children · invite code · adjust points · history · analytics
   ├─ child/         link account · avatars · leaderboard
   ├─ tasks/         create · list · claim · submit · approve/reject · update/delete
   ├─ rewards/       add/update/delete · (de)activate · redeem
   ├─ notifications/ list · read · delete
   ├─ ai/            AI chat
   └─ splash/        onboarding
```

Each feature follows the same layering: **`data/`** (service + models) →
**`cubit/`** (state) → **`views/`** (UI).

## Backend integration

All networking goes through `core/network/`:

- **Base URL** and endpoints live in `end_points.dart`.
- Auth uses a **custom header**: `Authorization: yallaDo_grad_<JWT>` (not
  `Bearer`). The token is stored in `shared_preferences` and attached by
  `ApiHelper` for protected requests.
- Responses are normalized through `ApiResponse` (`{ success, message, ... }`).
- Image uploads (avatar, `taskImg`, `submitImgs`, `rewardImg`) are sent as
  multipart **bytes** so they work on web *and* mobile.

## Notes

- Network images use `AppNetworkImage` / `AppAvatar` with fallbacks so a failed
  image (e.g. CORS on web) doesn't crash the page.
- After login the app auto-routes to the parent or child home based on the JWT
  role; the role itself is chosen at **sign-up**, not login.
