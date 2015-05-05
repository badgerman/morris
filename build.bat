@ECHO OFF
SET GAME=morris
"c:\Program Files\7-Zip\7z.exe" a %GAME%.zip conf.lua main.lua pieces-fixed.png zipclick.wav
rename %GAME%.zip %GAME%.love
mkdir dist
copy /b "c:\Program Files\LOVE\love.exe"+%GAME%.love dist\%GAME%.exe
copy "c:\Program Files\LOVE\*.dll" dist\
cd dist
"c:\Program Files\7-Zip\7z.exe" a %GAME%.zip %GAME%.exe *.dll
