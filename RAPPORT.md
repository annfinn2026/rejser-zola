# 📘 Teknisk Rapport & Komplet Brugervejledning: Vores Rejser & Oplevelser

Dette dokument er den samlede tekniske rapport og brugermanual for rejsebloggen **Vores Rejser & Oplevelser**. Det dækker hele systemets opbygning, hvordan du redigerer konfigurationen med Visual Studio Code, og en udførlig trin-for-trin guide til at bruge **GitHub** – herunder hvordan du opdaterer bloggen direkte fra din mobiltelefon på farten.

---

## 1. Projektets Formål & Arkitektur

Projektet startede med en samling rejsenoter og fotos fra en 3 dages tur til Wien, oprindeligt skrevet i HedgeDoc. Formålet var at skabe en moderne, lynhurtig og visuelt imponerende rejseportal med:
- **Mørkt magasin-layout:** Elegant mørkeblå/skiferblå baggrund (`#0b0f19`), varme accenter (`#fb923c`), `Playfair Display` typografi og glidende animationer.
- **Flere rejsemål side-om-side:** Forsiden præsenterer automatisk et stort fotokort for hvert rejsemål (f.eks. Wien, Tórshavn osv.).
- **Responsivt design:** Tilpasser sig automatisk fra store computerskærme (flere kolonner) ned til mobiltelefoner (1 kolonne).
- **Indbygget Lightbox:** Klik eller tryk på ethvert billede for at forstørre det i fuld skærm med billedtekst.
- **Hurtighed & Sikkerhed:** Drevet af **Zola** (Rust). Ingen PHP, ingen database, bygger på under 40 millisekunder (0,04 sek.).
- **Selvhostet & Krypteret:** Serveres via en fjerlet Nginx Docker-container på din Linode-server (`hajsdocker`) bag Nginx Proxy Manager med Let's Encrypt HTTPS på **`https://rejser.duckdns.org`**.

---

## 2. Redigering i Visual Studio Code (config.toml & filer)

### 2.1 Hvilken VS Code er installeret?
På din Fedora Silverblue-maskine er **Visual Studio Code** installeret som en Flatpak-app (`com.visualstudio.code`).  
Der er oprettet et smart CLI-alias (`~/.local/bin/code`), som automatisk virker både på selve computeren og inde fra dine Toolbox-containere (`⬢ [haj@toolbx ~]$`).

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
- **`base_url`**: Sat til `"/"`, hvilket sikrer, at alle interne links og billeder virker fejlfrit uanset domæne.

---

## 3. Komplet GitHub Vejledning (Mobil & PC)

> [!TIP] To GitHub-konti (Mobilopsætning)
> Din primære konto **inimillumfjara** er tilføjet som Collaborator med fuld skriveadgang (Write) på dette repository (som ejes af **annfinn2026**).
> Det betyder, at du på din telefon altid kan være logget ind på din normale konto **inimillumfjara** uden nogensinde at skulle logge ind og ud!

Dit projekt er koblet sammen med dit GitHub-repository:  
🔗 **[https://github.com/annfinn2026/rejser-zola](https://github.com/annfinn2026/rejser-zola)**

Hver gang der pushes eller committes en ændring på GitHub, kører **GitHub Actions** i skyen:
1. Den henter kildekoden.
2. Den optimerer og nedskalerer automatisk alle uploadede fotos via ImageMagick.
3. Installerer Zola og bygger sitet på få millisekunder.
4. Forbinder sikkert til din server `hajsdocker` over SSH (port 69) via en krypteret deploy-nøgle.
5. Synkroniserer de færdige HTML- og billedfiler direkte ind i Nginx.  
**Resultat:** Sitet opdateres live på ca. 15 sekunder!

---

### 3.1 Sådan opdaterer du direkte fra din mobiltelefon på farten

> [!IMPORTANT] Brug mobilens browser (Safari/Chrome) – ikke GitHub appen
> Den officielle GitHub mobil-app har begrænsninger og understøtter **ikke** upload af fotos eller oprettelse af filer.
> **Brug derfor telefonens browser (Safari på iPhone eller Chrome på Android):**
> Gå til `https://github.com/annfinn2026/rejser-zola` og vælg *"Føj til hjemmeskærm"* i browserens dele-menu. Så har du et direkte ikon på din telefon!

#### A. Rette i en eksisterende rejse (f.eks. tilføje dagens oplevelser):
1. Åbn mobilens browser og gå til `https://github.com/annfinn2026/rejser-zola`.
2. Tryk på mappen **`content`** ➜ mappen **`rejser`**.
3. Tryk på den rejse, du vil redigere (f.eks. **`thorshavn.md`** eller **`wien.md`**).
4. Tryk på **✏️ Blyant-ikonet** ("Edit this file") øverst til højre.
5. Skriv din tekst eller tilføj nye afsnit direkte på mobilens tastatur.
6. Rul ned i bunden, og tryk på den grønne knap **"Commit changes..."** ➜ bekræft med **"Commit changes"**.
7. *Færdig!* Inden for 15 sekunder er ændringen live på `https://rejser.duckdns.org`.

#### B. Oprette en helt ny rejse fra mobilen:
1. Gå til mappen `content/rejser/` på GitHub.
2. Åbn skabelonfilen **`SKABELON.md`** og kopiér teksten.
3. Gå tilbage til `content/rejser/`, tryk på **"Add file"** ➜ **"Create new file"**.
4. **VIGTIGT:** Giv filen et navn, der **slutter på `.md`** (f.eks. `rom.md`, `paris.md` eller `thorshavn.md`).
5. Sæt skabelon-teksten ind, og udfyld de øverste 5 linjer (Frontmatter):
   ```markdown
   +++
   title = "Rom – Den Evige Stad"
   description = "Fire dages forårsrejse gennem Roms historiske gader og pladser."
   date = 2026-10-15
   [extra]
   location = "Rom, Italien"
   cover_image = "/images/rom/forside.jpg"
   +++

   ## Dag 1: Ankomst og Colosseum
   Vi ankom i høj solskin og gik en tur gennem de gamle gader...

   ![Colosseum ved solnedgang](/images/rom/colosseum.jpg)
   ```
6. Tryk på **"Commit changes"**.
7. Den nye rejse dukker nu automatisk op på din forside med sit eget store kort og link!

#### C. Uploade nye billeder fra mobilens kamerarulle:
1. Gå til mappen `static/images/` på GitHub.
2. Gå ind i mappen for din rejse (f.eks. `static/images/thorshavn/`).
3. Tryk på **"Add file"** ➜ **"Upload files"**.
4. Vælg billederne direkte fra dit fotoarkiv/kamerarulle.
5. Tryk **"Commit changes"**.

> [!NOTE] Automatisk billedoptimering i skyen 🪄
> Du behøver **ikke** formindske billederne på telefonen først!
> GitHub Actions kører automatisk en ImageMagick-optimering i skyen, der:
> - **Auto-roterer:** Retter stående mobilbilleder baseret på EXIF-sensorer.
> - **Skalerer ned:** Sætter maks-størrelsen til **1600 px** i bredden/højden (hvis billedet er større).
> - **Komprimerer:** Skærer filstørrelsen ned fra f.eks. **10 MB til ~200–300 KB** (op til 90% besparelse) uden synligt kvalitetstab.
> - **Privatliv:** Fjerner GPS-koordinater og kamerametadata automatisk.

---

### 3.2 Hvad gør du, når du kommer hjem til din PC? (Synkronisering)
Hvis du har skrevet eller uploadet fra telefonen på rejsen, skal din computer blot hente de nyeste ændringer ned:

Åbn en terminal på din PC og kør:
```bash
cd ~/rejser_zola
git pull origin main
```
Nu er din computer 100% opdateret og synkroniseret med telefonens ændringer.

---

## 4. Skabelon & Enkel Markdown-skrivning

Du behøver **aldrig** at skrive HTML-kode som `<div class="...">` på telefonen. Systemet er indrettet, så ren standard Markdown automatisk bliver formateret flot:

| Markdown syntax | Hvad det gør |
| :--- | :--- |
| `## Dag 1: Titel` | Giver en flot, stor overskrift i avis-typografi med skillelinje |
| `### Eftermiddag` | Mindre underoverskrift i varm orange accentfarve |
| `Almindelig tekst...` | Brødtekst med behagelig læsbarhed og linjeafstand |
| `![Billedtekst](/images/...)` | Viser billedet med pæne afrundede hjørner, skygge og **forstørrer automatisk i Lightbox ved klik** |
| `> Vigtig note eller citat` | Skaber en fremhævet citatboks med orange kant |
| `---` | Indsætter en elegant vandret skillelinje |

### Skabelonfilen (`content/rejser/SKABELON.md`)
Der ligger en færdig skabelon i mappen `content/rejser/SKABELON.md`. Den har feltet `draft = true` i toppen, hvilket betyder, at Zola skjuler den på forsiden, men du kan altid åbne den på GitHub og kopiere strukturen, når du opretter en ny rejse.

---

## 5. Server- & Netværksinfrastruktur

Projektet kører på en solid Docker-arkitektur på din Linode VPS:

```
[Besøgende / Mobilbrowser]
            │
            ▼ (Port 443 HTTPS / SSL)
   [Nginx Proxy Manager] (på hajsdocker)
            │ (Forwarder internt til port 8085)
            ▼
   [rejser-web Container] (nginx:alpine)
            │ (Mounter ~/web-rejser/public/)
            ▼
   [Statiske HTML, CSS & Billeder]
```

### Serverdetaljer:
- **Server:** `hajsdocker` (IP: `172.104.143.80`, SSH port: `69`).
- **Web-container:** `rejser-web` baseret på `nginx:alpine` på intern port `8085`.
- **Domæne & SSL:** Nginx Proxy Manager styrer `https://rejser.duckdns.org` med automatisk fornyelse af Let's Encrypt SSL.
- **Navigation & Links:** Topbjælkens logo (`🧭 Vores Rejser & Oplevelser`) og linket `Alle Rejser` peger på rod-stien (`href="/"`) og leder altid tilbage til forsiden uanset hvilken underside du befinder dig på.

---

## 6. Mappestruktur i Projektet

```
~/rejser_zola/
├── config.toml               # Globale indstillinger (titel, tagline, forfatter)
├── deploy.sh                 # 1-klik deploy-script fra PC til hajsdocker
├── RAPPORT.md                # Denne rapport og vejledning
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions workflow (ImageMagick + Zola + SSH)
├── content/                  # Dit indhold i Markdown
│   ├── _index.md             # Forsidens rod-sektion
│   └── rejser/
│       ├── _index.md         # Rejse-sektion (transparent = true)
│       ├── SKABELON.md       # Kopiér-og-sæt-ind skabelon for nye rejser
│       ├── wien.md           # Wien rejsedagbog (3 dage, 34 fotos)
│       └── thorshavn.md      # Tórshavn rejsedagbog
├── static/                   # Billeder og statiske aktiver
│   └── images/
│       ├── wien/             # 34 optimerede Wien-fotos (01_ til 34_)
│       └── thorshavn/        # Mappe til fotos fra Tórshavn
└── templates/                # Skabeloner i Tera (HTML/CSS)
    ├── base.html             # Grundlayout, navigation, CSS, typografi & lightbox
    ├── index.html            # Forsideskabelon med responsive rejsekort
    ├── page.html             # Rejsesideskabelon med dagsnavigation
    └── section.html          # Sektionsoversigt
```

---

## 7. Hurtigt Cheat Sheet

| Hvad vil du gøre? | Hvor og hvordan? |
| :--- | :--- |
| **Åbn projektet i VS Code** | `code ~/rejser_zola` i terminalen |
| **Ret i konfigurationen** | `code ~/rejser_zola/config.toml` |
| **Se ændringer lokalt på PC** | `cd ~/rejser_zola && zola serve` ➜ åbn `http://127.0.0.1:1111` |
| **Læg online fra PC** | Kør `~/rejser_zola/deploy.sh` i terminalen |
| **Opdater fra mobilen** | Åbn [github.com/annfinn2026/rejser-zola](https://github.com/annfinn2026/rejser-zola) i mobilbrowser ➜ ret/opret ➜ **Commit** |
| **Opret ny rejse fra mobil** | Kopiér fra `content/rejser/SKABELON.md` ➜ opret `by-navn.md` ➜ **Commit** |
| **Skift forsidefoto på et kort** | Ret linjen `cover_image = "/images/by/foto.jpg"` i toppen af rejsefilen |
| **Hent mobil-rettelser til PC** | Kør `cd ~/rejser_zola && git pull origin main` |
| **Besøg dit live site** | [https://rejser.duckdns.org/](https://rejser.duckdns.org/) |
