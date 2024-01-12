# Stage 1: Build the React application
FROM node:18.17.1 as build

# Set the working directory in the Docker image
WORKDIR /app

# Copy package.json and package-lock.json for the client
COPY client/package*.json ./client/

# Install client dependencies
WORKDIR /app/client
RUN npm install

# Copy the client source code and build the React application
COPY client/ .
RUN npm run build

# Stage 2: Set up the Express server
FROM node:18.17.1

# Set the working directory for the server
WORKDIR /server

# Copy server files
COPY server/package*.json ./
RUN npm install --only=production

# Copy the built React app from the build stage and the server files
COPY --from=build /app/client/dist ../client/dist
COPY server/ .

# Expose the port the server is running on
EXPOSE 3000

# Command to run the Express server
CMD ["node", "server.js"]