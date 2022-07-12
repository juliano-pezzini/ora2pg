-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_tributacao_pck.obter_restricao_regra_trib ( cd_prestador_cod_p pls_pp_regra_vl_base_trib.cd_prestador_cod%type, dt_fim_vigencia_p pls_pp_regra_vl_base_trib.dt_fim_vigencia_ref%type, dt_inicio_vigencia_p pls_pp_regra_vl_base_trib.dt_inicio_vigencia_ref%type, ie_cooperado_p pls_pp_regra_vl_base_trib.ie_cooperado%type, ie_situacao_prest_p pls_pp_regra_vl_base_trib.ie_situacao_prest%type, nr_seq_classif_p pls_pp_regra_vl_base_trib.nr_seq_classificacao%type, nr_seq_evento_p pls_pp_regra_vl_base_trib.nr_seq_evento%type, nr_seq_grupo_prest_p pls_pp_regra_vl_base_trib.nr_seq_grupo_prestador%type, nr_seq_prestador_p pls_pp_regra_vl_base_trib.nr_seq_prestador%type, nr_seq_sit_coop_p pls_pp_regra_vl_base_trib.nr_seq_sit_coop%type, nr_seq_tipo_prest_p pls_pp_regra_vl_base_trib.nr_seq_tipo_prestador%type, nr_seq_regra_p pls_pp_regra_vl_base_trib.nr_sequencia%type, qt_excecao_p integer, ie_vencimento_p tributo.ie_vencimento%type, ie_pf_pj_p tributo.ie_pf_pj%type, ds_campos_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_w		varchar(20000);
ds_alias_lote_w		varchar(20);
ds_alias_prest_w	varchar(20);
ds_alias_item_w		varchar(20);
ds_campos_w		varchar(1500);


BEGIN

ds_campos_w := '';
ds_restricao_w := '';
ds_alias_lote_w := pls_pp_tributacao_pck.obter_alias_tabela('pls_pp_lote');
ds_alias_prest_w := pls_pp_tributacao_pck.obter_alias_tabela('pls_pp_prestador_tmp');
ds_alias_item_w := pls_pp_tributacao_pck.obter_alias_tabela('pls_pp_item_lote');

-- o evento e um campo obrigatorio na regra, porem e feito um not null para caso algum dia seja 

-- verificado a possibilidade de ele nao ser mais obrigatorio

if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then

	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_item_w || '.nr_seq_evento = :nr_seq_evento_p ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_evento_p', nr_seq_evento_p, valor_bind_p);
end if;

-- verifica se o tributo e PF/PJ ou ambos, caso seja ambos nao e necessario fazer nenhuma restricao.

if (ie_pf_pj_p = 'PF') then

	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_prest_w || '.ie_tipo_prestador = ''PF'' ' || pls_util_pck.enter_w;

elsif (ie_pf_pj_p = 'PJ') then

	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_prest_w || '.ie_tipo_prestador = ''PJ'' ' || pls_util_pck.enter_w;
end if;

-- a data sempre ira restringir so precisamos saber qual dos campos que sera utilizado

-- se for Vencimento do titulo ou Data contabil/registro compromisso entao e a data do vencimento

if (ie_vencimento_p in ('V', 'C')) then

	-- a data de vencimento do titulo ja esta salva na tabela pls_pp_prestador pois iremos precisar da mesma para

	-- realizar o calculo do tributo e buscar a base do tributo

	-- retorna o campo data no cursor com a data base do tributo, isto para em outras competencias ser utilizada para alimentar 

	-- a tabela de base acumulada

	ds_campos_w := ds_campos_w || ', trunc(' || ds_alias_prest_w || '.dt_venc_titulo, ''month'') dt_base ' || pls_util_pck.enter_w;
	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_prest_w || '.dt_venc_titulo between :dt_inicio_vigencia_p and :dt_fim_vigencia_p ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':dt_inicio_vigencia_p', dt_inicio_vigencia_p, valor_bind_p);
	valor_bind_p := sql_pck.bind_variable(':dt_fim_vigencia_p', dt_fim_vigencia_p, valor_bind_p);

-- senao e a data de competencia do lote

else
	-- retorna o campo data no cursor com a data base do tributo, isto para em outras competencias ser utilizada para alimentar 

	-- a tabela de base acumulada

	ds_campos_w := ds_campos_w || ', trunc(' || ds_alias_lote_w || '.dt_mes_competencia, ''month'') dt_base ' || pls_util_pck.enter_w;
	
	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_lote_w || '.dt_mes_competencia between :dt_inicio_vigencia_p and :dt_fim_vigencia_p ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':dt_inicio_vigencia_p', dt_inicio_vigencia_p, valor_bind_p);
	valor_bind_p := sql_pck.bind_variable(':dt_fim_vigencia_p', dt_fim_vigencia_p, valor_bind_p);
end if;

-- caso a sequencia do prestador tenha sido informada na regra nada mais precisa ser visto pois e a regra mais restritiva possivel

-- existem validacoes feitas no delphi para nao permitir ao usuario cadastrar nenhum outro campo

if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then

	ds_restricao_w := ds_restricao_w ||
				'and	' || ds_alias_prest_w || '.nr_seq_prestador = :nr_seq_prestador_p ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_prestador_p', nr_seq_prestador_p, valor_bind_p);

-- senao precisa validar os demais campos

else
	-- se existe regra de excecao entao inclui a restricao, nao pode existir regra de excecao caso a regra tenha nr_seq_prestador informado

	-- por este motivo a excecao esta no else

	if (qt_excecao_p > 0) then
	
		-- atualmente a regra de excecao conta apenas com dois campos (seq e cod do prestador) por este motivo podemos fazer 

		-- a restricao diretamente no select ganhando assim performance, porem caso mais campos forem criados havera a necessidade

		-- de alterar a estrutura para aplicar os filtros de excecao da mesma forma dos filtros da regra boa

		ds_restricao_w := ds_restricao_w ||
					'and not exists(	select	1' || pls_util_pck.enter_w ||
					'			from	pls_pp_regra_ex_vl_b_trib x' || pls_util_pck.enter_w ||
					'			where	x.nr_seq_regra = :nr_seq_regra' || pls_util_pck.enter_w ||
					'			and	x.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_seq_prestador' || pls_util_pck.enter_w ||
					'			union all' || pls_util_pck.enter_w ||
					'			select	1' || pls_util_pck.enter_w ||
					'			from	pls_pp_regra_ex_vl_b_trib x' || pls_util_pck.enter_w ||
					'			where	x.nr_seq_regra = :nr_seq_regra' || pls_util_pck.enter_w ||
					'			and	x.cd_prestador_cod = ' || ds_alias_prest_w || '.cd_prestador) ' || pls_util_pck.enter_w;

		valor_bind_p := sql_pck.bind_variable(':nr_seq_regra', nr_seq_regra_p, valor_bind_p);
	
	end if;

	-- codigo do prestador, e alimentado na tabela pls_pp_prestador

	if (cd_prestador_cod_p IS NOT NULL AND cd_prestador_cod_p::text <> '') then
	
		ds_restricao_w := ds_restricao_w ||
					'and	' || ds_alias_prest_w || '.cd_prestador = :cd_prestador_p ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':cd_prestador_p', cd_prestador_cod_p, valor_bind_p);
	end if;

	if (nr_seq_tipo_prest_p IS NOT NULL AND nr_seq_tipo_prest_p::text <> '') then
	
		ds_restricao_w := ds_restricao_w ||
					'and 	exists(	select	1 ' || pls_util_pck.enter_w ||
					'		from	pls_prestador_tipo tipo' || pls_util_pck.enter_w ||
					'		where	tipo.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_seq_prestador' || pls_util_pck.enter_w ||
					'		and	tipo.nr_seq_tipo = :nr_seq_tipo_prestador_p' || pls_util_pck.enter_w ||
					'		union all' || pls_util_pck.enter_w ||
					'		select	1 ' || pls_util_pck.enter_w ||
					'		from	pls_prestador tipo' || pls_util_pck.enter_w ||
					'		where	tipo.nr_sequencia = ' || ds_alias_prest_w || '.nr_seq_prestador' || pls_util_pck.enter_w ||
					'		and	tipo.nr_seq_tipo_prestador = :nr_seq_tipo_prestador_p)' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':nr_seq_tipo_prestador_p', nr_seq_tipo_prest_p, valor_bind_p);
	end if;
	
	-- se for apenas ativos

	if (ie_situacao_prest_p = 'A') then

		ds_restricao_w := ds_restricao_w ||
					'and	' || ds_alias_prest_w || '.ie_situacao = ''A'''|| pls_util_pck.enter_w;

	-- se for apenas inativos

	elsif (ie_situacao_prest_p = 'I') then

		ds_restricao_w := ds_restricao_w ||
					'and	' || ds_alias_prest_w || '.ie_situacao = ''I'''|| pls_util_pck.enter_w;
	end if;

	-- se o checkbox tiver marcado busca apenas os cooperados

	if (ie_cooperado_p = 'S') then
	
		ds_restricao_w := ds_restricao_w ||
					'and	' || ds_alias_prest_w || '.ie_cooperado = ''S'''|| pls_util_pck.enter_w;

		-- a situacao do cooperado so precisa ser verificada caso a regra seja para cooperado

		if (nr_seq_sit_coop_p IS NOT NULL AND nr_seq_sit_coop_p::text <> '') then

			ds_restricao_w := ds_restricao_w ||
						'and	' || ds_alias_prest_w || '.ie_situacao_cooperado = :nr_seq_sit_coop_p' || pls_util_pck.enter_w;
			valor_bind_p := sql_pck.bind_variable(':nr_seq_sit_coop_p', nr_seq_sit_coop_p, valor_bind_p);
		end if;
	end if;

	if (nr_seq_classif_p IS NOT NULL AND nr_seq_classif_p::text <> '') then

		ds_restricao_w := ds_restricao_w ||
					'and	' || ds_alias_prest_w || '.nr_seq_classificacao = :nr_seq_classif_p' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':nr_seq_classif_p', nr_seq_classif_p, valor_bind_p);
	end if;

	if (nr_seq_grupo_prest_p IS NOT NULL AND nr_seq_grupo_prest_p::text <> '') then
	
		ds_restricao_w := ds_restricao_w || 'and	(select count(1) ' || pls_util_pck.enter_w ||
							' 	from table(pls_grupos_pck.obter_prestadores_grupo( ' || pls_util_pck.enter_w ||
							' 		:nr_seq_grupo_prest_p, ' || ds_alias_prest_w || '.nr_seq_prestador))) > 0 ' || pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(':nr_seq_grupo_prest_p', nr_seq_grupo_prest_p, valor_bind_p);
	end if;
end if;

ds_campos_p := ds_campos_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_tributacao_pck.obter_restricao_regra_trib ( cd_prestador_cod_p pls_pp_regra_vl_base_trib.cd_prestador_cod%type, dt_fim_vigencia_p pls_pp_regra_vl_base_trib.dt_fim_vigencia_ref%type, dt_inicio_vigencia_p pls_pp_regra_vl_base_trib.dt_inicio_vigencia_ref%type, ie_cooperado_p pls_pp_regra_vl_base_trib.ie_cooperado%type, ie_situacao_prest_p pls_pp_regra_vl_base_trib.ie_situacao_prest%type, nr_seq_classif_p pls_pp_regra_vl_base_trib.nr_seq_classificacao%type, nr_seq_evento_p pls_pp_regra_vl_base_trib.nr_seq_evento%type, nr_seq_grupo_prest_p pls_pp_regra_vl_base_trib.nr_seq_grupo_prestador%type, nr_seq_prestador_p pls_pp_regra_vl_base_trib.nr_seq_prestador%type, nr_seq_sit_coop_p pls_pp_regra_vl_base_trib.nr_seq_sit_coop%type, nr_seq_tipo_prest_p pls_pp_regra_vl_base_trib.nr_seq_tipo_prestador%type, nr_seq_regra_p pls_pp_regra_vl_base_trib.nr_sequencia%type, qt_excecao_p integer, ie_vencimento_p tributo.ie_vencimento%type, ie_pf_pj_p tributo.ie_pf_pj%type, ds_campos_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;