# wpdev-jumpstart-script
A bash script that utilizes WP-CLI to configure a fresh Varying Vagrant Vagrants dev site install (I'm currently using https://github.com/aliso/vvv-site-wizard) and prepare my starter child theme.
**I'm still working on this, but feel free to take it and customize it for your own development workflow.**
## What the script does, in a nutshell
*Currently...*

- Asks 5 questions in order to establish the dev site we'll be working on and the user accounts to create.
- Generates random passwords for a new administrator and author account to be created later
- Unzip a copy of the Genesis framework into the dev site
- Copy my genesis starter theme into the dev site (will clone from Github later on)
- Prepare the child theme for this specific site
  - Rename the child theme's folder based on the theme name provided during the prompts
  - Customize the function prefixes and theme name in functions.php
- Change the BrowserSync proxy in the theme's Gruntfile.js
- Unzip copies of my premium plugins (ACF Pro and Gravity Forms) into the dev site's plugin folder.
- Set the site's permalink structure to using postname
- Set the site to discourage search engines from indexing (Settings > Reading > Search Engine Visibility)
- Delete the default post and page WordPress creates on install
- Creates blank Home, About, Blog, and Contact pages
- Deletes all the default widgets in the sidebar
- Delete the Twenty Thirteen and Twenty Fourteen themes
- Delete the Hello Dolly and Akismet plugins
- Activate ACF Pro and Gravity Forms
- Install plugins I use on most sites
  - Custom Post Type UI
  - Debug Bar
  - Duplicate Post
  - Duplicator
  - Genesis Sandbox Featured Content Widget
  - Log Viewer
  - Manual Image Crop
  - Tabify Edit Screen
  - Query Monitor
  - WordPress SEO
- Create a new menu named 'Main Menu' and assign it to the primary menu location in the theme
- Assign the pages created earlier to the new menu
- Set the Front Page to Home and Blog page to Blog (Settings > Reading > Front page displays)
- Creates the administrator and author accounts with the names you provided during the prompts
- Deletes the default admin account and reassigns anything it's the author of to the new administrator account
- Initialize a new git repository in the child theme directory with git init
- Add the theme's files to git (ignoring that specified in the .gitignore file)
- Perform an initial git commit of the theme files
- Run npm install so the grunt tasks will be ready to run
- Display the username/passwords for the administrator and author accounts created
- Display the contents of the licensekeys.txt file located in the same directory as the other CustomSetupFiles. I use this to have my premium plugin license keys handy for entering as soon as I login the site.

## How to Use
I'll put more thorough information here later, but in a nutshell you execute the bash script and answer the prompts it provides. Then sit and wait a couple minutes until it says it's completed and shows you the summary.
