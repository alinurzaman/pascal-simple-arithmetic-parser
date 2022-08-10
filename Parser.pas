program Parser;
uses crt;
label ATAS;
var
   x:text;
   y:char;
   nama:string;
   token, Ttoken:string;
   larik:array[1..100] of string;
   i,j:integer;
   error:boolean;
   id:byte;

procedure input;
begin
     read(x,y);
end;

procedure scan;
begin
     clrscr;
     write('Masukkan nama file (.pas) : '); readln(nama);
     writeln();
     assign(x,nama);
     reset(x);
     i:=0;
     while not eof(x) do
     begin
           input;

           if(y in ['A'..'Z', 'a'..'z']) then
           begin
                repeat
                      token:=token+y;
                      input;
                until (not(y in ['A'..'Z', 'a'..'z']));
           Ttoken := 'T_NAME';
           if token = 'program' then Ttoken := 'T_PROGRAM';
           if token = 'uses' then Ttoken := 'T_USES';
           if token = 'begin' then Ttoken := 'T_BEGIN';
           if token = 'end' then Ttoken := 'T_END';
           if token = 'div' then Ttoken := 'T_DIV';
           if token = 'mod' then Ttoken := 'T_MOD';
           if token = 'integer' then Ttoken := 'T_INT';
           if token = 'var' then Ttoken := 'T_VAR';
           inc(i);
           larik[i] := Ttoken;
           token := '';
           end;

           if(y in['0'..'9']) then
           begin
                repeat
                      token := token + y;
                      input;
                until (not(y in ['0'..'9']));

                Ttoken := 'T_KONSTANTA';
                inc(i);
                larik[i] := Ttoken;
                token := '';
           end;

           if(y in[':','=',';','.','*','/','+','-']) then
           begin
                repeat
                      token := token + y;
                      input;
                until (not(y in [':','=',';','.','*','/','+','-']));

                if token = ':' then Ttoken := 'T_IS';
                if token = ':=' then Ttoken := 'T_ASSIGN';
                if token = ';' then Ttoken := 'T_SEMICOLON';
                if ((token = '*') or (token = '/') or (token = '+') or (token = '-' )) then Ttoken := 'T_OPERATOR';

                inc(i);
                larik[i] := Ttoken;
                token := '';
           end;

     end;
     close(x);
end;

procedure parse;
begin
     repeat
     inc(i);
     if ((larik[i]='T_PROGRAM') or (larik[i]='T_USES')) then
     begin
          inc(i);
          if (larik[i]='T_NAME') then
          begin
               inc(i);
               if (larik[i]<>'T_SEMICOLON') then
               begin
                    error:=true;
                    id:=2;
                    break;
               end;
          end
          else
          begin
               error:=true;
               id:=1;
               break;
          end;
     end;
     if (larik[i]='T_NAME') then
     begin
          inc(i);
          if (larik[i]='T_IS') then
          begin
               inc(i);
               if (larik[i]='T_INT') then
               begin
                    inc(i);
                    if (larik[i]<>'T_SEMICOLON') then
                    begin
                         error:=true;
                         id:=2;
                         break;
                    end;
               end
               else
               begin
                    error:=true;
                    id:=4;
                    break;
               end;
          end
          else if (larik[i]='T_ASSIGN') then
          begin
               ATAS:
                    inc(i);
                    if ((larik[i]='T_NAME') or (larik[i]='T_KONSTANTA')) then
                    begin
                         inc(i);
                         if ((larik[i]='T_OPERATOR') or (larik[i]='T_MOD') or (larik[i]='T_DIV')) then GoTo ATAS
                         else if ((larik[i]<>'T_SEMICOLON') and ((larik[i]<>'T_OPERATOR') or (larik[i]<>'T_MOD') or (larik[i]<>'T_DIV'))) then
                         begin
                              error:=true;
                              id:=6;
                              break;
                         end;
                    end
                    else
                    begin
                         error:=true;
                         id:=5;
                         break;
                    end;
          end
          else
          begin
               error:=true;
               id:=3;
               break;
          end;
     end;
     until (i=j);
end;



begin
     scan;
     error:=false;
     j:=i;
     i:=0;
     id:=0;
     parse;
     write('Hasil parsing : ');
     if (error=false) then writeln('Parsing sukses.')
     else
     begin
         write('Parsing gagal: ');
         case id of
              1: writeln('variabel diharapkan.');
              2: writeln('";" diharapkan.');
              3: writeln('":" atau ":=" diharapkan.');
              4: writeln('integer diharapkan.');
              5: writeln('variabel atau konstanta diaharapkan.');
              6: writeln('ekspresi ilegal.');
         end;
     end;
     writeln();
     write('Tekan sembarang tombol untuk menutup. . .');
     readln;
end.
