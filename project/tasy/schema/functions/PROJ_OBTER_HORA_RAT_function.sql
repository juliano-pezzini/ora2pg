-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_hora_rat ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision;


BEGIN
select (sum(a.qt_min_ativ) - sum(a.qt_min_intervalo))
into STRICT	qt_retorno_w
from	proj_rat_ativ a
where	a.nr_seq_rat = nr_sequencia_p
and	((coalesce(a.ie_atividade_extra,'N') = ie_opcao_p) or (ie_opcao_p = 'A'));

if (coalesce(qt_retorno_w,0) > 0) then
	qt_retorno_w := qt_retorno_w / 60;
else	qt_retorno_w := 0;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_hora_rat ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

