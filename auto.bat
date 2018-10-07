@echo off
echo 传参范例：xxxx.bat 16 1 60 30 1
echo 对应关系请参考下面的文字：

set waitLoading=%1
echo 第一个参数：设置游戏Loading等待时间：%waitLoading%秒

set skipStartDiag=%2
echo 第二个参数：设置游戏开始时候是否跳过垃圾对白[会浪费2秒]：%skipStartDiag%

set waitTime=%3
echo 第三个参数：点击“自动”后一直到通关结算页面出现所需的时间(循环次数)：%waitTime%次【注：这里单位不是秒而是次，一次大概耗时1.5秒】

set roundGold=%4
echo 第四个参数：每局金币获取量：%roundGold% 供您参考已获取的金币数量

set selHero=%5
echo 第五个参数：选择哪个英雄作为主控英雄[1-3]：第%selHero%位

set num=1

rem 选择需要使用的设备，需要手动输入adb devices进行查看
set deviceName="emulator-5554"
:: set deviceName="78fe5719"

:start
echo =======================================
echo 第%num%次：

call :time totalStart

echo 点击“再次挑战”
adb -s %deviceName% shell input tap 1451 987

choice /t 3 /d y /n >nul

echo 点击“闯关”

rem 点击一下防沉迷提示
adb -s %deviceName% shell input tap 1245 768
choice /t 1 /d y /n >nul
adb -s %deviceName% shell input tap 1485 915

echo 等待读取游戏...
choice /t %waitLoading% /d y /n >nul

rem echo 取消废话..目前已经不需要
rem if %skipStartDiag% == 0 goto skipend
rem adb -s %deviceName% shell input tap 1877 96
rem :skipend

choice /t 1 /d y /n >nul

rem echo 点击“自动”
rem adb -s %deviceName% shell input tap 1790 68

rem 选择英雄
if %selHero% == 1 adb -s %deviceName% shell input tap 90 120
if %selHero% == 2 adb -s %deviceName% shell input tap 90 270
if %selHero% == 3 adb -s %deviceName% shell input tap 90 420

set fhloop=0
echo 开始自动取消废话阶段

call :time StartTime
echo 开始时间：%time%

:loop
choice /t 1 /d y /n >nul
adb -s %deviceName% shell input tap 1877 96
set /a fhloop+=1
if %fhloop% == %waitTime% goto end
echo|set /p=%fhloop%.
goto loop
:end
echo 循环结束！

call :time EndTime
echo 结束时间：%time%
set /a diffTime=%EndTime%-%StartTime%
set /a totalDiff=%EndTime%-%totalStart%
set /a perTick=%diffTime%/%waitTime%
echo 等待循环：%waitTime%次
echo 通关耗时：%diffTime%秒
echo 总耗时：%totalDiff%秒
set /a totalGold=%roundGold%*%num%
echo 总金币收入：%totalGold%
echo Finish!

set /a num=num+1
goto start

rem 获取当前时间戳
:time
setlocal
for /f "skip=1 tokens=1-9" %%a in ('wmic path win32_utctime ^| findstr .') do set /a m=%%e+9,m%%=12,y=%%i-m/10,t=365*y+y/4-y/100+y/400+(m*306+5)/10+%%a-719469,t=t*86400+%%c*3600+%%d*60+%%g
endlocal & set %1=%t% & goto :eof