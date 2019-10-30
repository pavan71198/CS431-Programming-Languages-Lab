
/* Starter Category */
category('Corn Tikki', starter).
category('Tomato Soup', starter).
category('Chilli Paneer', starter).
category('Crispy chicken', starter).
category('Papdi Chaat', starter).
category('Cold Drink', starter).

/* Maindish Category */
category('Kadhai Paneer with Butter / Plain Naan', maindish).
category('Veg Korma with Butter / Plain Naan', maindish).
category('Murgh Lababdar with Butter / Plain Naan', maindish).
category('Veg Dum Biryani with Dal Tadka', maindish).
category('Steam Rice with Dal Tadka', maindish).

/* Desert Category */
category('Ice-cream', desert).
category('Malai Sandwich', desert).
category('Rasmalai', desert).

/* Calorie values for starters */
calorie('Corn Tikki', 30).
calorie('Tomato Soup', 20).
calorie('Chilli Paneer', 40).
calorie('Crispy chicken', 40).
calorie('Papdi Chaat', 20).
calorie('Cold Drink', 20).

/* Calorie values for maindish */
calorie('Kadhai Paneer with Butter / Plain Naan', 50).
calorie('Veg Korma with Butter / Plain Naan', 40).
calorie('Murgh Lababdar with Butter / Plain Naan', 50).
calorie('Veg Dum Biryani with Dal Tadka', 50).
calorie('Steam Rice with Dal Tadka', 40).

/* Calorie values for Dessert */
calorie('Ice-cream', 20).
calorie('Malai Sandwich', 20).
calorie('Rasmalai', 10).


selected([0,1]).

/* Deciding Number of Items to be selected for hungry */
menu(hungry,X,Y,Z):-
    selected(L),
    member(X, L),
    member(Y, L),
    member(Z, L),
    X+Y+Z =:= 3.

/* Deciding Number of Items to be selected for not so hungry */
menu(not_so_hungry,X,Y,Z):-
    selected(L),
    member(X, L),
    member(Y, L),
    member(Z, L),
    X+Z =:= 1.

/* Deciding Number of Items to be selected for diet */
menu(diet,X,Y,Z):-
    selected(L),
    member(X, L),
    member(Y, L),
    member(Z, L),
    X+Y+Z =:= 1.

/* Sum of Calories given the item list */
sum_of_calories([], _, Sum):-
    @>=(Sum, 0).
sum_of_calories([Item|Items], Category, Sum):-
    category(Item, Category),
    calorie(Item, Calorie),
    RemSum is Sum-Calorie,
    write(Item),
    sum_of_calories(Items, Category, RemSum).

/* Print all the items seperated by comma */
print_items([]).
print_items([Item|Items]):-
    write(Item),
    write(', '),
    print_items(Items).

/* Print item List */
print_items_list([]).
print_items_list([Items|ItemsList]):-
    write('Items:- '),
    print_items(Items),
    write('\n'),
    print_items_list(ItemsList).

/* Choosing Items over the several cases */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 3,
    findall([Item1, Item2, Item3], (category(Item1, starter), category(Item2, maindish), category(Item3, desert)), ItemsList),
    length(ItemsList,Len),
    write(Len),
    print_items_list(ItemsList).

/* for X+Y+Z = 2 and X = 0 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 2,
    X=:=0,
    findall([Item2, Item3], (category(Item2, maindish), category(Item3, desert), calorie(Item2, Cal2), calorie(Item3, Cal3), Cal2 + Cal3 =< 80), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 2 and Z = 0 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 2,
    Z=:=0,
    findall([Item1, Item2], (category(Item1, starter), category(Item2, maindish), calorie(Item1, Cal1), calorie(Item2, Cal2), Cal1+Cal2 =< 80), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and X = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    X=:=1,
    findall([Item1, Item2], (category(Item1, starter), category(Item2, starter), calorie(Item1, Cal1), calorie(Item2, Cal2), Item1 \== Item2, Cal1+Cal2 =< 40), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and Y = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    Y=:=1,
    findall([Item1, Item2], (category(Item1, maindish), category(Item2, maindish), calorie(Item1, Cal1), calorie(Item2, Cal2), Item1 \== Item2, Cal1+Cal2 =< 40), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and Z = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    Z=:=1,
    findall([Item1, Item2], (category(Item1, desert), category(Item2, desert), calorie(Item1, Cal1), calorie(Item2, Cal2), Item1 \== Item2, Cal1+Cal2 =< 40), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and X = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    X=:=1,
    findall([Item1], (category(Item1, starter), calorie(Item1, Cal1), Cal1 =< 40), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and Z = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    Y=:=1,
    findall([Item1], (category(Item1, maindish), calorie(Item1, Cal1), Cal1 =< 40), ItemsList),
    print_items_list(ItemsList).

/* for X+Y+Z = 1 and Z = 1 case */
choose_items(X, Y, Z, ItemsList):-
    X+Y+Z =:= 1,
    Z=:=1,
    findall([Item1], (category(Item1, desert), calorie(Item1, Cal1), Cal1 =< 40), ItemsList),
    print_items_list(ItemsList).

/* find_items function to get all the item values */
find_items(Status, X, Y, Z):-
    findall([Status, X, Y, Z, ItemsList], (menu(Status, X, Y, Z),choose_items(X, Y, Z, ItemsList)), TotalList),
    length(TotalList,Len),
    Len>0.

