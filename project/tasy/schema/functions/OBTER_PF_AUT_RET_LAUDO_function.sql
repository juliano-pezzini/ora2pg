-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pf_aut_ret_laudo (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nm_pessoa_fisica_w	varchar(200);
lista_pessoas_w		varchar(255);

C01 CURSOR FOR
	SELECT	nm_pessoa_fisica
	from	atend_autor_entrega
	where	nr_atendimento = nr_atendimento_p
	order by nm_pessoa_fisica;


BEGIN

open C01;
loop
fetch C01 into
	nm_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (lista_pessoas_w IS NOT NULL AND lista_pessoas_w::text <> '') then
		lista_pessoas_w := substr(lista_pessoas_w || ', ' || nm_pessoa_fisica_w,1,255);
	else
		lista_pessoas_w := nm_pessoa_fisica_w;
	end if;
	end;
end loop;
close C01;

return	lista_pessoas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pf_aut_ret_laudo (nr_atendimento_p bigint) FROM PUBLIC;

