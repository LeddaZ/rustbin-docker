# =============================================================================
# Stage 1: Builder
# =============================================================================
FROM debian:trixie-slim AS builder

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    gcc \
    pkg-config \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --- Install Go ---
ARG GO_VERSION=1.26.1
RUN curl -fsSL "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
    | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go version

# --- Install Rust (stable) ---
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustc --version && cargo --version

# --- Clone and build rustbin ---
WORKDIR /build
RUN git clone https://github.com/PeroSar/rustbin.git .

# build.rs compiles the Go FFI (ffi/enry) as part of the Cargo build,
# so having Go in PATH is enough — no manual CGO step needed.
ENV SQLX_OFFLINE=true
RUN cargo build --release

# =============================================================================
# Stage 2: Runtime
# =============================================================================
FROM debian:trixie-slim AS runtime

RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -ms /bin/bash rustbin

WORKDIR /app

# Copy the compiled binary
COPY --from=builder /build/target/release/rustbin /app/rustbin

# Copy the example env as a default baseline (override at runtime)
COPY --from=builder /build/.env.example /app/.env.example

RUN chown -R rustbin:rustbin /app
USER rustbin

EXPOSE 3000

# Expects DATABASE_URL (and other env vars) to be set at runtime,
# either via --env-file, -e flags, or a mounted .env file.
CMD ["/app/rustbin"]
