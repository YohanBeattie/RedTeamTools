# RedTeamTools
Gathering all kinds of homemade redteam tools

## RTLO
Right-to-Left Override (RLO) is a non-printing Unicode character [U+202e] mainly used to support Hebrew and Arabic languages. Indeed, this character flips and changes all subsequent text to be right-to-left when displayed, instead of English’s left-to-right reading order. It is a character interpreted by windows and Linux in the display of filename for example. 
Indeed a file named "test\u202Excod.exe" while be diplayed as "testexe.docx". 
The script rtlo.sh build a executable document. Run `./rtlo.sh -h` for more.
Limits : For it to be displayed correctly, the file displayer must include extensions. Here are some interresting icons : https://developer.microsoft.com/en-us/fluentui#/styles/web/file-type-icons

