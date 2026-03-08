# Dockerfile

# Stage 1: Build frontend
FROM node:16 AS frontend-build
WORKDIR /app
COPY ./frontend/package.json ./frontend/package-lock.json ./frontend/
RUN npm install
COPY ./frontend/ ./frontend/
RUN npm run build

# Stage 2: Build backend
FROM node:16 AS backend-build
WORKDIR /app
COPY ./backend/package.json ./backend/package-lock.json ./backend/
RUN npm install
COPY ./backend/ ./backend/
COPY --from=frontend-build /app/frontend/build /app/backend/public

# Stage 3: Production
FROM node:16 AS production
WORKDIR /app
COPY --from=backend-build /app/backend .
CMD ["npm", "start"]
