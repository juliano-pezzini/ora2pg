-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_dt_os_em_cliente ( nr_sequencia_p bigint, ie_opcao_p text ) RETURNS timestamp AS $body$
DECLARE

dt_ultima_os_cliente_w	timestamp;
dt_penult_os_cliente_w	timestamp;
dt_antepe_os_cliente_w	timestamp;
ds_retorno		timestamp;

BEGIN

select	max(a.dt_atualizacao)
into STRICT	dt_ultima_os_cliente_w
FROM man_estagio_processo b, man_ordem_serv_estagio a
LEFT OUTER JOIN man_tipo_solucao c ON (a.nr_seq_tipo_solucao = c.nr_sequencia)
WHERE a.nr_seq_ordem 		= nr_sequencia_p and b.nr_sequencia 		= a.nr_seq_estagio;

select	max(a.dt_atualizacao)
into STRICT	dt_penult_os_cliente_w
FROM man_estagio_processo b, man_ordem_serv_estagio a
LEFT OUTER JOIN man_tipo_solucao c ON (a.nr_seq_tipo_solucao = c.nr_sequencia)
WHERE a.nr_seq_ordem 			= nr_sequencia_p and b.nr_sequencia 			= a.nr_seq_estagio  and a.dt_atualizacao <> dt_ultima_os_cliente_w;

select	max(a.dt_atualizacao)
into STRICT	dt_antepe_os_cliente_w
FROM man_estagio_processo b, man_ordem_serv_estagio a
LEFT OUTER JOIN man_tipo_solucao c ON (a.nr_seq_tipo_solucao = c.nr_sequencia)
WHERE a.nr_seq_ordem 			= nr_sequencia_p and b.nr_sequencia 			= a.nr_seq_estagio  and a.dt_atualizacao <> dt_ultima_os_cliente_w and a.dt_atualizacao <> dt_penult_os_cliente_w;

if (ie_opcao_p = 'U') then
	ds_retorno := dt_ultima_os_cliente_w;
else
	if (ie_opcao_p = 'P') then
		ds_retorno := dt_penult_os_cliente_w;
	else
		if (ie_opcao_p = 'A') then
			ds_retorno := dt_antepe_os_cliente_w;
		end if;
	end if;
end if;

return	ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_dt_os_em_cliente ( nr_sequencia_p bigint, ie_opcao_p text ) FROM PUBLIC;

