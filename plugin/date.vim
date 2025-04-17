" date.vim

" WindowsのVimで+localtimeオプションが有効になっていなかったため自作
function! Strptime(date_str, format)
  let year = str2nr(matchstr(a:date_str, '\d\{4}'))
  let month = str2nr(matchstr(a:date_str, '-\zs\d\{2}\ze-'))
  let day = str2nr(matchstr(a:date_str, '-\zs\d\{2}\ze$'))

  return [year, month, day]
endfunction

function! DateDiff(date1, date2)
  let year1 = a:date1[0]
  let month1 = a:date1[1]
  let day1 = a:date1[2]
  let year2 = a:date2[0]
  let month2 = a:date2[1]
  let day2 = a:date2[2]

  let days1 = year1 * 365 + (month1 - 1) * 30 + day1
  let days2 = year2 * 365 + (month2 - 1) * 30 + day2

  return days1 - days2
endfunction