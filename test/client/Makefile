
PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=./rebar

all:
	@$(REBAR) get-deps compile
clean:
	@$(REBAR) clean
remove:
	@$(REBAR) delete-deps 
get:
	@$(REBAR) get-deps 
publish:
	@$(REBAR) generate 



