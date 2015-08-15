# Purpose: This ansible playbook is used to create/manage a static generated site with jekyll
**It is designed to be run on a production CentOS 7 server or a Fedora 19 development VM**

The playbook sets up and manages a single LAR stack with the required:

- Packages
- Linux users
- Web permissions
- Apache configuration
- Firewall rules
- Hostname
- DNS rules

It configures, starts, and enables the following required services to run on boot:

- Fail2ban
- Apache

The playbook contains instructions for the following tasks:

- *(TODO starting here)*

# To setup Wordpress on a new server or VM
**Run all commands as the linux user "root"**

1. Fire up a new CentOS 7 server or Fedora 19 development VM

	- If you are not using a cloud host or a development box, setup a static IP
	- If you don't know how, ask
	- Perform the remaining steps on the new, VM or server

2. For a production server, change the root password to match the one on file

3. Install the extra packages for enterprise linux (not for Fedora)

	`yum install epel-release`

4. Install git

	`yum install git`

5. Install ansible

	`yum install ansible`

6. Clone this repository into the root directory

	`git clone https://bitbucket.org/smallbn/new-wordpress.git /root/ansible`

8. Change to the folder containing this playbook

	`cd /root/ansible`

9. Copy the example group variables and modify as necessary

	`cp /root/ansible/group_vars/all.example /root/ansible/group_vars/all`
	
	eg. If the new server is a production server, the "is_production" group variable should be "1".

11. Place the two certificate files and the one key file into the folder `roles/web/files`
	
12. Run the ansible playbook

	`ansible-playbook -i hosts pencilinthehand.com.yml`

14. Restart the firewall manually
	
	`systemctl restart firewalld`
	
	- Ansible tries to do this, but may fail to due a bug

15. Modify DNS (either your personal hosts file or public DNS) to view the newly fired up Wordpress site

16. Go through the procedure **To continue using ansible configuration management of the new site/server**
	
	Why?  See the last line of that procedure.
	
17. Make the `bu` user the owner of the ansible playbook

	`chown bu /root/ansible -R`

18. Add a scheduled task to the rsync server to backup the site

# To continue using Ansible for configuration management of the new site/server
**Run all commands as the linux user "root"**
**This procedure has not been tested yet**

1. Change to the folder containing this playbook

	`cd /root/ansible`

2. Remove git-specific directories

	`rm .git -Rf`
	`rm .gitignore`
	`rm roles/web/files/.gitignore`
	
3. Remove the file `new-wordpress.yml` from the playbook

	`rm roles/web/tasks/new-wordpress.yml`
	
	Also, remove the line `- include: new-wordpress.yml` from the file `roles/web/tasks/main.yml`
	
3. Rename example.com.yml with the hostname of the new site

	`mv example.com <hostname>`
	
	Where <hostname> is the the hostname of the new site

4. Make a new repository at bitbucket.org (following their procedure) and push the repository up to bitbucket.org

5. After doing this, any modifications to this playbook can be put into effect by running the playbook

	`ansible-playbook -i hosts <hostname>.yml --extra-vars "set_mysql_root_password=0 mysql_root_password=your_password"`
	
	Where <hostname>.yml is the filename of the only yaml file in the root of the repository, renamed from example.com.yml
