# Construction Field Management App

### Intern Selection Task Submission

**Overview**
A polished Flutter application designed to manage construction sites and daily progress reports (DPR). Built with a focus on clean architecture and responsive UI.

**🎥 [Video Walkthrough](https://youtu.be/LTQfOLqUCK8)**

---

### -> Features Implemented
**Authentication:** Mock login logic with input validation.
**Smart Dashboard:** Project list with status indicators (Green/Orange/Red badges).
**DPR Form:**
  - Auto-fills project name based on selection.
  - Date picker & Weather dropdown.
  - **Cross-Platform Image Picker:** Smartly handles images on both Web (Network) and Mobile (File).
**Data Persistence:** In-memory "History" feature to track submitted reports.
**Clean Code:** separated `models`, `screens`, and reusable `widgets`.

### -> Tech Stack
* **Framework:** Flutter (Dart)
* **State Management:** setState (Local)
* **Navigation:** Material PageRoute with History Cleaning (Logout)

### -> How to Run
1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/ManishSD090/construction_field_manager.git](https://github.com/ManishSD090/construction_field_manager.git)
    cd construction_field_manager
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run:**
    ```bash
    flutter run
    ```