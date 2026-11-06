NAME := maxwell

.PHONY: all $(NAME) test clean fclean re

all: $(NAME)

$(NAME):
	dune build bin/$(NAME).exe
	cp -f _build/default/bin/$(NAME).exe $(NAME)

test:
	dune test

clean:
	dune clean

fclean: clean
	rm -f $(NAME)

re: fclean
	$(MAKE) all
