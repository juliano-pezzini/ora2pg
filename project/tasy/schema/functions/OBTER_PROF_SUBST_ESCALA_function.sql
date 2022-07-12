-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prof_subst_escala (cd_dia_p text, cd_mes_p text, cd_ano_p text, cd_profissional_p text, nr_seq_escala_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(100);	
dt_escala_w	timestamp;	
			 

BEGIN 
 
select	cd_dia_p||'/'||cd_mes_p||'/'||cd_ano_p 
into STRICT	dt_escala_w
;
 
select	max(substr(obter_nome_pf(cd_profissional_subst),1,100)) 
into STRICT	ds_retorno_w 
from	escala_afastamento_prof a, 
	motivo_afast_escala b 
where	a.nr_seq_motivo_afast = b.nr_sequencia 
and	a.cd_profissional = cd_profissional_p 
and	((a.nr_seq_escala = nr_seq_escala_p) or (coalesce(a.nr_seq_escala::text, '') = '')) 
and (dt_escala_w between trunc(a.dt_inicio) and trunc(a.dt_final));
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prof_subst_escala (cd_dia_p text, cd_mes_p text, cd_ano_p text, cd_profissional_p text, nr_seq_escala_p text) FROM PUBLIC;

