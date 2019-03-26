# Stage 1
FROM node:11 
# as veo-frontend
WORKDIR /app
COPY . ./
RUN yarn
CMD [ "npm", "start" ]


# run docker with docker-compose  docker-compose up -d --build




#  docker build -t sample-app .
#docker run -it \-v ${PWD}:/usr/src/app \ -v /usr/src/app/node_modules \-p 3000:3000 \ --rm \ sample-app