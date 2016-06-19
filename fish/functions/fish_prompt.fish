function fish_prompt
   set stat $status
   if test $stat -ne 0
    printf "%s[%s]%s" (set_color red) "$stat" (set_color normal)
   end

   set_color yellow
   printf '%s' (whoami)
   set_color normal
   printf '@'

   set_color magenta
   printf '%s' (hostname|cut -d . -f 1)
   set_color normal
   printf ' '

   set_color $fish_color_cwd
   printf '%s' (prompt_pwd)
   set_color normal

   # Line 2
   if test $VIRTUAL_ENV
       printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
   end
   set_color normal
end
