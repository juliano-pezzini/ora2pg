-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION diops_obter_regra_sinistro (nr_seq_periodo_p bigint) RETURNS varchar AS $body$
DECLARE


dt_periodo_inicial_w	timestamp;
ie_evento_30_60_w	diops_fin_regra_sinistro.ie_evento_30_60%type;


BEGIN

begin
select	trunc(a.dt_periodo_inicial, 'dd')
into STRICT	dt_periodo_inicial_w
from	diops_periodo	a
where	a.nr_sequencia	= nr_seq_periodo_p;

select	coalesce(max(a.ie_evento_30_60), '60')
into STRICT	ie_evento_30_60_w
from	diops_fin_regra_sinistro	a
where	dt_periodo_inicial_w between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, dt_periodo_inicial_w);

exception
when others then
	ie_evento_30_60_w := '60';
end;

return	ie_evento_30_60_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION diops_obter_regra_sinistro (nr_seq_periodo_p bigint) FROM PUBLIC;

