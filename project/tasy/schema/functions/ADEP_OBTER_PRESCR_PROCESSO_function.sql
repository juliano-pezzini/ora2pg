-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_prescr_processo (nr_seq_processo_p adep_processo.nr_sequencia%type, ie_separador_p text default ',') RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);

c_prescricao CURSOR FOR
	SELECT	distinct a.nr_prescricao
	from	prescr_mat_hor	a
	where	a.nr_seq_processo	= nr_seq_processo_p;
			
BEGIN
ds_retorno_w	:= '';

for c_prescricao_w in c_prescricao loop
	begin
	
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w || ie_separador_p;
	end if;
	
	ds_retorno_w := ds_retorno_w || c_prescricao_w.nr_prescricao;
	
	end;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_prescr_processo (nr_seq_processo_p adep_processo.nr_sequencia%type, ie_separador_p text default ',') FROM PUBLIC;
