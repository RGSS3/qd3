@echo off
SET QD3_BIN=%~dp0
for %%A in (%~dp0..) do SET QD3_HOME=%%~dpnA
call :setvar TEMPLATE     template

call :setvar BASE_DOCKER  vendor\docker
call :setvar BASE_HAXM    vendor\haxm
call :setvar BASE_PN      vendor\pn
call :setvar BASE_PUTTY   vendor\putty
call :setvar BASE_QD2     vendor\qd2
call :setvar BASE_QEMU    vendor\qemu
call :setvar BASE_RUBY    vendor\ruby

call :setvar ISO_B2D      vendor\docker\boot2docker.iso
call :setvar EXE_7ZA      vendor\7za\7za.exe
call :setvar EXE_ARIA2C   vendor\aria2c\aria2c.exe
call :setvar EXE_RUBY     vendor\ruby\bin\ruby.exe
call :setvar EXE_QEMU     vendor\qemu\qemu-system-x86_64.exe
exit /b
:setvar
set QD3_%1=%QD3_HOME%\%2