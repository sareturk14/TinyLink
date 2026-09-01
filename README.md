# TinyLink — AI-Powered URL Shortener

TinyLink is a full-stack URL shortening web application built with Java Spring MVC. It lets authenticated users shorten long URLs, set expiration times, track click counts, 
and get AI-generated summaries and categories for each link — all through a clean, responsive interface.

## Features

- **URL Shortening** — Generate short codes for any URL instantly
- **Link Expiration** — Set optional lifetimes: 1 hour, 24 hours, 7 days, 30 days, or forever
- **AI Summary & Category** — Each shortened URL is automatically summarized and categorized using the Gemini API
- **Click Tracking** — Track how many times each short link has been visited
- **Soft Delete & Trash Bin** — Move links to trash and restore or permanently delete them
- **User Authentication** — Register, login, and email verification with secure BCrypt password hashing
- **Admin Panel** — Admin users can view and manage all users and their links
- **Role-Based Access Control** — USER and ADMIN roles with Spring Security
- **Internationalization** — English and Turkish language support


Register:

<img width="1600" height="775" alt="image" src="https://github.com/user-attachments/assets/4d1c7047-e1d8-4e4a-b0b9-ac6efef37426" />



Login:
<img width="1600" height="768" alt="image" src="https://github.com/user-attachments/assets/800c1e92-7ca6-4e8e-b070-383d2e2994e6" />



URL Shortening:
<img width="1600" height="771" alt="image" src="https://github.com/user-attachments/assets/04130410-49c2-433a-b471-a602a304acdc" />



Shortened URLs:
<img width="1600" height="767" alt="image" src="https://github.com/user-attachments/assets/567efea7-527a-4457-bc59-f5a63e43dcda" />



Trash:
<img width="1600" height="768" alt="image" src="https://github.com/user-attachments/assets/50bab339-8cc7-4d12-82c1-99aa9ed1926d" />



Admin Panel-1:
<img width="1600" height="775" alt="image" src="https://github.com/user-attachments/assets/78388f6e-c2f5-40fa-85a6-c5bbb7d3d351" />



Admin Panel-2:
<img width="1600" height="772" alt="image" src="https://github.com/user-attachments/assets/02631705-d9ed-42f1-afed-d53df813fe36" />



## Project Structure

```
src/
├── main/
│   ├── java/tr/edu/duzce/mf/bm/
│   │   ├── config/         # Spring & Security configuration
│   │   ├── controller/     # MVC Controllers (Auth, URL, Admin)
│   │   ├── dao/            # JPA Repositories
│   │   ├── entity/         # JPA Entities (User, UrlLink, ...)
│   │   └── service/        # Business logic (Auth, URL, AI, Email)
│   ├── resources/
│   │   ├── messages*.properties   # i18n (EN / TR)
│   │   └── schema.sql             # Database schema
│   └── webapp/
│       └── WEB-INF/views/  # JSP pages
```


## Default Roles

`USER`:Shorten URLs, manage own links, trash bin 
`ADMIN`: Everything above + admin panel (all users & links)

## Getting Started

### Prerequisites

- Docker & Docker Compose
- Java 17+
- Maven

### 1. Clone the repository

```bash
git clone https://github.com/sareturk14/TinyLink.git
cd TinyLink
```

### 2. Set up environment variables

Copy the example below and fill in your own values. You can pass them directly in `docker-compose.yml` or via a `.env` file.

```env
MAIL_SMTP_HOST=smtp.gmail.com
MAIL_SMTP_PORT=587
MAIL_SMTP_USER=your_email@gmail.com
MAIL_SMTP_PASS=your_gmail_app_password
```

> **Gmail:** Use an [App Password](https://myaccount.google.com/apppasswords), not your regular Gmail password.

Also set your Gemini API key in `AiServiceImpl.java`:

```java
private static final String API_KEY = "YOUR_API_KEY";
```

### 3. Build the WAR file

```bash
mvn clean package -DskipTests
```

### 4. Run with Docker Compose

```bash
docker-compose up --build
```

The app will be available at: **http://localhost:8080**










