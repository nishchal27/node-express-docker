# our first stage which is builder stage to build our appilication
FROM node:18 as builder

# working dicrectory for Docker named "build" folder
WORKDIR /build

# copying all (*) package.json file in current working dicrectory "build"
COPY package*.json .
# installing all dependecies in docker container
RUN npm install

# copying our src folder in docker src folder 
COPY src/ src/
# copying our tsconfig.json in docker tsconfig.json
COPY tsconfig.json tsconfig.json

# this will build our application in container in "dist" folder
RUN npm run build

# our second stage which is runner stage
FROM node:18 as runner

WORKDIR /app

COPY --from=builder build/package*.json .
COPY --from=builder build/node_modules node_modules
COPY --from=builder build/dist dist/

CMD [ "npm", "start" ]