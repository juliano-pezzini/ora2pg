-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_datas_periodo_sip ( nr_ano_p text, nr_periodo_tps_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
dt_inicial_w		varchar(10);
dt_final_w		varchar(10);


BEGIN

select	dt_mes_referencia_inicial,
	dt_mes_referencia_final
into STRICT	dt_inicial_w,
	dt_final_w
from	pls_periodo_sip
where	nr_sequencia	= nr_periodo_tps_p;

if (dt_inicial_w IS NOT NULL AND dt_inicial_w::text <> '') and (dt_final_w IS NOT NULL AND dt_final_w::text <> '') then
	ds_retorno_w	:= dt_inicial_w||'/'||nr_ano_p||';'||dt_final_w||'/'||nr_ano_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_datas_periodo_sip ( nr_ano_p text, nr_periodo_tps_p bigint) FROM PUBLIC;
