# ---- Build stage ----
    FROM dart:stable AS build

    WORKDIR /app
    COPY . .
    
    # Get dependencies
    RUN dart pub get
    
    # Build Dart Frog production files
    RUN dart_frog build
    
    # ---- Run stage ----
    FROM dart:stable
    WORKDIR /app
    
    COPY --from=build /app/build .
    
    # Render will inject PORT dynamically
    ENV PORT=8080
    EXPOSE 8080
    
    CMD ["dart", "bin/server.dart"]
    