# --- STAGE 1: Build ---
FROM node:12.7-alpine AS build

# Définir le répertoire de travail
WORKDIR /usr/src/app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Copier tout le contenu du projet
COPY . .

# Construire le projet Angular
RUN npm run build --prod

# --- STAGE 2: Run ---
FROM nginx:1.17.1-alpine

# Copier le fichier de configuration Nginx personnalisé
COPY nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers construits depuis le conteneur de build
COPY --from=build /usr/src/app/dist/aston-villa-app  /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Commande par défaut
CMD ["nginx", "-g", "daemon off;"]

