@echo off

set pwd=%cd%
set source="/opt/egurkha/lib/apm/Java/default"
cp $source  "$pwd\Modules\customers\egbtm\" /s /Y
cp $source  "$pwd\Modules\customers\egbtm\" /s /Y
cp $source  "$pwd\Modules\customers\egbtm\" /s /Y
cp $source  "$pwd\Modules\gateway\egbtm\" /s /Y
cp $source  "$pwd\Modules\order\egbtm\" /s /Y
cp $source  "$pwd\Modules\payment\egbtm\" /s /Y
cp $source  "$pwd\Modules\products\egbtm\" /s /Y
cp $source  "$pwd\Modules\quote\egbtm\" /s /Y
cp $source  "$pwd\Modules\webstore\egbtm\" /s /Y

echo copied to all Microservices.