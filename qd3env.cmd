@echo off
setlocal
if "%QD3_HOME%"=="" call %~dp0qd3vars.cmd
%QD3_BASE_CMDER%\cmder.exe /c %cd%