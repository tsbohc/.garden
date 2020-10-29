# Group a list of commands as a database transaction

2 | 1603789275.0

When I worked with disk files, I needed to remove the old files and copy the updated files. However, if there is something wrong during the removal or copying procedure, the target files are not consistent with the original files.

Is there any method to group a list of commands as a database transaction to make sure the files on different directories are consistent?