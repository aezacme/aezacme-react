# Build Stage
FROM node:23-alpine3.20 AS  build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile
COPY . ./
RUN npm run build

# Dev Stage
FROM node:23-alpine3.20 AS  development
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile
COPY . ./
EXPOSE 3000
CMD ["npm", "start"]

# Prod Stage
FROM nginx:alpine AS production
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
