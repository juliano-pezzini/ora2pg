-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tempo_vmni ( nr_sequencia_p bigint, ie_tempo_p text) RETURNS bigint AS $body$
DECLARE


Qt_reg_w		bigint;
Nr_atendimento_w	bigint;
dt_monitorizacao_w	timestamp;
nr_seq_proximo_w	bigint;


BEGIN

Select	dt_monitorizacao,
	nr_atendimento
into STRICT	dt_monitorizacao_w,
	Nr_atendimento_w
from	atendimento_monit_resp
where	nr_sequencia = nr_sequencia_p;

select 	Min( nr_sequencia )
into STRICT	nr_seq_proximo_w
from	atendimento_monit_resp
where	coalesce(dt_inativacao::text, '') = ''
and	ie_respiracao <> 'VMNI'
and	nr_atendimento = Nr_atendimento_w
and	nr_sequencia > nr_sequencia_p;

if ( coalesce(nr_seq_proximo_w::text, '') = '') and (( dt_monitorizacao_w - clock_timestamp() ) < ( ie_tempo_p/24 )) then

	Qt_reg_w := 1;

else

	select 	count(*)
	into STRICT	Qt_reg_w
	from	atendimento_monit_resp
	where	coalesce(dt_inativacao::text, '') = ''
	and	ie_respiracao <> 'VMNI'
	and	nr_sequencia = nr_seq_proximo_w
	and	((dt_monitorizacao - dt_monitorizacao_w) < (ie_tempo_p/24));

end if;

return	Qt_reg_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tempo_vmni ( nr_sequencia_p bigint, ie_tempo_p text) FROM PUBLIC;

