# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM tiangolo/node-frontend:10 as build-stage
#FROM mhart/alpine-node:8 as build-stage
WORKDIR /app
RUN pwd
COPY package*.json /app/
RUN npm config set proxy http://10.0.8.102:8080
RUN npm config set https-proxy http://10.0.8.102:8080
RUN npm install
COPY ./ /app/
ARG configuration=production
RUN npm run build -- --output-path=./server/public --target=$configuration

# Backend

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./server/package.json ./
RUN npm install

COPY ./server .

EXPOSE 3001
RUN ls -agh
RUN pwd
CMD ["npm", "run", "start"]

# # Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
# FROM nginx:1.15
# COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
# # Copy the default nginx.conf provided by tiangolo/node-frontend
# COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf


