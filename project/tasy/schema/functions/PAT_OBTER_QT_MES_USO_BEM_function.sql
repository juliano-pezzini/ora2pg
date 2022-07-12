-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_qt_mes_uso_bem ( nr_seq_bem_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_meses_w	bigint;


BEGIN
qt_meses_w := 0;
if (nr_seq_bem_p > 0) then
	select	obter_meses_entre_datas_util(trunc(dt_aquisicao,'mm'), trunc(coalesce(dt_referencia_p,clock_timestamp()),'mm'))
	into STRICT	qt_meses_w
	from	pat_bem
	where	nr_sequencia = nr_seq_bem_p;
end if;

return	qt_meses_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_qt_mes_uso_bem ( nr_seq_bem_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
