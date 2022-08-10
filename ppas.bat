@echo off
SET THEFILE=d:\worksp~1\parser\progra~1.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  D:\WORKSP~1\Parser\rsrc.o -s   -b base.$$$ -o d:\worksp~1\parser\progra~1.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
