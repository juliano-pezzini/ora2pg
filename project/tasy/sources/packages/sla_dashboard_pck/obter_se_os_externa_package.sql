-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_se_os_externa ( nr_seq_sla_regra_p bigint) RETURNS bigint AS $body$
DECLARE


qt_localizacao_externa_w	bigint;

BEGIN

if (nr_seq_sla_regra_p IS NOT NULL AND nr_seq_sla_regra_p::text <> '') then
	select 	count(1)
	into STRICT	qt_localizacao_externa_w
	from	man_sla_loc c,
		man_sla_regra b,
		man_sla a,
		man_localizacao d
	where	a.nr_sequencia	= b.nr_seq_sla
	and	a.nr_sequencia	= c.nr_seq_sla
	and c.nr_seq_local	= d.nr_sequencia
	and ie_terceiro 	= 'S'
	and b.nr_sequencia 	= nr_seq_sla_regra_p;
else
	qt_localizacao_externa_w := 1;
end if;

return	qt_localizacao_externa_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_se_os_externa ( nr_seq_sla_regra_p bigint) FROM PUBLIC;