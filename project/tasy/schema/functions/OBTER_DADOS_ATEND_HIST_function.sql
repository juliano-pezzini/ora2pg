-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_atend_hist (nr_seq_unidade_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


ds_retorno_w		timestamp;

/*ie_opcao_p
DU - Data do ultimo atendimento
DN - Data da nova internação

*/
BEGIN

if (ie_opcao_p = 'DN') then
	begin

	select	dt_historico
	into STRICT	ds_retorno_w
	from	unidade_atend_hist
	where	nr_sequencia in (SELECT	max(b.nr_sequencia)
				from    unidade_atend_hist b
				where   b.nr_seq_unidade = nr_seq_unidade_p
				and	coalesce(b.dt_fim_historico::text, '') = ''
				and	b.ie_status_unidade = 'P');

	end;
elsif (ie_opcao_p = 'DU') then
	begin

	select	dt_fim_historico
	into STRICT	ds_retorno_w
	from	unidade_atend_hist
	where	nr_sequencia in (SELECT	max(b.nr_sequencia)
				from    unidade_atend_hist b
				where   b.nr_seq_unidade = nr_seq_unidade_p
				and	(b.dt_fim_historico IS NOT NULL AND b.dt_fim_historico::text <> '')
				and	b.ie_status_unidade = 'P');

	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_atend_hist (nr_seq_unidade_p bigint, ie_opcao_p text) FROM PUBLIC;

