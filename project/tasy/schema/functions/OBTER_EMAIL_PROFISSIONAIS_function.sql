-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_email_profissionais (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE


ds_email_w	varchar(500);
ds_email_prof_w	varchar(500);

c01 CURSOR FOR
	SELECT	distinct ds_email
	from 	profissional_agenda a,
		compl_pessoa_fisica b
	where   nr_seq_agenda = nr_seq_agenda_p
	and	cd_profissional = cd_pessoa_fisica
	and 	(ds_email IS NOT NULL AND ds_email::text <> '')
	order  by 1 desc;


BEGIN

open c01;
loop
fetch c01 into
	ds_email_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_email_prof_w	:= ds_email_w || ';' || ds_email_prof_w;
	end;
end loop;
close c01;

return 	substr(ds_email_prof_w,1,500);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_email_profissionais (nr_seq_agenda_p bigint) FROM PUBLIC;

