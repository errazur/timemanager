# Generate back-end doc

```sh
cd timemachine
mix docs
mv doc priv/static
```

# Setup on Windows

## Front

### NodeJS

Installer [NodeJS 20.9.0](https://nodejs.org/dist/v20.9.0/node-v20.9.0-x64.msi)

### Install dependencies

```sh
cd front
npm install
```

## Back

### Elixir

Installer [Erlang 26](https://github.com/erlang/otp/releases/download/OTP-26.1.2/otp_win64_26.1.2.exe)

Installer [Elixir 1.15](https://github.com/elixir-lang/elixir/releases/download/v1.15.7/elixir-otp-26.exe)

### PostgreSQL

Installer [PostgreSQL 16](https://sbp.enterprisedb.com/getfile.jsp?fileid=1258698)

### Install dependencies

```sh
cd timemachine
mix local.hex
mix archive.install hex phx_new
mix setup
```

# Run on Windows

### Front

```sh
cd front
npm run dev
```

Now you can visit [`localhost:5173`](http://localhost:5173) from your browser.

### Back

```sh
cd timemachine
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Run mobile on Windows

### Prérequis 

- Installer Gradle 8.4
- Installer Java JDK 17.0.9
- Installer Android Studio, puis aller dans Settings, rechercher "SDK" et aller dans "Android SDK" :
    - Onglet 1 (SDK Platform), télécharger :
        - Android 13.0, API Level 33
    - Onglet 2 (SDK Tools), cocher "Hide Obsolete Packages", et télécharger :
        - Android SDK Build-Tools 33.0.2
        - Android SDK Command-line Tools (lastest)
        - Android Emulator
        - Android SDK Platform-Tools
- Ajouter les variables d'environnement (pour Windows... voir tuto pour Mac) :
    - ANDROID_HOME = C:\Users\username\AppData\Local\Android\Sdk
    - ANDROID_SDK_ROOT = C:\Users\\*username*\AppData\Local\Android\Sdk
    - JAVA_HOME = C:\Program Files\Java\jdk-17
    - Ajouter au Path :
        - C:\Gradle\gradle-8.4\bin
        - C:\Users\\*username*\AppData\Local\Android\Sdk\cmdline-tools\latest\bin
        - C:\Users\\*username*\AppData\Local\Android\Sdk\build-tools
        - C:\Users\\*username*\AppData\Local\Android\Sdk\platform-tools
        - C:\Users\\*username*\AppData\Local\Android\Sdk\emulator
- Dans Android Studio, paramétrer un émulateur Pixel 3a avec API 33

### Démarrer l'application Android

Aller dans le projet via terminal, puis :
```sh
cd front
npm i
npm run build //-> compile le projet Vue3
npx cap copy //-> met les fichiers compilés dans le dossier de capacitor
npx cap run android //-> démarre l'app Android dans l'émulateur précédemment paramétré via Android Studio
```

A savoir que `npx cap open android` ouvre le projet via Android Studio, cela peut aider à trouver l'origine des bugs parfois.

Par exemple, si ça tourne en boucle à `Deploying app-debug.apk to Pixel_3a_API_33` (plus de 120 secondes), utiliser cette commande pour voir si Android Studio ne réclame pas une mise à jour de Gradle ou autre.

Ne pas hésiter à supprimer l'appareil et en recréer un, cela peut parfois régler des problèmes.

### Nota Bene

Pour info, ce que j'ai fait pour démarrer le projet Capacitor :
```sh
cd front
npm i
npm install --save-dev @capacitor/core @capacitor/cli @capacitor/android
npx cap init //-> Choisir nom du projet, etc.
npx cap add android

npm run build
npx cap copy
npx cap run android
```