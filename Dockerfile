# Use the Dart SDK as the base image
FROM dart:stable AS build

# Create app directory
WORKDIR /app

# Copy everything from the repo (so both backend and shared are available)
COPY . .

# Move to backend folder
WORKDIR /app/packages/backend

# Get dependencies
RUN dart pub get

# Install dart_frog_cli globally
RUN dart pub global activate dart_frog_cli

# Add pub global executables to PATH
ENV PATH="$PATH:/root/.pub-cache/bin"

# Build the Dart Frog production files
RUN dart_frog build

# Use a smaller runtime image
FROM dart:stable AS runtime

WORKDIR /app

# Copy the built server from previous stage
COPY --from=build /app/packages/backend/build /app

EXPOSE 8080

# Run the Dart Frog server
CMD ["dart", "run", "bin/server.dart"]
