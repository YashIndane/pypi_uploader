# pypi_uploader
Bash script to upload Python module to pypi.org server

Create a directory with any name with the following structure

```
  .
  |__container
  |  |__<module_name>
  |  |  |__<file_1.py>
  |  |  |__  .
  |  |	|__  .	 
  |  |  |__<file_n.py>
  |  |__README.md
  |__pymod.sh
```  
  

Required Installations

1) git

```
$ yum insall git
```  

2) python3

```
$ yum install python3
```

Downloading the script and making the `pymod` command

```
wget https://raw.githubusercontent.com/YashIndane/pypi_uploader/main/pymod_installer.sh ; bash pymod_installer.sh
```

Executing the script

```
$ ./pymod.sh --github-username <GITHUB_USERNAME> --github-token <GITHUB_TOKEN>
    --pypi-username <PYPI-USERNAME> --pypi-password <PYPI-PASSWORD>
    --author-name <AUTHOR_NAME> --version <VERSION>
```    
    
