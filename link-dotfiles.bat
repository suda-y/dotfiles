@ECHO OFF
IF "%OS%" == "Windows_NT" goto WinNT
ECHO Not Windows
GOTO End

:WinNT
IF NOT DEFINED HOME (
	ECHO not defined %%HOME%%
) ELSE (
	CD %CD%
	FOR %%f in (.profile .w3m\bookmark.html .emacs.d\Makefile .emacs.d\INIT.org) DO (
		IF EXIST %HOME%\%%f (
			ECHO DEL %HOME%\%%f
		)
		ECHO filename = %%f
		ECHO mklink /D %HOME%\%%f %CD%\%%f
	)
)
:End
