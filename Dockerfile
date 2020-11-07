FROM nginx

# Set working directory
WORKDIR /usr/app

# Install PM2 globally
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs htop python-certbot-nginx cron
RUN npm install --global pm2

# Copy "package.json" and "package-lock.json" before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY ./package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY ./ ./

# Build app
RUN npm run build

# Setup services
RUN rm /etc/nginx/conf.d/default.conf
ADD ./nginx.conf /etc/nginx/conf.d
ADD ./www.conf /etc/nginx/sites-available/default
ADD ./docker/ssl.crt /etc/nginx/ssl/ssl.crt
ADD ./docker/ssl.key /etc/nginx/ssl/ssl.key

EXPOSE 80
EXPOSE 443

RUN chmod +x ./start.sh
# Launch app with 
CMD ["./start.sh"]
