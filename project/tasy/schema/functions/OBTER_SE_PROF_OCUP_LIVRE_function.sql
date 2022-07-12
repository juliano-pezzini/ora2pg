-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prof_ocup_livre (cd_profissional_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
dt_fim_w	timestamp;
dt_inicio_w	timestamp;
nr_seq_sl_w	bigint;
			

BEGIN

/*
 Retorno
	L  - Livre
	O - Ocupado
*/
select 	max(nr_sequencia)
into STRICT	nr_seq_sl_w
from	sl_unid_atend
where	cd_executor = cd_profissional_p
and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prevista) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_referencia_p);


select	max(dt_fim),
	max(dt_inicio)
into STRICT	dt_fim_w,
	dt_inicio_w
from	sl_unid_atend
where	nr_sequencia = nr_seq_sl_w;

if	((dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '' AND dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') or
	((coalesce(dt_inicio_w::text, '') = '') and (coalesce(dt_fim_w::text, '') = ''))) then
	
	ds_retorno_w := 'L';

elsif (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and (coalesce(dt_fim_w::text, '') = '') then
	
	ds_retorno_w := 'O';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prof_ocup_livre (cd_profissional_p text, dt_referencia_p timestamp) FROM PUBLIC;

