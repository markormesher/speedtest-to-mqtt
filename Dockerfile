FROM node:21.5.0-bookworm@sha256:73a9c498369c6e6f864359979c8f4895f28323c07411605e6c870d696a0143fa AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.5.0-bookworm@sha256:73a9c498369c6e6f864359979c8f4895f28323c07411605e6c870d696a0143fa

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
