# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM tiangolo/node-frontend:10 as build-stage

# Test later with this image, size optimization is required
#FROM mhart/alpine-node:8 as build-stage
WORKDIR /app
COPY package*.json /app/
RUN npm install
COPY ./ /app/
# Arg for the build, if pass empty configuration arg it builds in dev mode
ARG configuration=production

# builds with the passed argument configuration and outputs it in the node public folder for static serving
RUN npm run build -- --output-path=./server/public --target=$configuration

# Backend

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY ./server/package.json ./
RUN npm install

COPY ./server .

EXPOSE 3001
CMD ["npm", "run", "start"]


## Frontend with nginx, commented for now because we are serving the app with the node server
# # Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
# FROM nginx:1.15
# COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
# # Copy the default nginx.conf provided by tiangolo/node-frontend
# COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf


