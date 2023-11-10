# Utilisation de l'image officielle Elixir
FROM elixir
# Répertoire de travail dans l'image
WORKDIR /app
# Copier tous les fichiers depuis le répertoire de construction vers le répertoire de travail de l'image
COPY . ./
# Exposer les ports nécessaires pour votre application
EXPOSE 8080
EXPOSE 3000
EXPOSE 987
EXPOSE 4000
# EXPOSE 4001
EXPOSE 5432
# Mettre à jour et installer inotify-tools
RUN apt-get update -y && apt-get install -y inotify-tools
# Installer Hex et Phoenix
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new --force
# Installer les dépendances de l'application
RUN mix deps.get
# Installation de PostgreSQL
RUN apt-get install -y postgresql postgresql-contrib
# Configuration de PostgreSQL (changer le mot de passe par défaut)
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "ALTER USER postgres PASSWORD 'root';" && \
    createdb -O postgres timemachine_dev
USER root
# Démarrer PostgreSQL, créer la base de données et démarrer l'application Phoenix
CMD service postgresql start && mix ecto.create && mix ecto.setup && mix phx.server