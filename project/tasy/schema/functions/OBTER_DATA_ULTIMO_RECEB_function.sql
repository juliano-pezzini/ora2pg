-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_ultimo_receb ( nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_historico_w	timestamp;
dt_inicial_w	timestamp;
dt_resultado_w	timestamp;



BEGIN

select	max(b.dt_historico)
into STRICT	dt_historico_w
from	hist_audit_conta_paciente a,
	conta_paciente_ret_hist b
where	a.nr_sequencia		= b.nr_seq_hist_audit
and	a.ie_acao		= 1
and	b.nr_seq_conpaci_ret	= nr_sequencia_p;

if (dt_historico_w IS NOT NULL AND dt_historico_w::text <> '') then
	dt_resultado_w	:= dt_historico_w;
else
	select	dt_inicial
	into STRICT	dt_inicial_w
	from	conta_paciente_retorno
	where	nr_sequencia	= nr_sequencia_p;

	dt_resultado_w	:= dt_inicial_w;
end if;

return	dt_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_ultimo_receb ( nr_sequencia_p bigint) FROM PUBLIC;

