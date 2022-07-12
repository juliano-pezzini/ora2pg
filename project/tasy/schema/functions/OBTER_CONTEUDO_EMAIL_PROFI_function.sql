-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conteudo_email_profi (nr_seq_agenda_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_profissionais_w	varchar(2000);
ds_informacao_w		varchar(500);

c01 CURSOR FOR 
	SELECT	ds_funcao||': '||substr(obter_nome_pf(cd_profissional),1,254) nm_profissional 
	from 	funcao_medico b, 
		profissional_agenda a 
	where  nr_seq_agenda = nr_seq_agenda_p 
	and   a.cd_funcao  = b.cd_funcao 
	order by 1 desc;


BEGIN 
 
open c01;
loop 
fetch c01 into 
	ds_informacao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_profissionais_w	:= ds_informacao_w || chr(13) || chr(10) || ds_profissionais_w;
	end;
end loop;
close c01;
 
return 	substr(ds_profissionais_w,1,2000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conteudo_email_profi (nr_seq_agenda_p bigint) FROM PUBLIC;
