FROM node:21.1.0-bookworm@sha256:1f937398bb207138bd26777f76d8b31b44f22d8baf6058705ad7433225c6f1aa AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:21.1.0-bookworm@sha256:1f937398bb207138bd26777f76d8b31b44f22d8baf6058705ad7433225c6f1aa
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
