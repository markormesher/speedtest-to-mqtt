FROM node:21.7.3-bookworm@sha256:f3f975c2c041b0bccb9ee1d71c34d7d98f0e88c21cf5826b67352e36cb1095a6 AS builder

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn install

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.7.3-bookworm@sha256:f3f975c2c041b0bccb9ee1d71c34d7d98f0e88c21cf5826b67352e36cb1095a6

WORKDIR /app

COPY .yarn/ .yarn/
COPY package.json yarn.lock .yarnrc.yml .pnp* ./
RUN yarn workspaces focus --all --production

COPY --from=builder /app/build /app/build

CMD yarn start
