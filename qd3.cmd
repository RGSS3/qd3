@echo off
setlocal
if "%QD3_HOME%"=="" call %~dp0qd3vars.cmd
"%QD3_EXE_RUBY%" "%QD3_HOME%\bin\qd3.rb" %*