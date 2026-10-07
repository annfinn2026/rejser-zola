# 📘 Teknisk Rapport & Komplet Brugervejledning: Vores Rejser & Oplevelser

Dette dokument er den samlede tekniske rapport og brugermanual for rejsebloggen **Vores Rejser & Oplevelser**. Det dækker hele systemets opbygning, hvordan du redigerer konfigurationen med Visual Studio Code, og en udførlig trin-for-trin guide til at bruge **GitHub** – herunder hvordan du opdaterer bloggen direkte fra din mobiltelefon på farten.

---

## 1. Projektets Formål & Arkitektur

Projektet startede med en samling rejsenoter og fotos fra 3 dages tur til Wien, skrevet i HedgeDoc. Formålet var at skabe en moderne, lynhurtig og visuelt imponerende rejseportal med:
- **Mørkt magasin-layout:** Elegant mørkeblå/skiferblå baggrund (`#0b0f19`), varme accenter (`#fb923c`), `Playfair Display` typografi og hover-animationer.
- **Responsivt fotogalleri:** Responsive kort, der tilpasser sig automatisk til 3 kolonner på desktop og 1 kolonne på mobiltelefoner.
- **Indbygget Lightbox:** Klik på ethvert billede for at forstørre det i fuld skærm med billedtekst.
- **Hurtighed & Sikkerhed:** Drevet af **Zola** (Rust). Ingen PHP, ingen database, bygger på under 40 millisekunder (0,04 sek.).
- **Selvhostet & Krypteret:** Serveres via en fjerlet Nginx-container på din Linode-server (`hajsdocker`) bag Nginx Proxy Manager med Let's Encrypt HTTPS på **`https://rejser.duckdns.org`**.

---

## 2. Redigering i Visual Studio Code (config.toml & filer)

### 2.1 Hvilken VS Code er installeret?
På din Fedora Silverblue-maskine er **Visual Studio Code** installeret som en Flatpak-app (`com.visualstudio.code` version 1.139).  
Der er oprettet et smart CLI-alias (`~/.local/bin/code`), så du kan starte editoren direkte fra enhver terminal.

### 2.2 Sådan åbner du projektet i VS Code:
- **Åbn hele rejseprojektet:**
  ```bash
  code ~/rejser_zola
  ```
- **Åbn kun `config.toml` direkte:**
  ```bash
  code ~/rejser_zola/config.toml
  ```

### 2.3 Sådan fungerer `config.toml`:
Filen styrer de overordnede globale indstillinger for dit site:
```toml
title = "Vores Rejser & Oplevelser"
base_url = "/"
compile_sass = false
build_search_index = false

[extra]
author = "Hans"
tagline = "Visuelle rejsefortællinger, vandreruter og fotoarkiv"
```
- **`title`**: Sidens officielle navn (vises i browserfanen, headeren og footeren).
- **`tagline`**: Underoverskriften, der står under den store forside-titel.
- **`author`**: Forfatterens navn.
- **`base_url`**: Sat til `"/"`, hvilket sikrer, at alle links og billeder virker perfekt uanset om du tilgår siden via `localhost`, IP-adresse eller `https://rejser.duckdns.org`.

*Anbefalet VS Code-udvidelse:* Åbn udvidelser i VS Code (<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>X</kbd>) og installer **"Even Better TOML"** for at få flot syntaksfarvning i `.toml`-filer.

---

## 3. Komplet GitHub Vejledning (Mobil & PC)

Dit projekt er koblet sammen med et GitHub repository:  
🔗 **[https://github.com/annfinn2026/rejser-zola](https://github.com/annfinn2026/rejser-zola)**

Hver gang der sker en ændring på GitHub, træder **GitHub Actions** i kraft i skyen:
1. Den henter kildekoden.
2. Installerer Zola og bygger sitet på få millisekunder.
3. Forbinder sikkert til din server `hajsdocker` over SSH (port 69) via en krypteret deploy-nøgle.
4. Synkroniserer de færdige HTML- og billedfiler direkte ind i Nginx.  
**Resultat:** Sitet opdateres live på ca. 15 sekunder!

---

### 3.1 Sådan opdaterer du direkte fra din mobiltelefon på rejsen

Du behøver **ikke** have en computer med på ferie. Du kan gøre alt fra mobiltelefonen via browseren eller den officielle GitHub app.

#### A. Rette i en eksisterende rejse (f.eks. tilføje noter eller rette tekst):
1. Åbn mobilens browser og gå til:  
   `https://github.com/annfinn2026/rejser-zola`
2. Tryk på mappen **`content`** ➜ derefter mappen **`rejser`**.
3. Tryk på den rejse, du vil redigere (f.eks. **`wien.md`**).
4. Tryk på **✏️ Blyant-ikonet** ("Edit this file") øverst til højre.
5. Ret din tekst eller tilføj nye afsnit direkte på mobilens tastatur.
6. Rul ned i bunden, og tryk på den grønne knap **"Commit changes..."** ➜ bekræft med **"Commit changes"**.
7. *Færdig!* Inden for 15 sekunder er ændringen live på `https://rejser.duckdns.org`.

#### B. Oprette en helt ny rejse fra mobilen (f.eks. Rom eller Paris):
1. Gå til mappen `content/rejser/` på GitHub.
2. Tryk på **"Add file"** knappen ➜ vælg **"Create new file"**.
3. Giv filen et navn foroven, f.eks. `rom.md` eller `paris.md`.
4. Indsæt skabelonen i toppen (Frontmatter):
   ```markdown
   +++
   title = "Rom – Den Evige Stad"
   description = "Fire dages forårsrejse gennem Roms historiske gader og pladser."
   date = 2026-10-15
   [extra]
   location = "Rom, Italien"
   days = 4
   photos = 25
   cover_image = "/images/rom/forside.jpg"
   nav_days = [
     { anchor = "#dag-1", title = "Dag 1: Colosseum & Forum" },
     { anchor = "#dag-2", title = "Dag 2: Vatikanet & Peterskirken" }
   ]
   +++

   # Dag 1: Colosseum
   Her skriver du dine oplevelser og indsætter billeder...
   ```
5. Tryk på **"Commit changes"**.
6. Den nye rejse dukker nu automatisk op på din forside med sit eget store kort, lokation og dagsnavigation!

#### C. Uploade nye billeder fra mobilens kamerarulle:
1. Gå til mappen `static/images/` på GitHub.
2. Opret en ny undermappe eller gå ind i en eksisterende.
3. Tryk på **"Add file"** ➜ **"Upload files"**.
4. Vælg billederne direkte fra dit fotoarkiv/kamerarulle.
5. Tryk **"Commit changes"**.

---

### 3.2 Hvad gør du, når du kommer hjem til din PC? (Synkronisering)

Hvis du har lavet ændringer fra din mobiltelefon, skal din computer lige hente de nyeste ændringer ned, før du arbejder videre lokalt.

Åbn terminalen på din PC og kør:
```bash
cd ~/rejser_zola
git pull origin main
```
Nu er din PC 100% opdateret med de ting, du skrev fra telefonen på rejsen.

---

## 4. Lokal Arbejdsgang på PC

Når du sidder hjemme ved din computer, har du den perfekte udviklingsopsætning:

### 4.1 Se ændringer live mens du skriver (Live Preview):
```bash
cd ~/rejser_zola
zola serve
```
Åbn derefter din browser på **`http://127.0.0.1:1111`**.  
Hver gang du gemmer en fil i VS Code, genindlæser browseren automatisk på et splitsekund!

### 4.2 Udrul ændringer til serveren:
Når du er færdig med dine rettelser og vil have dem online, har du to lige gode muligheder:

- **Mulighed A: Kør det lynhurtige deploy-script:**
  ```bash
  ~/rejser_zola/deploy.sh
  ```
  *(Bygger sitet lokalt og uploader til serveren via SSH på under 1 sekund).*

- **Mulighed B: Standard Git push:**
  ```bash
  cd ~/rejser_zola
  git add .
  git commit -m "Mine nye billeder og rettelser"
  git push origin main
  ```
  *(Sender koden til GitHub, som derefter automatisk udruller via GitHub Actions).*

---

## 5. Server- & Netværksinfrastruktur

Projektet kører på en solid, professionel Docker-arkitektur på din Linode VPS:

```
[Internet / Mobil / Browser]
            │
            ▼ (Port 443 HTTPS / SSL)
   [Nginx Proxy Manager] (på hajsdocker)
            │ (Forwarder til intern port 8085)
            ▼
   [rejser-web Container] (nginx:alpine)
            │ (Mounter ~/web-rejser/public/)
            ▼
   [Statiske HTML, CSS & Billeder]
```

### Detaljer:
- **Server:** `hajsdocker` (IP: `172.104.143.80`, SSH port: `69`).
- **Web-container:** `rejser-web` baseret på det officielle `nginx:alpine` image.
- **Port:** Intern containerport `8085` på hosten.
- **Data-sti på serveren:** `/home/haj/web-rejser/public/`.
- **Domæne & SSL:** Styres af Nginx Proxy Manager på `https://rejser.duckdns.org` med automatisk fornyelse af Let's Encrypt certifikatet.
- **Sikkerhed:** GitHub Actions forbinder til serveren med en isoleret ED25519 deploy-nøgle, som udelukkende har adgang til brugeren `haj` og er beskyttet i GitHub Secrets (`SSH_HOST`, `SSH_PORT`, `SSH_USER`, `SSH_PRIVATE_KEY`).

---

## 6. Mappestruktur i Projektet

Her er et overblik over filerne i dit projekt:

```
~/rejser_zola/
├── config.toml               # Globale indstillinger (titel, tagline, forfatter)
├── deploy.sh                 # 1-klik deploy-script til hajsdocker
├── RAPPORT.md                # Denne rapport og manual
├── content/                  # Alt dit indhold (Markdown)
│   ├── _index.md             # Forsidens sektionstitel
│   └── rejser/
│       ├── _index.md         # Rejse-sektion
│       └── wien.md           # Wien rejsedagbog (Dag 1, 2, 3)
├── static/                   # Statiske filer (kopieres direkte over)
│   └── images/
│       └── wien/             # Lokale, optimerede billeder (01_ til 34_)
└── templates/                # Skabeloner i Tera (HTML/CSS)
    ├── base.html             # Grundlayout, mørkt tema, typografi og lightbox
    ├── index.html            # Forside med store rejsekort
    ├── page.html             # Enkelt rejseside med hero & navigation
    └── section.html          # Sektionsoversigt
```

---

## 7. Hurtigt Cheat Sheet

| Hvad vil du gøre? | Hvor og hvordan? |
| :--- | :--- |
| **Åbn projektet i VS Code** | `code ~/rejser_zola` i terminalen |
| **Ret i konfigurationen** | `code ~/rejser_zola/config.toml` |
| **Se ændringer lokalt** | `cd ~/rejser_zola && zola serve` ➜ åbn `http://127.0.0.1:1111` |
| **Læg online fra PC** | Kør `~/rejser_zola/deploy.sh` i terminalen |
| **Opdater fra mobilen** | Gå til [github.com/annfinn2026/rejser-zola](https://github.com/annfinn2026/rejser-zola) ➜ ret/opret fil ➜ **Commit** |
| **Hent mobil-rettelser til PC**| Kør `cd ~/rejser_zola && git pull origin main` |
| **Besøg dit live site** | [https://rejser.duckdns.org/](https://rejser.duckdns.org/) |
