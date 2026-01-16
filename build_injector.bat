@echo off
echo ========================================
echo   Building GTFOHax Complete Package
echo ========================================
echo.

REM Check if DLL already exists
echo [STEP 1/4] Checking for existing DLL...
set DLL_EXISTS=0
set DLL_FILE=

REM Try to find versioned DLL first
for %%f in (x64\Release\GTFOHax-v*.dll) do (
    set DLL_EXISTS=1
    set DLL_FILE=%%f
    echo [INFO] Found versioned DLL: %%f
)

REM If no versioned DLL, check for plain DLL
if %DLL_EXISTS%==0 (
    if exist "x64\Release\GTFOHax.dll" (
        set DLL_EXISTS=1
        set DLL_FILE=x64\Release\GTFOHax.dll
        echo [INFO] Found plain DLL: x64\Release\GTFOHax.dll
    )
)

if %DLL_EXISTS%==0 (
    echo [ERROR] DLL not found in x64\Release\
    echo [INFO] Please build the DLL first using Visual Studio
    pause
    exit /b 1
)

echo [INFO] Using DLL: %DLL_FILE%
echo.

REM Step 2: Extract version from PropertySheet.props
echo [STEP 2/4] Extracting version number...
set VERSION=
for /f "tokens=3 delims=<>" %%a in ('findstr /r "<LibraryVersion>[0-9]" GTFOHax\PropertySheet.props') do set VERSION=%%a
if "%VERSION%"=="" (
    echo [ERROR] Failed to extract version number
    pause
    exit /b 1
)
echo [INFO] Version: %VERSION%
echo.

REM Step 3: Copy DLL to a fixed name for resource embedding
echo [STEP 3/4] Preparing DLL for embedding...
copy /Y "%DLL_FILE%" "GTFOHax.dll" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy DLL
    pause
    exit /b 1
)

REM Initialize Visual Studio environment
echo [INFO] Initializing Visual Studio environment...
call "D:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
if errorlevel 1 (
    echo [ERROR] Failed to initialize Visual Studio environment
    pause
    exit /b 1
)

REM Compile resource file - use full path to rc.exe
echo [INFO] Compiling resource file...
"D:\Windows Kits\10\bin\10.0.26100.0\x64\rc.exe" injector.rc >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to compile resource file
    echo [INFO] Make sure rc.exe is available at D:\Windows Kits\10\bin\10.0.26100.0\x64\rc.exe
    pause
    exit /b 1
)

REM Step 4: Compile injector with version in filename
echo [STEP 4/5] Compiling GTFOHax-Injector-v%VERSION%.exe...
"D:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x64\cl.exe" /nologo /std:c++20 /EHsc /O2 /MD /Fe:GTFOHax-Injector-v%VERSION%.exe injector.cpp injector.res /link user32.lib /SUBSYSTEM:WINDOWS /MACHINE:X64
if errorlevel 1 (
    echo [ERROR] Compilation failed
    pause
    exit /b 1
)

REM Cleanup temporary files
del /Q injector.obj injector.res GTFOHax.dll 2>nul
echo.

REM Step 6: Compress with UPX
echo [STEP 5/5] Compressing with UPX...
where upx >nul 2>&1
if errorlevel 1 (
    echo [WARNING] UPX not found in PATH, skipping compression
    echo [INFO] Download UPX from: https://upx.github.io/
) else (
    upx --best --lzma GTFOHax-Injector-v%VERSION%.exe
    if errorlevel 1 (
        echo [WARNING] UPX compression failed, keeping uncompressed version
    ) else (
        echo [OK] Compression successful
    )
)

echo.
echo ========================================
echo   Build Complete!
echo ========================================
echo.
echo Output files:
echo   - x64\Release\GTFOHax-v%VERSION%.dll
echo   - GTFOHax-Injector-v%VERSION%.exe (DLL embedded, UPX compressed)
echo.
pause

