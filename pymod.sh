#!/usr/bin/bash

ARGS=$(getopt -a --options a:b:c:d:e:v: --long "github-username:,github-token:,pypi-username:,pypi-password:,author-name:,version:" -- "$@")

eval set -- "$ARGS"

while true; do
        case "$1" in
                -a|--github-username)
                        GITHUB_USERNAME="$2"
                        shift 2;;
                -b|--github-token)
                        GITHUB_TOKEN="$2"
                        shift 2;;
                -c|--pypi-username)
                        PYPI_USERNAME="$2"
                        shift 2;;
		-d|--pypi-password)
			PYPI_PASSWORD="$2"
			shift 2;;
                -e|--author-name)
                        AUTHOR_NAME="$2"
                        shift 2;;
                -v|--version)
                        VERSION="$2"
                        shift 2;; 			
                --)
                  break;;
        esac
done

echo "$GITHUB_USERNAME $GITHUB_TOKEN $PYPI_USERNAME $PYPI_PASSWORD $AUTHOR_NAME $VERSION"


sudo python3 -m pip install --upgrade pip
sudo pip3 install wheel
sudo pip3 install --upgrade setuptools
echo 'Y' | sudo pip3 uninstall twine
sudo pip3 install twine
echo 'Y' | sudo pip3 uninstall urllib3
sudo pip3 install urllib3

sudo touch container/__init__.py

#Getting the module directory name
declare -a dirs
i=1
cd container
for d in */
do
	dirs[i++]="${d%/}"
done

module_dir=${dirs[1]}

cd $module_dir

# Reading file names
while read line
do
       
	# Getting file name
	filename=$(echo $line | awk '{ print $10 }')

	# Removing file extension
	filename=$(echo $filename | cut -f 1 -d '.')
        
	if [ ! -z $filename ]
	then    
		# Editing the file
		echo "from $module_dir.$filename import *" >> ../__init__.py
        fi

	((i++))

done < <(ls -ls)

mv ../__init__.py .

cd ..

# Creating the LICENSE.txt
sudo touch LICENSE.txt

sudo echo "MIT License

Copyright (c) 2021 $AUTHOR_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE." >> LICENSE.txt

# Creating setup.py file
sudo touch setup.py

sudo echo "import setuptools

with open('README.md' , 'r') as f:
    long_description = f.read()

setuptools.setup(
      name='$module_dir',
      version='$VERSION',
      author='$AUTHOR_NAME',
      author_email='',
      description='',
      long_description=long_description,
      long_description_content_type='text/markdown',
      url='https://github.com/$GITHUB_USERNAME/$module_dir',
      packages=setuptools.find_packages(),
      classifiers=[
          'Programming Language :: Python :: 3',
          'License :: OSI Approved :: MIT License',
          'Operating System :: OS Independent',
      ],
      python_requires='>=3.6',
)" >> setup.py

# Making the GiHub repository
sudo curl https://$GITHUB_USERNAME:$GITHUB_TOKEN@api.github.com/user/repos -d '{"name":"'$module_dir'","private":false}'

# Initialize git
sudo git init

# Adding to staging
sudo git add .

# Making the commit
sudo git commit -m "first commit"

# Getting to main branch
sudo git branch -M main

#
sudo git remote add origin https://github.com/$GITHUB_USERNAME/$module_dir.git

# Push the code
sudo git push https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$module_dir.git --all

# Compiling setup.py file
sudo python3 setup.py sdist bdist_wheel

# Upload module to pypi.org
sudo python3 -m twine upload --repository-url https://upload.pypi.org/legacy/ dist/* -u $PYPI_USERNAME -p $PYPI_PASSWORD
