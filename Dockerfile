ARG NODE_VERSION=20-alpine

FROM node:${NODE_VERSION} AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:${NODE_VERSION}
WORKDIR /app

COPY package*.json ./
RUN npm ci --production

COPY --from=build /app/dist /app/dist
COPY --from=build /app/src/server /app/src/server
COPY --from=build /app/src/common /app/src/common

EXPOSE 3000
CMD ["npm", "start"]