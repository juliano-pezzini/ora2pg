-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION invert_name_varchar (nm_pessoa_fisica_p text, separator_p text) RETURNS varchar AS $body$
DECLARE


ds_return_value_w		varchar(100);
counter			        integer;
beginning			    integer;
nickname_w		        varchar(60);
name_w			        varchar(60);


BEGIN

    if (nm_pessoa_fisica_p IS NOT NULL AND nm_pessoa_fisica_p::text <> '')
    then

        for	counter in 1 .. length(nm_pessoa_fisica_p) loop
            begin
                if (substr(nm_pessoa_fisica_p, counter, 1) = ' ') then
                    beginning       := counter + 1;
                    nickname_w     := substr(nm_pessoa_fisica_p,  beginning, (length(nm_pessoa_fisica_p) - beginning + 1));
                end if;
            end;
        end loop;

        for  counter in 1 .. length(nm_pessoa_fisica_p) loop
            begin
                if	(substr(nm_pessoa_fisica_p, counter, (length(nickname_w))) = nickname_w ) then
                    name_w  := substr(nm_pessoa_fisica_p,1,counter-1);
                end if;
            end;
        end loop;

        ds_return_value_w	:= nickname_w || separator_p || name_w;
    else
        ds_return_value_w := '';
    end if;

    return ds_return_value_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION invert_name_varchar (nm_pessoa_fisica_p text, separator_p text) FROM PUBLIC;

