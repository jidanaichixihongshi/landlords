cd ../etc
erl ^
	+K true ^
	-pa ../ebin edit ../deps/*/ebin ^
	-name landlords@127.0.0.1 ^
	-setcookie landlords_server ^
	-s landlords ^
	
	