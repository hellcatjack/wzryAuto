@echo off
echo ���η�����xxxx.bat 16 1 60 30 1
echo ��Ӧ��ϵ��ο���������֣�

set waitLoading=%1
echo ��һ��������������ϷLoading�ȴ�ʱ�䣺%waitLoading%��

set skipStartDiag=%2
echo �ڶ���������������Ϸ��ʼʱ���Ƿ����������԰�[���˷�2��]��%skipStartDiag%

set waitTime=%3
echo ������������������Զ�����һֱ��ͨ�ؽ���ҳ����������ʱ��(ѭ������)��%waitTime%�Ρ�ע�����ﵥλ��������ǴΣ�һ�δ�ź�ʱ1.5�롿

set roundGold=%4
echo ���ĸ�������ÿ�ֽ�һ�ȡ����%roundGold% �����ο��ѻ�ȡ�Ľ������

set selHero=%5
echo �����������ѡ���ĸ�Ӣ����Ϊ����Ӣ��[1-3]����%selHero%λ

set num=1

:: set deviceName="emulator-5554"
set deviceName="78fe5719"

:start
echo =======================================
echo ��%num%�Σ�

call :time totalStart

echo ������ٴ���ս��
adb -s %deviceName% shell input tap 967 658

choice /t 3 /d y /n >nul

echo ��������ء�

rem ���һ�·�������ʾ
adb -s %deviceName% shell input tap 830 512
choice /t 1 /d y /n >nul
adb -s %deviceName% shell input tap 990 610

choice /t %waitLoading% /d y /n >nul

echo ȡ���ϻ�
if %skipStartDiag% == 0 goto skipend
adb -s %deviceName% shell input tap 1251 64
:skipend

choice /t 1 /d y /n >nul

echo ������Զ���
rem adb -s %deviceName% shell input tap 1193 45

rem ѡ��Ӣ��
if %selHero% == 1 adb -s %deviceName% shell input tap 60 80
if %selHero% == 2 adb -s %deviceName% shell input tap 60 180
if %selHero% == 3 adb -s %deviceName% shell input tap 60 280

set fhloop=0
echo ��ʼ�Զ�ȡ���ϻ��׶�

call :time StartTime
echo ��ʼʱ�䣺%time%

:loop
choice /t 1 /d y /n >nul
adb -s %deviceName% shell input tap 1251 64
set /a fhloop+=1
if %fhloop% == %waitTime% goto end
goto loop
:end

call :time EndTime
echo ����ʱ�䣺%time%
set /a diffTime=%EndTime%-%StartTime%
set /a totalDiff=%EndTime%-%totalStart%
set /a perTick=%diffTime%/%waitTime%
echo �ȴ�ѭ����%waitTime%��
echo ͨ�غ�ʱ��%diffTime%��
echo �ܺ�ʱ��%totalDiff%��
set /a totalGold=%roundGold%*%num%
echo �ܽ�����룺%totalGold%
echo Finish!

set /a num=num+1
goto start

rem ��ȡ��ǰʱ���
:time
setlocal
for /f "skip=1 tokens=1-9" %%a in ('wmic path win32_utctime ^| findstr .') do set /a m=%%e+9,m%%=12,y=%%i-m/10,t=365*y+y/4-y/100+y/400+(m*306+5)/10+%%a-719469,t=t*86400+%%c*3600+%%d*60+%%g
endlocal & set %1=%t% & goto :eof