FROM node:18

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

ARG VERSION=Blue
ENV VERSION=$VERSION

EXPOSE 3000
CMD ["npm", "start"]
