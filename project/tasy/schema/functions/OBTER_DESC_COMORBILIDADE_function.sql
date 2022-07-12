-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_comorbilidade (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_doenca_w	varchar(4000) 	:= '';

C01 CURSOR FOR
	SELECT 	cd_doenca,
			substr(obter_desc_cid(cd_doenca),1,240) ds_doenca_cid
	from 	diagnostico_doenca
	where 	nr_atendimento 	= nr_atendimento_p
	order by nr_seq_interno;

BEGIN
for r_C01_w in C01 loop
	begin
		if (r_C01_w.cd_doenca in ('O00','O01','O02','O03','O04','O05','O06','O07','O08','O80','O81','O82','O83','O84')) then
			if (coalesce(ds_doenca_w::text, '') = '') then
				ds_doenca_w := trim(both TRAILING ' ' FROM r_C01_w.ds_doenca_cid);
			else
				ds_doenca_w := ds_doenca_w || '&' || trim(both TRAILING ' ' FROM r_C01_w.ds_doenca_cid);
			end if;
		end if;
end;
end loop;

return	ds_doenca_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_comorbilidade (nr_atendimento_p bigint) FROM PUBLIC;
