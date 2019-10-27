alphabet([49], 'A').
alphabet([50], 'B').
alphabet([51], 'C').
alphabet([52], 'D').
alphabet([53], 'E').
alphabet([54], 'F').
alphabet([55], 'G').
alphabet([56], 'H').
alphabet([57], 'I').
alphabet([49,48], 'J').
alphabet([49,49], 'K').
alphabet([49,50], 'L').
alphabet([49,51], 'M').
alphabet([49,52], 'N').
alphabet([49,53], 'O').
alphabet([49,54], 'P').
alphabet([49,55], 'Q').
alphabet([49,56], 'R').
alphabet([49,57], 'S').
alphabet([50,48], 'T').
alphabet([50,49], 'U').
alphabet([50,50], 'V').
alphabet([50,51], 'W').
alphabet([50,52], 'X').
alphabet([50,53], 'Y').
alphabet([50,54], 'Z').

valid_alpha('A').
valid_alpha('B').
valid_alpha('C').
valid_alpha('D').
valid_alpha('E').
valid_alpha('F').
valid_alpha('G').
valid_alpha('H').
valid_alpha('I').
valid_alpha('J').
valid_alpha('K').
valid_alpha('L').
valid_alpha('M').
valid_alpha('N').
valid_alpha('O').
valid_alpha('P').
valid_alpha('Q').
valid_alpha('R').
valid_alpha('S').
valid_alpha('T').
valid_alpha('U').
valid_alpha('V').
valid_alpha('W').
valid_alpha('X').
valid_alpha('Y').
valid_alpha('Z').

valid_char(48).
valid_char(49).
valid_char(50).
valid_char(51).
valid_char(52).
valid_char(53).
valid_char(54).
valid_char(55).
valid_char(56).
valid_char(57).

decodeNext([A,B|CodedCharlist]):-
    alphabet([A,B],Alpha),
    valid_alpha(Alpha),
    decodeNext(CodedCharlist).
decodeNext([A|CodedCharlist]):-
    alphabet([A],Alpha),
    valid_alpha(Alpha),
    decodeNext(CodedCharlist).
decodeNext([A,B]):-
    alphabet([A,B],Alpha),
    valid_alpha(Alpha).
decodeNext([A]):-
    alphabet([A],Alpha),
    valid_alpha(Alpha).

valid_code([A|CodeCharList]):-
    valid_char(A),
    valid_code(CodeCharList).

valid_code([]).

decode(Code, Possible):-
    string_to_list(Code,CodeCharList),
    write(CodeCharList),
    valid_code(CodeCharList),!,
    findall(CodeCharList, decodeNext(CodeCharList), CodeCharLists),
    length(CodeCharLists,Possible),
    write(CodeCharLists).

