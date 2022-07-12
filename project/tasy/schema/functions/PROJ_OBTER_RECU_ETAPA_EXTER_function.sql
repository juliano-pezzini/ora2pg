-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_recu_etapa_exter (nr_seq_etapa_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(255);
ds_equipe_w	varchar(255);
ds_equipe_ww	varchar(255);

c01 CURSOR FOR 
	SELECT	obter_nome_pessoa_fisica(cd_recurso_externo, null) 
	from	proj_cron_etapa_equipe 
	where	nr_seq_etapa_cron = nr_seq_etapa_p 
	and	ie_recurso_externo = 'S';


BEGIN 
 
ds_equipe_ww := '';
 
open c01;
loop 
fetch c01 into	 
	ds_equipe_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	ds_equipe_ww := ds_equipe_ww || ', ' || ds_equipe_w;
	 
	end;
end loop;
close c01;
 
ds_retorno_w := substr(ds_equipe_ww,2,255);
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_recu_etapa_exter (nr_seq_etapa_p bigint) FROM PUBLIC;
