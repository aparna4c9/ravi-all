FROM tomcat:latest
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get clean
RUN echo "THIS IS APPU" > /var/www/html/index.htm
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]

