-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_dias_afast_coop (nr_seq_ausencia_p bigint) RETURNS bigint AS $body$
DECLARE

qt_dias_w	bigint;


BEGIN

if (nr_seq_ausencia_p IS NOT NULL AND nr_seq_ausencia_p::text <> '') then

	select	obter_dias_entre_datas(trunc(a.dt_inicio,'dd'), trunc(coalesce(a.dt_fim, clock_timestamp()),'dd') + 1)
	into STRICT	qt_dias_w
	from	pls_cooperado_ausencia	a
	where	nr_sequencia	= nr_seq_ausencia_p;
end if;

return	qt_dias_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_dias_afast_coop (nr_seq_ausencia_p bigint) FROM PUBLIC;
