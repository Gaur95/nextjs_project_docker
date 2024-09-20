FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json  ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build
FROM node:18-alpine AS runner

WORKDIR /app

COPY package.json  ./
RUN yarn install --production --frozen-lockfile

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/package.json ./

ENV NODE_ENV production
ENV PORT 3000
EXPOSE 3000

CMD ["yarn", "start"]
