-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_prest_inter ( nr_seq_prest_int_p pls_prestador_intercambio.nr_sequencia%type, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Verificar se a conta se encaixa nos filtros específicos de conta para
as ocorrências combinadas de conta médica.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ x]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(4000);
nr_seq_cbo_saude_w	cbo_saude.nr_sequencia%type;
ds_municipio_w		sus_municipio.ds_municipio%type;
ds_unidade_federacao_w	sus_municipio.ds_unidade_federacao%type;

/*	ie_opcao_p
	'N'      - -Nome
	'CPF'  - -CPF
	'CGC' - -CGC
	'CNES -- CD_CNES
	'IBGE'--CD_MUNICIPIO_IBGE
	MC - Municipio completo
	CDPF - Código pessoa física
*/
BEGIN

ds_retorno_w := '';

if (ie_opcao_p = 'N') then
	select	max(nm_prestador)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CPF') then
	select 	max(nr_cpf)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CGC') then
	select 	max(cd_cgc_intercambio)
	into STRICT	ds_retorno_w
	from 	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CNES') then
	select 	max(cd_cnes)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'IBGE') then
	select	max(cd_municipio_ibge)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'DTS') then
	select	max(dt_inicio_servico)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'DTC') then
	select	max(dt_contratualizacao)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'IRO') then
	select	max(ie_relacao_operadora)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'ITC') then
	select	max(ie_tipo_contratualizacao)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CCL') then
	select	max(cd_classificacao)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CAI') then
	select	max(cd_ans_int)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'DSV') then
	select	max(ie_disponibilidade_serv)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'IUE') then
	select	max(ie_urgencia_emergencia)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'MC') then

	select	max(a.ds_municipio),
		max(a.ds_unidade_federacao)
	into STRICT	ds_municipio_w,
		ds_unidade_federacao_w
	from	sus_municipio			a,
		pls_prestador_intercambio	b
	where	b.cd_municipio_ibge	= a.cd_municipio_ibge
	and	b.nr_sequencia		= nr_seq_prest_int_p;

	ds_retorno_w := ds_municipio_w;

	if (ds_unidade_federacao_w IS NOT NULL AND ds_unidade_federacao_w::text <> '') then

		ds_retorno_w := ds_retorno_w || ' - ' || ds_unidade_federacao_w;
	end if;

elsif (ie_opcao_p = 'CBO') then
	select	max(nr_seq_cbo_saude)
	into STRICT	nr_seq_cbo_saude_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

	select	max(cd_cbo)
	into STRICT	ds_retorno_w
	from	cbo_saude
	where	nr_sequencia	= nr_seq_cbo_saude_w;

elsif (ie_opcao_p = 'CBOS') then
	select	max(nr_seq_cbo_saude)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;

elsif (ie_opcao_p = 'CDPF') then
	select	max(cd_pessoa_fisica)
	into STRICT	ds_retorno_w
	from	pls_prestador_intercambio
	where	nr_sequencia = nr_seq_prest_int_p;
else
	ds_retorno_w := null;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_prest_inter ( nr_seq_prest_int_p pls_prestador_intercambio.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;
