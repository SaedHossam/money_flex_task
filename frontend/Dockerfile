# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.29.2 AS build

# Create a non-root user
RUN adduser --disabled-password flutteruser

# Make the entire Flutter SDK accessible to flutteruser
RUN chown -R flutteruser:flutteruser /sdks/flutter

# Switch to flutteruser
USER flutteruser
WORKDIR /home/flutteruser/app

# Copy pubspec files first (for caching)
COPY --chown=flutteruser:root pubspec.yaml pubspec.lock ./

# Configure Git to trust the Flutter SDK directory
RUN git config --global --add safe.directory /sdks/flutter

# Disable animations for CI
RUN flutter config --no-cli-animations

# Get dependencies
RUN flutter pub get

# Copy the rest of the project files
COPY --chown=flutteruser:root . .

# Clean cached Windows paths (if needed)
RUN rm -rf .dart_tool

# Build for web (release mode)
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /home/flutteruser/app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]