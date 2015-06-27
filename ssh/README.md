# .ssh folder
Content will be copied to jenkins user `~/.ssh/` folder. It should contain:
 * `id_rsa` private key
 * `known_hosts` file
 
## build keys:

~~~bash
# genreate with empty password
ssh-keygen -t rsa -C "your_email@example.com" -f id_rsa
~~~

