# To find all occurrences of the word `patricia' in a file:
       $ grep 'patricia' myfile
# To find all occurrences of the pattern `.Pp' at the beginning of a line:
       $ grep '^\.Pp' myfile
# The apostrophes ensure the entire expression is evaluated by grep instead of by the user's shell. # The caret `^' matches the null string at the beginning of a line, and the `\' escapes the `.', which# would otherwise match any character.
# To find all lines in a file which do not contain the words `foo' or `bar':
    $ grep -v -e 'foo' -e 'bar' myfile      
    $ grep -v 'foo\|bar' myfile       
    $ ls | egrep 'h|s'
# A simple example of an extended regular expression:
       $ egrep '19|20|25' calendar

-v 或 --revert-match : 显示不包含匹配文本的所有行。
ls | grep -v 'a\|g'   

-E 或 --extended-regexp : 将样式为延伸的普通表示法来使用。
ls | grep -E 'a\|g'

-e<范本样式> 或 --regexp=<范本样式> : 指定字符串做为查找文件内容的样式。
ls | grep -e 'a\|g'


hdfs dfsadmin -report | egrep 'DFS Used%' |  egrep 'DFS Used%' | cut -c12-16