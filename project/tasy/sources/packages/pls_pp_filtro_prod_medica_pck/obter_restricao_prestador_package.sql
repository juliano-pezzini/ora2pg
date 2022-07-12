-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_prod_medica_pck.obter_restricao_prestador ( nr_seq_prestador_p pls_pp_rp_filtro_prest.nr_seq_prestador%type, cd_prestador_cod_p pls_pp_rp_filtro_prest.cd_prestador_cod%type, nr_seq_tipo_prestador_p pls_pp_rp_filtro_prest.nr_seq_tipo_prestador%type, nr_seq_classif_prestador_p pls_pp_rp_filtro_prest.nr_seq_classif_prestador%type, nr_seq_grupo_prestador_p pls_pp_rp_filtro_prest.nr_seq_grupo_prestador%type, cd_condicao_pagamento_p pls_pp_rp_filtro_prest.cd_condicao_pagamento%type, ie_tipo_pessoa_prest_p pls_pp_rp_filtro_prest.ie_tipo_pessoa_prest%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_prest_w	varchar(2500);
ds_restr_tprest_w	varchar(1000);
ds_alias_prest_w	varchar(10);
ds_alias_prot_w		varchar(10);
ds_alias_res_w		varchar(10);
ds_campos_w		varchar(500);
ds_tabela_w		varchar(200);


BEGIN
-- todo este filtro trabalha somente com o prestador de pagamentos (nr_seq_prestador_pgto da pls_conta_medica_resumo)
ds_restricao_prest_w := null;
ds_restr_tprest_w := null;
ds_campos_w := null;
ds_tabela_w := null;
ds_alias_prest_w := pls_pp_filtro_prod_medica_pck.obter_alias_tabela('prestador');
ds_alias_prot_w := pls_pp_filtro_prod_medica_pck.obter_alias_tabela('protocolo');
ds_alias_res_w := pls_pp_filtro_prod_medica_pck.obter_alias_tabela('resumo');

-- sequencia do prestador
if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.nr_sequencia = :nr_seq_prestador_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_prestador_pc', nr_seq_prestador_p, valor_bind_p);
end if;

-- codigo do prestador
if (cd_prestador_cod_p IS NOT NULL AND cd_prestador_cod_p::text <> '') then
	ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.cd_prestador = :cd_prestador_cod_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':cd_prestador_cod_pc', cd_prestador_cod_p, valor_bind_p);
end if;

-- tipo do prestador
if (nr_seq_tipo_prestador_p IS NOT NULL AND nr_seq_tipo_prestador_p::text <> '') then

	-- filtro da data de vigencia para tipo de prestador
	-- data de competencia do protocolo
	if (ie_tipo_data_ref_p = '1') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_prot_w || '.dt_mes_competencia between pretip.dt_inicio_vigencia_ref and pretip.dt_fim_vigencia_ref';

	-- data de liberacao de pagamento do protocolo
	elsif (ie_tipo_data_ref_p = '2') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_prot_w || '.dt_lib_pagamento between pretip.dt_inicio_vigencia_ref and pretip.dt_fim_vigencia_ref';
		
	-- data de competencia do resumo de conta medica
	elsif (ie_tipo_data_ref_p = '3') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_res_w || '.dt_competencia_pgto between pretip.dt_inicio_vigencia_ref and pretip.dt_fim_vigencia_ref';	
	end if;
	
	ds_restr_tprest_w := ds_restr_tprest_w || pls_util_pck.enter_w;
	
	-- todo select sempre faz join com a pls_prestador, por isso o filtro pode ser feito desta forma
	ds_restricao_prest_w	:= ds_restricao_prest_w ||
				' and	exists	(select	1 ' ||
				'		from	pls_prestador_tipo pretip' || pls_util_pck.enter_w ||
				'		where	pretip.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
						ds_restr_tprest_w ||
				'		and	pretip.nr_seq_tipo = :nr_seq_tipo_prestador_pc' || pls_util_pck.enter_w ||
				'		union all' || pls_util_pck.enter_w ||
				'		select	1 ' || pls_util_pck.enter_w ||
				'		from	pls_prestador pretip' || pls_util_pck.enter_w ||
				'		where	pretip.nr_sequencia = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				'		and	pretip.nr_seq_tipo_prestador = :nr_seq_tipo_prestador_pc)' || pls_util_pck.enter_w;

	valor_bind_p := sql_pck.bind_variable(':nr_seq_tipo_prestador_pc', nr_seq_tipo_prestador_p, valor_bind_p);
	-- zera para se precisar mais abaixo
	ds_restr_tprest_w := null;
end if;

-- classificacao do prestador
if (nr_seq_classif_prestador_p IS NOT NULL AND nr_seq_classif_prestador_p::text <> '') then
	ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.nr_seq_classificacao = :nr_seq_classif_prestador_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_classif_prestador_pc', nr_seq_classif_prestador_p, valor_bind_p);
end if;

-- Grupo do Prestador
if (nr_seq_grupo_prestador_p IS NOT NULL AND nr_seq_grupo_prestador_p::text <> '') then

	ds_restricao_prest_w := ds_restricao_prest_w || ' and  (select 	count(1) ' 									|| pls_util_pck.enter_w ||
							'       from 	table(pls_grupos_pck.obter_prestadores_grupo( ' 				|| pls_util_pck.enter_w ||
							'       	:nr_seq_grupo_prestador_pc, ' || ds_alias_prest_w || '.nr_sequencia))' 	|| pls_util_pck.enter_w ||
							'       where 	decode(' || ds_alias_prest_w || '.nr_sequencia, null, -1, -2) = -2) > 0 ' 	|| pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_grupo_prestador_pc', nr_seq_grupo_prestador_p, valor_bind_p);
end if;

-- condicao de pagamento do prestador
if (cd_condicao_pagamento_p IS NOT NULL AND cd_condicao_pagamento_p::text <> '') then
	-- filtro da data de vigencia da condicao de pagamento
	-- data de competencia do protocolo
	if (ie_tipo_data_ref_p = '1') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_prot_w || '.dt_mes_competencia between prepag.dt_inicio_vigencia_ref and prepag.dt_fim_vigencia_ref';

	-- data de liberacao de pagamento do protocolo
	elsif (ie_tipo_data_ref_p = '2') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_prot_w || '.dt_lib_pagamento between prepag.dt_inicio_vigencia_ref and prepag.dt_fim_vigencia_ref';
		
	-- data de competencia do resumo de conta medica
	elsif (ie_tipo_data_ref_p = '3') then
		ds_restr_tprest_w := ds_restr_tprest_w || ' and ' || ds_alias_res_w || '.dt_competencia_pgto between prepag.dt_inicio_vigencia_ref and prepag.dt_fim_vigencia_ref';	
	end if;
	
	ds_restr_tprest_w := ds_restr_tprest_w || pls_util_pck.enter_w;
	
	-- todo select sempre faz join com a pls_prestador, por isso o filtro pode ser feito desta forma
	ds_restricao_prest_w	:= ds_restricao_prest_w ||
				' and	exists	(select	1 ' ||
				'		from	pls_prestador_pagto prepag' || pls_util_pck.enter_w ||
				'		where	prepag.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
						ds_restr_tprest_w ||
				'		and	prepag.cd_condicao_pagamento = :cd_condicao_pagamento_pc) ';
	valor_bind_p := sql_pck.bind_variable(':cd_condicao_pagamento_pc', cd_condicao_pagamento_p, valor_bind_p);
	-- zera para se precisar mais abaixo
	ds_restr_tprest_w := null;
end if;

-- tipo de pessoa do prestador
-- so existe PF e PJ, se for ambos (A) nao precisa filtrar nada
-- e feita a inclusao das tabelas pessoa_fisica ou pessoa_juridica para validar o tipo do prestador
-- preferi fazer com join em outra tabela para garantir a performance no caso de existir um filtro somente com este campo informado
if (ie_tipo_pessoa_prest_p in ('PF', 'PJ')) then
	
	-- pessoa fisica
	if (ie_tipo_pessoa_prest_p = 'PF') then
		ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.cd_pessoa_fisica is not null ' || pls_util_pck.enter_w;
	end if;
	
	-- pessoa juridica
	if (ie_tipo_pessoa_prest_p = 'PJ') then
		ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.cd_cgc is not null ' || pls_util_pck.enter_w;
	end if;
end if;

ds_campos_p := ds_campos_w;
ds_tabela_p := ds_tabela_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_prod_medica_pck.obter_restricao_prestador ( nr_seq_prestador_p pls_pp_rp_filtro_prest.nr_seq_prestador%type, cd_prestador_cod_p pls_pp_rp_filtro_prest.cd_prestador_cod%type, nr_seq_tipo_prestador_p pls_pp_rp_filtro_prest.nr_seq_tipo_prestador%type, nr_seq_classif_prestador_p pls_pp_rp_filtro_prest.nr_seq_classif_prestador%type, nr_seq_grupo_prestador_p pls_pp_rp_filtro_prest.nr_seq_grupo_prestador%type, cd_condicao_pagamento_p pls_pp_rp_filtro_prest.cd_condicao_pagamento%type, ie_tipo_pessoa_prest_p pls_pp_rp_filtro_prest.ie_tipo_pessoa_prest%type, ie_tipo_data_ref_p pls_pp_lote.ie_tipo_dt_referencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
