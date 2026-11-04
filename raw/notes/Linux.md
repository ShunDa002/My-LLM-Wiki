# Linux Directories
### /
- The **top-level/root directory** of the whole Linux filesystem.
- Everything in Linux is stored under `/`.
```
cd /
```

### /root
- The **home directory of the root user**.
- When you log in as `root`, Linux usually starts you in `/root`.
```
/root
```
- `~` means the current user's home directory.
- For `root`, `~` means `/root`.
```
cd /root
	OR
cd ~
```

### /home
Stores **normal users' home directories**.
```
/home/user1
/home/shonda
/home/test
```

/opt
- Stores **optional or third-party software**.
- Usually used for software installed outside the default OS packages.
```
opt/google/chrome

/opt/lampp

/opt/vmware

/opt/company_app
```


## diff
``` bash
	diff file1 file2
```
Example file
	old.txt:
``` text
	apple
	banana
	orange
```
	new.txt:
``` text
	apple
	banana
	grape
	orange
```
After run *diff old.txt new.txt* , the output:
``` text
	2a3
	> grape
```
		2a3 == after line 2 in old.txt, line 3 was added in new.txt
		> == line exists only in the second file
		< == line exists only in the first file
		| == line is different between both file