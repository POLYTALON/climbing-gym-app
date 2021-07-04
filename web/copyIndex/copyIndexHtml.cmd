@echo off
IF %1 EQU productive (
    echo copy Productive Index.html to the web root folder!
    copy web\productive\index.html web\index.html
    goto :end
) ELSE (
    IF %1 EQU development (
        echo copy Development Index.html to the web root folder!
        copy web\development\index.html web\index.html
	goto :end
    ) ELSE (
       echo Sorry, wrong argument, please try again
       goto :getError
    )
)
goto :end

:getError
exit /b 1

:end
exit /b 0
