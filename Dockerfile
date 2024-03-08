# Use an official Node.js image as the base image for building the React app
FROM node:14-alpine as build

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app
RUN npm run build

# Use nginx to serve the built React app
FROM nginx:alpine

# Copy the built React app from the previous stage to the nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy nginx configuration file
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
