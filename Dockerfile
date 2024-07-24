FROM node:16-alpine as build-stage

WORKDIR /app
RUN corepack enable

COPY .npmrc package.json package-lock.json ./
RUN npm install 

COPY . .
RUN npm run build

FROM nginx:1.26.1-alpine3.19 as production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
