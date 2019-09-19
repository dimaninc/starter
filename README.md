# starter
diCMS project starter

## Usage:
`git clone https://github.com/testpilotco/starter.git Folder && sh Folder/scripts/init.sh`

## Warning Favicon and fonts
1. Create and convert here - https://realfavicongenerator.net
2. Convert font on all formats here - https://onlinefontconverter.com/
   format needed - (`ttf, woff, woff2, svg, eot, font-face`)
   
## Fonts and Images folder:
 - `htdocs/assets/fonts/dist` 
 - `htdocs/assets/images/dist`

## Localhost Start Project
link: https://github.com/testpilotco/di_core/blob/master/man/init.md

1. Let's say, our project is called project_name
   git clone `git@github.com:organization/project_name.git`
2. The root directory should point to `project_name/htdocs`
3. Console command:
   `composer install`
   `sh vendor/dimaninc/di_core/scripts/copy_core_static.sh`
   `sh vendor/dimaninc/di_core/scripts/create_work_folders.sh`
4. Create new file `/src/ProjectName/Data/Environment.php` :

   
    <?php
    namespace ProjectName\Data;
    
    class Environment extends \diCore\Data\Environment
    {
        const initiating = true;
    }  

5. Now type `http://project_name/_admin/` in browser **(mysql user should have login root and empty password)**
6. Then navigate to `http://project_name/_admin/db/` and click on Restore button near the latest DB dump
7. Add admins `http://project_name/_admin/admins/`
8. Clear cache in admin console
9. Open `/src/ProjectName/Data/Environment.php` in editor and comment out this line `const initiating = true`;

## Gulp build

1. Go to `{your_project_dir}/assets`, end execute commands -> `npm i`, -> `gulp build`