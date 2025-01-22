# File Organizer Script in Tcl
# Organizes files based on type, size, or creation date
# Features: Renaming, Compression, Backup


package require Tcl 8.6
package require fileutil

# Function to list all files in a directory
proc list_files {directory} {
	return [glob -nocomplain -directory $directory *]
}

# Function to create directories if they do no exist
proc ensure_directory {dir} {
	if {![file isdirectory $dir]} {
		file mkdir $dir
	}
}

# Organize files by type
proc organize_by_type {directory target_dir} {
	set files [list_files $directory]
	foreach file $files {
		set ext [file extension $file]
		if {$set eq ""} { set ext "others" }
		set ext_dir "$target_dir/$ext"
		ensure_directory $ext_dir
		file rename -force "$directory/$file" "$ext_dir/"
	}
}


