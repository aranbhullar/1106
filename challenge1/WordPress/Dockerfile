# Use the official WordPress image from the Docker Hub
FROM wordpress:latest

# Set environment variables for WordPress
ENV WORDPRESS_DB_HOST=mysql.example.com
ENV WORDPRESS_DB_USER=wordpress_user
ENV WORDPRESS_DB_PASSWORD=secure_password
ENV WORDPRESS_DB_NAME=wordpress_db

# Expose the port that WordPress runs on
EXPOSE 80

# The entrypoint script to run WordPress
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
