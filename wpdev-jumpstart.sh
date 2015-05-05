#!/bin/bash

# ============================================================================
# WPDev Jumpstart Script
# By David Green (@shycyborg) <david@shycyborg.com>
# https://github.com/shycyborg/wpdev-jumpstart-script
#
# Version. 0.7.0
#
# Run this script immediately after spinning up a new dev site
# with the the VVV Site Setup Script (https://github.com/aliso/vvv-site-wizard)
# ============================================================================


#
# Let's get some of the variables needed to locate the needed directories
# out of the way.
#


# Set this to the directory you have vagrant installed on your computer
VagrantDir=~/vagrant-local

# This is the directory of vagrant within the virtual machine
VirtualVagrantDir='/vagrant'

# This is the directory holding your custom setup files
# such as a starter theme and premium plugins that
# can't be downloaded from the WP plugin repository
CustomSetupFiles=~/Dropbox/Web-Dev-Backup/_CustomWPSetup

# Directory containing your starter theme, relative
# to the CustomSetupFilesDir directory
StarterTheme='xchildthemex'

# Your email domain to use for registering a new admin and author user
# If you enter bob as the admin name and shycyborg.com as your email
# domain then the admin user would use the email address bob@shycyborg.com
EmailDomain='shycyborg.com'


echo "Hello. I'm shy, and you probably don't like answering questions, so let's hurry through these few, simple questions.\nThat way I can finish the setup of your new dev site without delay.\n"

echo "What is the name of your site's directory? I don't need the full path."
read SiteDir

echo "\nWhat name should we use for the child theme directory? Please use all lowercase letters and no spaces."
read ThemeDir

echo "\nAnd what will the name of the child theme be?"
read ThemeName

echo "\nIt's best not to use admin as the username. What would you like the admin username to be?"
read AdminName
AdminPass=$(openssl rand -base64 10)

echo "\nWhy don't we create a user with the role of author for testing purposes.\nWhat would you like the author account's username to be?"
read AuthorName
AuthorPass=$(openssl rand -base64 10)


#
# Setup variables we'll need for regenerating wp-config.php
#

WPDBName="$(cat ${VagrantDir}/www/$SiteDir/htdocs/wp-config.php | grep DB_NAME | cut -d \' -f 4)"
WPDBUser="$(cat ${VagrantDir}/www/$SiteDir/htdocs/wp-config.php | grep DB_USER | cut -d \' -f 4)"
WPDBPass="$(cat ${VagrantDir}/www/$SiteDir/htdocs/wp-config.php | grep DB_PASSWORD | cut -d \' -f 4)"


#
# Let's copy some of the files we'll need into our site's directory
# before we SSH into vagrant.
#


# Genesis Framework
unzip ${CustomSetupFiles}/genesis.zip -d ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes

# Copy our starter theme into the site
cp -r ${CustomSetupFiles}/${StarterTheme} ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes

# Rename the child theme's folder
mv ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${StarterTheme} ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${ThemeDir}

# Use Perl to find/replace the name and functon prefixes in the theme
sed -i '' "s/xchildthemex/${ThemeDir}/g" ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${ThemeDir}/*.php
sed -i '' "s/xchildthemenamex/${ThemeName}/g" ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${ThemeDir}/style.css

# Now use find/replace to change the BrowserSync proxy in
# the child theme's Gruntfile.js
sed -i '' "s/xsiteaddressx/${ThemeDir}/g" ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${ThemeDir}/grunt/Gruntfile.js


# Unzip our premium and personal plugins into the dev site
# We will activate the plugins with WP-CLI later
# Currently you'll need to add a new line for each plugin

unzip ${CustomSetupFiles}/acfpro.zip -d ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/plugins

unzip ${CustomSetupFiles}/gravityforms.zip -d ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/plugins


# Let's step into the theme directory to run the setup
(
	cd ${VagrantDir}/www/${SiteDir}
	vagrant ssh -c "
	cd ${VirtualVagrantDir}/www/${SiteDir}/htdocs
	wp rewrite structure '/%postname%/'
	wp option set blog_public 0
	wp post delete 1 --force
	wp post delete 2 --force
	wp post create --post_type=page --post_title='Home' --post_status=publish
	wp post create --post_type=page --post_title='About' --post_status=publish
	wp post create --post_type=page --post_title='Blog' --post_status=publish
	wp post create --post_type=page --post_title='Contact' --post_status=publish
	wp widget delete search-2
	wp widget delete recent-posts-2
	wp widget delete recent-comments-2
	wp widget delete archives-2
	wp widget delete categories-2
	wp widget delete meta-2
	wp theme delete twentythirteen
	wp theme delete twentyfourteen
	wp theme update genesis
	wp theme activate ${ThemeDir}
	wp plugin delete hello
	wp plugin delete akismet
	wp plugin activate advanced-custom-fields-pro
	wp plugin activate gravityforms
	wp plugin install custom-post-type-ui --activate
	wp plugin install debug-bar --activate
	wp plugin install duplicate-post --activate
	wp plugin install duplicator --activate
	wp plugin install genesis-featured-content-widget --activate
	wp plugin install log-viewer --activate
	wp plugin install manual-image-crop --activate
	wp plugin install tabify-edit-screen --activate
	wp plugin install query-monitor --activate
	wp plugin install wordpress-seo --activate
	wp plugin install simple-image-widget --activate
	wp plugin install genesis-columns-advanced --activate
	wp plugin install widget-css-classes --activate
	wp plugin install disable-emojis --activate
	wp menu create 'Main Menu'
	wp menu location assign 'Main Menu' primary
	wp menu item add-post 'Main Menu' 3 --title='Home'
	wp menu item add-post 'Main Menu' 4 --title='About'
	wp menu item add-post 'Main Menu' 5 --title='Blog'
	wp menu item add-post 'Main Menu' 6 --title='Contact'
	wp option update page_on_front 3
	wp option update page_for_posts 5
	wp option update show_on_front page
	wp user create ${AdminName} ${AdminName}@${EmailDomain} --role=administrator --user_pass=${AdminPass}
	wp user create ${AuthorName} ${AuthorName}@${EmailDomain} --role=author --user_pass=${AuthorPass}
	wp user delete admin --reassign=2
	"
	cd ${VagrantDir}/www/${SiteDir}/htdocs/wp-content/themes/${ThemeDir}
	git init
	git add *
	git commit -m 'Initial commit'
	npm install
)

printf "\nSite Configuration completed. The summary is below:\n
Admin Username: ${AdminName}\n
Admin Password: ${AdminPass}\n
Author Username: ${AuthorName}\n
Author Password: ${AuthorPass}\n
Your license keys are below:\n
"

cat ${CustomSetupFiles}/licensekeys.txt