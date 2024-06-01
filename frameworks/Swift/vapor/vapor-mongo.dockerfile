# ================================
# Build image
# ================================
FROM swift:5.10 as build
WORKDIR /build

# Copy entire repo into container
COPY ./vapor-mongo .

RUN apt update
RUN apt-get -yqq install libssl-dev

# Compile with optimizations
RUN swift build \
	-c release \
	-Xswiftc -enforce-exclusivity=unchecked

# ================================
# Run image
# ================================
FROM swift:5.10-slim
WORKDIR /run

RUN apt update
RUN apt-get -yqq install libssl-dev

# Copy build artifacts
COPY --from=build /build/.build/release /run

# Copy Swift runtime libraries
COPY --from=build /usr/lib/swift/ /usr/lib/swift/

EXPOSE 8080

ENTRYPOINT ["./app", "serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
