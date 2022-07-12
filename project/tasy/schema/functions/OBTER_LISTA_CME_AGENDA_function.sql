-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_cme_agenda ( nr_seq_agenda_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_conjunto_w		varchar(255);
ds_lista_conjunto_w	varchar(2000):=null;

c01 CURSOR FOR
	SELECT substr(cme_obter_nome_conjunto(nr_seq_conjunto),1,125)
	from   agenda_pac_cme
	where  nr_seq_agenda = nr_seq_agenda_p;


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	ds_conjunto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (coalesce(ds_lista_conjunto_w::text, '') = '') then
		ds_lista_conjunto_w 	:= substr(ds_conjunto_w,1,2000);
	else
		ds_lista_conjunto_w	:= substr(ds_lista_conjunto_w || ',' || ds_conjunto_w,1,2000);
	end if;
	end;
END LOOP;
CLOSE C01;

return substr(ds_lista_conjunto_w,1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_cme_agenda ( nr_seq_agenda_p bigint ) FROM PUBLIC;
