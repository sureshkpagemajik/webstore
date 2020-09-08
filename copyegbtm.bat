@echo off

set pwd=%cd%
set source="C:\eGurkha\lib\apm\Java\default"

xcopy "%source%"  "%pwd%\Modules\customers\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\gateway\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\order\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\payment\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\products\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\quote\egbtm\" /s /Y
xcopy "%source%"  "%pwd%\Modules\webstore\egbtm\" /s /Y

echo copied to all Microservices.