FROM node:18-alpine3.15 as builder


ENV NODE_ENV build


WORKDIR /home/node


COPY . /home/node
RUN chmod 777 -R /home/node/
RUN npm i
RUN yarn nx build messenger --configuration=production

FROM node:18-alpine3.15

ENV NODE_ENV production


USER node
WORKDIR /home/node


COPY --from=builder /home/node/package*.json /home/node/
COPY --from=builder /home/node/node_modules/ /home/node/node_modules/
COPY --from=builder /home/node/dist/apps/messenger/ /home/node/dist/


CMD ["node", "dist/main.js"]