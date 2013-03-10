:begin
set month=%date:~5,2%
set day=%date:~8,2%
set ti1=%time:~0,2%
set ti2=%time:~3,2%
set ti3=%time:~6,2%
copy server_log.txt "_logs\%month%월 %day%일 %ti1%시 %ti2%분 %ti3%초.txt"
del server_log.txt
samp-server.exe
goto begin