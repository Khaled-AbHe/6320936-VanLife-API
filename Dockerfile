# This part is to build the api
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
# npm ci (clean install) is made for builds. It cleans up node_modules and is overall faster
RUN npm ci 

COPY . .
RUN npm run build

# This part is for publishing just the built api. We do this so that it loads as fast as possible
FROM node:20-alpine AS production

WORKDIR /app

COPY package*.json ./
# Only installs the dependencies for production by excluding the dev ones
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]