![](https://img.shields.io/badge/-BASH-yellowgreen?style=flat&logo=shell)

# pypi_uploader
A command to upload Python module to pypi.org server

Create a directory anywhere with name `container` with the following structure

```
  
     container
     |__<module_name>
     |  |__<file_1.py>
     |  |__  .
     |	|__  .	 
     |  |__<file_n.py>
     |__README.md
 
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

Run the following command to download the script and making the `pymod` command

```
$ wget https://raw.githubusercontent.com/YashIndane/pypi_uploader/main/pymod_installer.sh ; bash pymod_installer.sh
```

Usage

Be in same directory where the `container` directory is present and execute following command-

```
$ pymod --github-username <GITHUB_USERNAME> --github-token <GITHUB_TOKEN>
  --pypi-username <PYPI-USERNAME> --pypi-password <PYPI-PASSWORD>
  --author-name <AUTHOR_NAME> --version <VERSION>
```
