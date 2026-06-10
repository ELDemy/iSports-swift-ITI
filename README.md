# iSports 🏆

iSports is a comprehensive sports application built with UIKit that allows users to explore multiple sports, browse leagues, follow matches, view team information, and discover detailed player statistics.

## Features

### 🚀 Splash & Onboarding

* Splash Screen for application launch.
* Interactive Onboarding experience for first-time users.
* Smooth navigation into the main application.

### 🏠 Home Screen

The Home screen serves as the central hub of the application and includes:

* Featured sports categories:

  * Football ⚽
  * Basketball 🏀
  * Cricket 🏏
  * Tennis 🎾

* Dynamic banner slider showcasing sports-related images and highlights.

### 🏆 Leagues

Selecting a sport displays all available leagues for that sport.

Users can:

* Browse leagues.
* Search and explore competitions.
* Access league-specific information.

### 📅 League Details

Each league contains:

#### Upcoming Events

* Scheduled matches and future fixtures.

#### Latest Results

* Recently completed matches and results.

#### Teams / Players

* Teams for Football, Basketball, and Cricket.
* Players for Tennis.

### ⚽ Match Details

Selecting a match provides detailed match information including:

* Match Statistics
* Match Events
* Team Lineups

This allows users to analyze game performance and follow match progression in depth.

### 👥 Team Details

Selecting a team displays:

* Team information
* Full squad list
* Player positions
* Jersey numbers
* Matches played by team members

### 🧑‍💼 Player Details

Selecting a player provides detailed player information including:

* Personal information
* Position
* Team affiliation
* Performance details
* Match participation history

### ⭐ Favorites

Users can save their favorite leagues for quick access and personalized browsing.

### 🌙 Dark Mode Support

* Light Mode
* Dark Mode
* Seamless theme switching from the Settings screen

---

## Architecture

The project follows the **MVP (Model-View-Presenter)** architectural pattern to achieve:

* Separation of concerns
* Better maintainability
* Improved testability
* Scalable project structure

---

## Technologies Used

* UIKit
* UICollectionView Compositional Layout
* MVP Architecture
* URLSession / Networking Layer
* Auto Layout
* UserDefaults
* SkeletonView
* Dark Mode Support

---

## Application Flow

```text
Splash Screen
      ↓
Onboarding Screen
      ↓
Home Screen
      ↓
Select Sport
      ↓
Leagues Screen
      ↓
League Details
      ├── Upcoming Events
      ├── Latest Results
      └── Teams / Players
                ↓
        Team Details
                ↓
        Player Details

OR

League Details
      ↓
Match Details
      ├── Statistics
      ├── Events
      └── Lineups
```

## Screens

* Splash Screen
* Onboarding Screen
* Home Screen
* Leagues Screen
* League Details Screen
* Match Details Screen
* Team Details Screen
* Player Details Screen
* Favorites Screen
* Settings Screen


---

## 👨‍💻 Development Team

This project was designed and developed by:

| Team Member                     | Role          |
| ------------------------------- | ------------- |
| **Mohamed Ali Shaltoot**        | iOS Developer |
| **Mahmoud Moustfa ElDemerdash** | iOS Developer |
| **Omer Ramadan ElRouby**        | iOS Developer |

---

### Contributors

* Mohamed Ali Shaltoot
* Mahmoud Moustfa ElDemerdash
* Omer Ramadan ElRouby

Built with UIKit, MVP Architecture, and modern iOS development practices.


## Dark Theme

<img width="1206" height="2622" alt="eventMatchDetailsDarkMode" src="https://github.com/user-attachments/assets/f769f3b9-01b6-4e0f-a1c2-56c62e97b18c" />
<img width="1206" height="2622" alt="teamDetailsDarkMode" src="https://github.com/user-attachments/assets/20d1444f-85f8-485d-9f24-d565d674589c" />
<img width="1206" height="2622" alt="playerDetailsDarkMode" src="https://github.com/user-attachments/assets/cf64b124-32e4-4cae-9bcb-710cf0b473a5" />
<img width="1206" height="2622" alt="lineupsMatchDetailsDarkMode" src="https://github.com/user-attachments/assets/cd469567-1cf1-4910-9f58-10bac8dc8ea4" />
<img width="1206" height="2622" alt="leagueScreenDarkMode" src="https://github.com/user-attachments/assets/7dbb681b-f53d-4c88-b604-6a20a3ec15ff" />
<img width="1206" height="2622" alt="leagueDetailsScreenDarkMode" src="https://github.com/user-attachments/assets/25df757e-cd01-44b5-b238-51cfc3b877be" />


## Light Theme

<img width="1206" height="2622" alt="teamDetailsLightMode" src="https://github.com/user-attachments/assets/098f63c6-b2ca-4dc2-843a-1673e87b8404" />
<img width="1206" height="2622" alt="staticticsMatchDetailsLightMode" src="https://github.com/user-attachments/assets/c8af163f-e8ad-4e36-9c1f-3def8c12b5c6" />
<img width="1206" height="2622" alt="SettingsLightMode" src="https://github.com/user-attachments/assets/74c34508-2068-4add-8ac5-3dc9d44e1ad1" />
<img width="1206" height="2622" alt="playerDetailsLightMode" src="https://github.com/user-attachments/assets/71f4c31c-46dc-4cd4-b81b-9f8d310ab84b" />
<img width="1206" height="2622" alt="lineupsMatchDetailsLightMode" src="https://github.com/user-attachments/assets/d0f0bef1-cbc5-45b0-b5bb-b3ec84914001" />
<img width="1206" height="2622" alt="leagueScreenLightMode" src="https://github.com/user-attachments/assets/83c340a6-8a24-4bf1-b792-73e1147fcfde" />
<img width="1206" height="2622" alt="leagueDetailsScreenLightMode" src="https://github.com/user-attachments/assets/b19884b8-b011-4c80-aa05-5e45c873472a" />
<img width="1206" height="2622" alt="homeScreenLightMode" src="https://github.com/user-attachments/assets/1c4d2d28-396c-4752-b954-84c0b0f27a67" />
<img width="1206" height="2622" alt="favScreenLightMode" src="https://github.com/user-attachments/assets/54ad2406-e6cd-42b0-add7-a12cbe11beda" />
<img width="1206" height="2622" alt="eventMatchDetailsLightMode" src="https://github.com/user-attachments/assets/12eadeef-636c-4f66-8b73-22d0f8aa9210" />















