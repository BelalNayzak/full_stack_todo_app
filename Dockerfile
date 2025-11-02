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
