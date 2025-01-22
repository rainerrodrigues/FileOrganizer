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

# Organize files by size
proc organize_by_size {directory target_dir} {
	set files [list_files $directory]
	foreach file $files {
		set size [file size "$directory/$file"]
		if {$size < 1024} {
			set size_category "small"
		} elseif {$size < 1048576} {
			set size_category "medium"
		} else {
			set size_category "large"
		}
		set size_dir "$target_dir/$size_category"
		ensure_directory $size_dir
		file rename -force "$directory/$file" "$size_dir/"
	}
}

# Organize files by creation date
proc organize_by_date {directory target_dir} {
	set files [list_files $directory]
	foreach file $files {
		set ctime [file attributes "$directory/$file" -creationtime]
		set date_dir "$target_dir/[clock format $ctime -format %Y-%m-%d]"
		ensure_directory $date_dir
		file rename -force "$directory/$file" "$date_dir/"
	}
}

# Backup files by compressing them into a .tar.gz archive
proc backup_files {directory backup_file} {
	set files [list_files $directory]
	set tar_cmd "tar -czf $backup_file -C $directory ."
	exec $tar_cmd
}

