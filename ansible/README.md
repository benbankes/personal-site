# Purpose: This ansible playbook is used to create/manage a static generated site with jekyll
**It is designed to be run on a Fedora 19 development VM**

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
- Supervisor

The playbook contains instructions for the following tasks:

- *Setup a development environment*
- *Setup continuous deployment to Amazon S3 (later)*
- *Setup a new, production server as a deployment target (to be added later)*

# Setup a development environment
**Run all commands as the linux user "root"**

1. Fire up a new Fedora 19 development VM

	- If you don't have one, you could use a spin, the default
	- https://archive.fedoraproject.org/pub/alt/releases/19/Spins/x86_64/
	- http://archive.fedoraproject.org/pub/archive/fedora/linux/releases/19/Fedora/x86_64/iso/
	- Perform the remaining steps on the new, VM

2. Install git and ansible

	`yum install git ansible`

3. Clone this repository into a new directory `var/www/html`

	`mkdir /var/www`
	`mkdir /var/www/html`
	`git clone https://github.com/benbankes/personal-site /var/www/html/dev.pencilinthehand.com`

4. Change to the folder containing this playbook

	`cd /var/www/html/dev.pencilinthehand.com/ansible`

5. Copy the example group variables and modify as necessary

	`cp group_vars/all.example group_vars/all`
	
	- The `linux_username` is the user that will be given ownership of the web files
	- Typically the user will already exist as the primary desktop user
	- Leave all other defaults unchanged

6. Run the ansible playbook

	`ansible-playbook -i hosts pencilinthehand.com.yml`

7. Restart the firewall manually
	
	`systemctl restart firewalld`
	
	- Ansible tries to do this, but may fail to due a bug

8. View the newly fired up Wordpress site in the browser installed in your VM

	- Changes you make to any files other than jekyll/_config.yml will be reflected live

9. If you need to make a change to jekyll/_config.yml, restart the supervisor service to reflect the changes on the site

	- `systemctl restart supervisord`

# Deploy to Amazon S3

1. Follow the Amazon S3 setup described at https://bryce.fisher-fleig.org/blog/setting-up-ssl-on-aws-cloudfront-and-s3/

2. As the user during `aws configure`, sync files up to S3

	- aws s3 sync jekyll/_site s3://s3.pencilinthehand.com