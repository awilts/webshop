FROM node:16

#node processes with PID 1 do not automatically shut down on SIGINT, so we wrap node with tini here
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

WORKDIR /usr/src/app/

COPY package.json /usr/src/app/
COPY node_modules /usr/src/app/node_modules
COPY build /usr/src/app/build

ENV PORT=8080

CMD [ "node", "build" ]
