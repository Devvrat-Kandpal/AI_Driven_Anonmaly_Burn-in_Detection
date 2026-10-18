@echo off
title Integration Test Server
cd /d "%~dp0"
echo ==========================================================================
echo   INTEGRATION TEST SERVER
echo ==========================================================================
python main.py
pause
