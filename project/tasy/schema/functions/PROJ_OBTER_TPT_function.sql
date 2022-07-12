-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_tpt (nr_seq_etapa_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	proj_cron_etapa.qt_hora_saldo%type;
qt_tpt_w		proj_cron_etapa.qt_hora_saldo%type;
qt_hora_saldo_w	proj_cron_etapa.qt_hora_saldo%type;


BEGIN

select	max(coalesce(qt_hora_prev - (dividir((qt_hora_prev * pr_etapa),100)),0)),
		max(qt_hora_saldo)
into STRICT	qt_tpt_w,
		qt_hora_saldo_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_etapa_p;

if (qt_tpt_w = 0) or ((qt_hora_saldo_w - qt_tpt_w) = 0) then
	ds_retorno_w := 0;
else
	ds_retorno_w := round((qt_hora_saldo_w - qt_tpt_w)/qt_tpt_w,2)*100;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_tpt (nr_seq_etapa_p bigint) FROM PUBLIC;
