@echo off

set FILENAME=%1
set PACKAGE=me.avatar.app
set TEMP_FILE=/data/local/tmp/mytempfile

@REM Note: Instead of using "mktemp", we use "touch" for 2 reasons:
@REM       * mktemp is not available on all API levels
@REM       * mktemp creates a file with 600 permission, meaning the file is not
@REM         accessible by processes running as "run-as"
adb shell "touch %TEMP_FILE%" || exit /b

@REM Copy file to temp directory.
adb shell "run-as %PACKAGE% cp /data/data/%PACKAGE%/%FILENAME% %TEMP_FILE%" || exit /b

@REM Pull from temp directory.
adb pull %TEMP_FILE% %FILENAME%
