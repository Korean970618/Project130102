:begin
set month=%date:~5,2%
set day=%date:~8,2%
set ti1=%time:~0,2%
set ti2=%time:~3,2%
set ti3=%time:~6,2%
copy server_log.txt "_logs\%month%�� %day%�� %ti1%�� %ti2%�� %ti3%��.txt"
del server_log.txt
samp-server.exe
goto begin