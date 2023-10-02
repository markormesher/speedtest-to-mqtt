FROM node:20.8.0-bookworm@sha256:6b3f9aa7eefa8d4c93d43914e78aa2bfea9a12808b0059e5da78854dfa8b8768 AS builder
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./src ./src
COPY ./tsconfig.json ./

RUN yarn build

# ---

FROM node:20.8.0-bookworm@sha256:6b3f9aa7eefa8d4c93d43914e78aa2bfea9a12808b0059e5da78854dfa8b8768
RUN apt update && apt install -y --no-install-recommends python3 && apt clean

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production --frozen-lockfile && yarn cache clean

COPY --from=builder /app/build /app/build

CMD yarn start
