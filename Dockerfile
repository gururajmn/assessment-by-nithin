# ==========================
# Stage 1: Build Stage
# ==========================

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .



# ==========================
# Stage 2: Production Stage
# ==========================

FROM node:20-alpine

WORKDIR /app


# Copy only required application files
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/app.js ./


# Create non-root user
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup


# Change ownership
RUN chown -R appuser:appgroup /app


# Run container as non-root
USER appuser


EXPOSE 3000


CMD ["npm", "start"]
