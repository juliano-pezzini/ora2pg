-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_prop_2170 ( nr_seq_proposta_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, ie_taxa_inscricao_p text, ie_opcao text) RETURNS bigint AS $body$
DECLARE

/*
TC - Taxa de coparticipação
MC - Valor máximo de coparticipação
 TI - Taxa de inscrição
 */
ds_retorno	double precision;


BEGIN

if (ie_opcao = 'TC') then
	select	sum(a.tx_coparticipacao)
	into STRICT	ds_retorno
	from	pls_regra_coparticipacao	a
	where	a.nr_seq_proposta = nr_seq_proposta_p;

	if (coalesce(ds_retorno::text, '') = '') then
		select	max(a.tx_coparticipacao)
		into STRICT	ds_retorno
		from	pls_regra_coparticipacao	a
		where	a.nr_seq_contrato = nr_seq_contrato_p;

		if (coalesce(ds_retorno::text, '') = '') then
			select	max(a.tx_coparticipacao)
			into STRICT	ds_retorno
			from	pls_regra_coparticipacao	a
			where	a.nr_seq_plano = nr_seq_plano_p;
		end if;
	end if;
end if;

if (ie_opcao = 'MC') then
	select	sum(a.vl_maximo)
	into STRICT	ds_retorno
	from	pls_regra_coparticipacao	a
	where	a.nr_seq_proposta = nr_seq_proposta_p;

	if (coalesce(ds_retorno::text, '') = '') then
		select	max(a.vl_maximo)
		into STRICT	ds_retorno
		from	pls_regra_coparticipacao	a
		where	a.nr_seq_contrato = nr_seq_contrato_p;

		if (coalesce(ds_retorno::text, '') = '') then
			select	max(a.vl_maximo)
			into STRICT	ds_retorno
			from	pls_regra_coparticipacao	a
			where	a.nr_seq_plano = nr_seq_plano_p;
		end if;
	end if;
end if;

if (ie_opcao = 'TI') then
	select	sum(a.vl_inscricao)
	into STRICT	ds_retorno
	from	pls_regra_inscricao	a
	where	a.nr_seq_proposta = nr_seq_proposta_p
	and	coalesce(ie_taxa_inscricao_p,'S') ='S'
	and (clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())	and a.ie_grau_dependencia in ('A','T'));

	if (coalesce(ds_retorno::text, '') = '') then
		select	max(a.vl_inscricao)
		into STRICT	ds_retorno
		from	pls_regra_inscricao	a
		where	a.nr_seq_contrato = nr_seq_contrato_p
		and	coalesce(ie_taxa_inscricao_p,'S') ='S'
		and (clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())	and a.ie_grau_dependencia in ('A','T'));

		if (coalesce(ds_retorno::text, '') = '') then
			select	max(a.vl_inscricao)
			into STRICT	ds_retorno
			from	pls_regra_inscricao	a
			where	a.nr_seq_plano = nr_seq_plano_p
			and	coalesce(ie_taxa_inscricao_p,'S') ='S'
			and (clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())	and a.ie_grau_dependencia in ('A','T'));
		end if;
	end if;
end if;


return	ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_prop_2170 ( nr_seq_proposta_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, ie_taxa_inscricao_p text, ie_opcao text) FROM PUBLIC;
