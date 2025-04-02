This web app lets users input devices using a URL or IP range to monitor the ping received from every device.
The project can be built by pulling with the docker-compose file from dockerhub. If pulling does not work, you can also docker-compose build directly from the files given. The website will only work on the host computer. If you want access the website from a different device, download the Ping folder, go to /gui/next.confg.js, and add the host IP to allowedOrigins. Then, rebuild the images on your local machine.
 
SOFTWARE STACK:  
Docker  
MariaDB/MySQL  
Node.js, Javascript  
Next.js/React.js, Typescript  
TailwindCSS  
Nginx

