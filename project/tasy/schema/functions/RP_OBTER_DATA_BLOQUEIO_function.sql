-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_data_bloqueio (nr_seq_reabilitacao_p bigint, cd_estabelecimento_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_retorno_w	timestamp;

BEGIN

if (nr_seq_reabilitacao_p IS NOT NULL AND nr_seq_reabilitacao_p::text <> '') then

	select 	coalesce(max(a.dt_alteracao),to_date('01/01/1900','dd/mm/yyyy'))
	into STRICT	dt_retorno_w
	from	rp_status_pac a,
		rp_paciente_reabilitacao b
	where   a.nr_seq_pac_reab = b.nr_sequencia
	and	b.nr_sequencia = nr_seq_reabilitacao_p
	and	a.nr_seq_status_ant = (	SELECT (NR_SEQ_PAC_REAB_BLOQUEIO)
					from    RP_PARAMETROS
					where   cd_estabelecimento = cd_estabelecimento_p);
end if;
return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_data_bloqueio (nr_seq_reabilitacao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
