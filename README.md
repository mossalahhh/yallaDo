# YallaDo – Kids Control System

YallaDo is a family task-and-reward app: parents create tasks, kids complete
them to earn points, and points are redeemed for rewards. Task submissions can
be verified automatically by the built-in **Buddy AI** (vision model), and kids
also get a safe **Buddy AI chat**.

Graduation project — Faculty of Computers and Informatics, Zagazig University.

---

## 📱 Download the App (Android)

**[⬇ Download the latest APK](https://github.com/mossalahhh/yallaDo/releases/latest)**

1. On your Android phone, open the link above and download the `.apk` file
   from the **Assets** section.
2. Open the downloaded file. If prompted, allow your browser to
   **install unknown apps** (Settings → Apps → Special access → Install unknown apps).
3. Tap **Install** and open **YallaDo**.

> The app is not on Google Play yet, so Play Protect may show a warning —
> tap **Install anyway**.

---

## ✨ Features

- **Parent side:** create/approve/reject tasks, adjust points (50/day limit),
  manage rewards, invite codes to link children, leaderboard & analytics.
- **Child side:** claim & submit tasks (photo proof), redeem rewards,
  avatars, leaderboard, Buddy AI chat.
- **Buddy AI:** vision model verifies photo submissions; chat model answers
  kids' questions safely.

---

## 🛠️ Tech Stack

### Backend (`Back-End/`)

- Node.js + Express — RESTful API
- MongoDB (Mongoose) with transactions
- JWT authentication
- AI services: Qwen vision & chat models

### Frontend (`Front-End/`)

- Flutter (Android / iOS)
- BLoC/Cubit state management
- API-based communication with the backend

---

## 🚧 Project Status

- Backend: Completed ✅
- Frontend: Completed ✅
- APK: published on the [Releases page](https://github.com/mossalahhh/yallaDo/releases)

---

## 👥 Team Collaboration

This repository is shared between backend and frontend developers.
Each part of the application lives in its own directory (`Back-End/`,
`Front-End/`) for clean separation of concerns.

---

## 📌 Notes

- Environment variables and sensitive data are not committed to the repository.
- To build the APK yourself: `cd Front-End && flutter build apk --release`.

---

## 📜 License

This project is developed for educational purposes as a graduation project.
