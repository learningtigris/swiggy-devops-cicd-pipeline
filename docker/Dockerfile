# Use Node.js 20 LTS
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source code
COPY . .

# Build React application
RUN npm run build

# Expose application port
EXPOSE 3000

# Start application
CMD ["npm", "start"]