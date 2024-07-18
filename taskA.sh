#!/bin/bash

function OrganizeFiles () {
  # Check if the directory exists
  declare directory_path=$1
  if [ ! -d "$directory_path" ]; then
    echo "Directory does not exist: $directory_path"
   return 1
  fi

  for file in $directory_path/*; do
      if [ -f "$file" ]; then
         echo "Files found:$file"
         extension=`GetExtension $file`
        MakeDirectory "$extension" "$file" "$directory_path"
    
      else
      echo "No files found"
      fi
  done
}

function GetExtension () {
  declare file_name=$1
  declare extension=${file_name##*.}
  echo "$extension"
  return 0
}

function MakeDirectory () {
   # 1-Make sub-directory based on extension of files
   # 2-Move files to appropriate directory based on its extension
   declare extension=$1
  declare file_path=$2
  declare directory_path=$3
  case "${extension}" in
    txt)
     mkdir -p $directory_path/txt
     mv $file_path   $directory_path/txt
    ;;
    jpg)
     mkdir -p $directory_path/jpg
     mv $file_path $directory_path/jpg
    ;;
    pdf)
     mkdir -p  $directory_path/pdf
     mv $file_path  $directory_path/pdf
             
    ;;
    *)
     mkdir -p $directory_path/misc
    mv $file_path    $directory_path/misc

   ;;
esac  
return 0
}
 
function HiddenFiles () {
  # Find hidden files 
  declare directory_path=$1
  declare hidden_files=$(find "$directory_path" -type f -name ".*")
  if [ -n "$hidden_files" ]; then
    echo "Hidden files found:$hidden_files"
    for hidden_file in $hidden_files; do
      extension=$(GetExtension "$hidden_file")
      MakeDirectory "$extension" "$hidden_file" "$directory_path"
    done

  else
    echo "No hidden files found"
  fi
}

function main () { 
declare directory_path=$1
OrganizeFiles "$directory_path"
declare error=$(echo $?)
if (($error==1)); then
   exit 1
fi
HiddenFiles "$directory_path"
}
main "$1"