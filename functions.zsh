functions_dir=${HOME}/.zshfunctions

if [[ -d $functions_dir ]]; then
  fpath=($functions_dir $fpath)
  for function_file in $functions_dir/*; do
    autoload -Uz ${function_file##*/} || printf "Autoloading $function_file failed\n"
  done
else
  echo "no $functions_dir exists"
fi

# OS-specific functions are sourced via zshrc's source-for-os
