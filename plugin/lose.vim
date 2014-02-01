function! lose#findFile(name, ...)
   let rawPath = &path
   let pathDir = substitute(rawPath, "**", "", "g")
   " find command takes space-separated paths, vim uses commas
   let pathDir = substitute(pathDir, ",", " ", "g")

   " If the search pattern has a / or * then we want to match on whole-name
   " so path-parts are matched.
   let matchWholeName = match(a:name, '[*/]') >= 0
   let fieldName = matchWholeName ? 'wholename' : 'name'

   " If the search pattern is all lowercase, make the search case insensitive
   if tolower(a:name) ==# a:name
      let fieldName = 'i'.fieldName
   endif

   " Lets be safe about this
   let name = shellescape('*'.a:name.'*')
   let exclusions = lose#getFileExclusions()
   let otherOptions = exclusions . ' ' . ' -type f'
   let findCmd = 'find '.pathDir.' -'.fieldName.' '.name.otherOptions
   let findOutput = system(findCmd)
   let matchedFiles = split(findOutput, "\n")

   if len(matchedFiles) == 0
      echo 'Cannot find file "'.a:name.'" in path.'
      return
   elseif len(matchedFiles) == 1
      let fileToOpen = matchedFiles[0]
   else
      let i = 1
      for file in matchedFiles
         echo i."\t".file
         let i+= 1
      endfor

      let selection = str2nr(input("Which file number? "))

      if selection < 1
         " Any non-numeric input to str2nr becomes 0 which we now convert to 1.
         let selection = 1
      elseif selection > len(matchedFiles)
         echo selection." is out of range!"
         return
      endif

      let fileToOpen = matchedFiles[selection-1]
   endif

   return fileToOpen
endfunc

function! lose#lose(name, ...)
   execute "e ".lose#findFile(a:name)

   " The second argument, if provided, is the line number to jump to.
   if a:0 > 0
      execute "normal ".a:1."G"
   endif
endfunc

function! lose#tablose(name, ...)
   execute "tabe ".lose#findFile(a:name)

   " The second argument, if provided, is the line number to jump to.
   if a:0 > 0
      execute "normal ".a:1."G"
   endif
endfunc

" Returns a string that GNU find can use to exclude files.
function! lose#getFileExclusions()
   let exclusions = ' -not -name "*.sw?" -not -wholename "*/.git/*" '

   " Include wildignore files too.
   for file in split(&wildignore, ',')
      let exclusions = exclusions . ' -not -name ' . shellescape(file) . ' '
   endfor

   return exclusions
endfunc

command! -nargs=* Lose call lose#lose(<f-args>)
command! -nargs=* TabLose call lose#tablose(<f-args>)
