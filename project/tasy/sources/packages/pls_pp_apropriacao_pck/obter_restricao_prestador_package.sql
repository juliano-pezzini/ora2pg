-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_apropriacao_pck.obter_restricao_prestador ( nr_seq_prestador_p pls_pp_rp_filtro_prest.nr_seq_prestador%type, cd_prestador_cod_p pls_pp_rp_filtro_prest.cd_prestador_cod%type, nr_seq_tipo_prestador_p pls_pp_rp_filtro_prest.nr_seq_tipo_prestador%type, nr_seq_classif_prestador_p pls_pp_rp_filtro_prest.nr_seq_classif_prestador%type, nr_seq_grupo_prestador_p pls_pp_rp_filtro_prest.nr_seq_grupo_prestador%type, cd_condicao_pagamento_p pls_pp_rp_filtro_prest.cd_condicao_pagamento%type, ie_tipo_pessoa_prest_p pls_pp_rp_filtro_prest.ie_tipo_pessoa_prest%type, ie_prest_vinc_lote_p pls_pp_rp_filtro_prest.ie_prest_vinc_lote%type, nr_seq_lote_p pls_pp_lote.nr_sequencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_prest_w	varchar(2500);
ds_alias_prest_w	varchar(10);
ds_campos_w		varchar(500);
ds_tabela_w		varchar(200);


BEGIN
ds_restricao_prest_w := null;
ds_campos_w := null;
ds_tabela_w := null;
ds_alias_prest_w := pls_pp_apropriacao_pck.obter_alias_tabela('pls_pp_prestador_tmp');

-- só pode ter sequencia ou código informado no cadastro, nunca os dois
-- sequencia prestador
if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then

	ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.nr_sequencia = :nr_seq_prestador_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_prestador_pc', nr_seq_prestador_p, valor_bind_p);

-- código prestador
elsif (cd_prestador_cod_p IS NOT NULL AND cd_prestador_cod_p::text <> '') then

	ds_restricao_prest_w := ds_restricao_prest_w || ' and ' || ds_alias_prest_w || '.cd_prestador = :cd_prestador_cod_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':cd_prestador_cod_pc', cd_prestador_cod_p, valor_bind_p);
end if;

-- tipo do prestador
if (nr_seq_tipo_prestador_p IS NOT NULL AND nr_seq_tipo_prestador_p::text <> '') then

	-- todo select sempre faz join com a pls_prestador, por isso o filtro pode ser feito desta forma
	ds_restricao_prest_w	:= ds_restricao_prest_w ||
				' and	exists	(select	1 ' ||
				'		from	pls_prestador_tipo pretip' || pls_util_pck.enter_w ||
				'		where	pretip.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				'		and	pretip.nr_seq_tipo = :nr_seq_tipo_prestador_pc' || pls_util_pck.enter_w ||
				'		union all' || pls_util_pck.enter_w ||
				'		select	1 ' || pls_util_pck.enter_w ||
				'		from	pls_prestador pretip' || pls_util_pck.enter_w ||
				'		where	pretip.nr_sequencia = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				'		and	pretip.nr_seq_tipo_prestador = :nr_seq_tipo_prestador_pc)' || pls_util_pck.enter_w;

	valor_bind_p := sql_pck.bind_variable(':nr_seq_tipo_prestador_pc', nr_seq_tipo_prestador_p, valor_bind_p);
end if;

-- classificação do prestador
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

-- condição de pagamento do prestador
if (cd_condicao_pagamento_p IS NOT NULL AND cd_condicao_pagamento_p::text <> '') then
	
	-- todo select sempre faz join com a pls_prestador, por isso o filtro pode ser feito desta forma
	ds_restricao_prest_w	:= ds_restricao_prest_w ||
				' and	exists	(select	1 ' ||
				'		from	pls_prestador_pagto prepag' || pls_util_pck.enter_w ||
				'		where	prepag.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_sequencia' || pls_util_pck.enter_w ||
				'		and	prepag.cd_condicao_pagamento = :cd_condicao_pagamento_pc) ';
	valor_bind_p := sql_pck.bind_variable(':cd_condicao_pagamento_pc', cd_condicao_pagamento_p, valor_bind_p);
end if;

-- tipo de pessoa do prestador
-- só existe PF e PJ, se for ambos (A) não precisa filtrar nada
-- é feita a inclusão das tabelas pessoa_fisica ou pessoa_juridica para validar o tipo do prestador
-- preferi fazer com join em outra tabela para garantir a performance no caso de existir um filtro somente com este campo informado
if (ie_tipo_pessoa_prest_p in ('PF', 'PJ')) then

	-- pessoa física
	if (ie_tipo_pessoa_prest_p = 'PF') then

		ds_tabela_w :=  ds_tabela_w || ', ' || pls_util_pck.enter_w ||
				'pessoa_fisica pf';
		ds_restricao_prest_w := ds_restricao_prest_w || ' and pf.cd_pessoa_fisica = ' || ds_alias_prest_w || '.cd_pessoa_fisica' || pls_util_pck.enter_w ||
								' and ' || ds_alias_prest_w || '.ie_tipo_pessoa = ''PF''' || pls_util_pck.enter_w;
	end if;

	-- pessoa jurídica
	if (ie_tipo_pessoa_prest_p = 'PJ') then

		ds_tabela_w :=  ds_tabela_w || ', ' || pls_util_pck.enter_w ||
				'pessoa_juridica pj';
		ds_restricao_prest_w := ds_restricao_prest_w || ' and pj.cd_cgc = ' || ds_alias_prest_w || '.cd_cgc' || pls_util_pck.enter_w;
	end if;
end if;

-- filtrar somente os prestadores que já tiveram algum vínculo no lote de pagamento, seja de eventos financeiros ou produção
if (ie_prest_vinc_lote_p = 'S') then

	ds_restricao_prest_w := ds_restricao_prest_w || ' and exists(	select	1' || pls_util_pck.enter_w ||
							'		from	pls_pp_lote_prest_event x' || pls_util_pck.enter_w ||
							'		where	x.nr_seq_lote = :nr_seq_lote_pc' || pls_util_pck.enter_w ||
							'		and	x.nr_seq_prestador = ' || ds_alias_prest_w || '.nr_seq_prestador)' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_lote_pc', nr_seq_lote_p, valor_bind_p);
end if;

ds_campos_p := ds_campos_w;
ds_tabela_p := ds_tabela_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_apropriacao_pck.obter_restricao_prestador ( nr_seq_prestador_p pls_pp_rp_filtro_prest.nr_seq_prestador%type, cd_prestador_cod_p pls_pp_rp_filtro_prest.cd_prestador_cod%type, nr_seq_tipo_prestador_p pls_pp_rp_filtro_prest.nr_seq_tipo_prestador%type, nr_seq_classif_prestador_p pls_pp_rp_filtro_prest.nr_seq_classif_prestador%type, nr_seq_grupo_prestador_p pls_pp_rp_filtro_prest.nr_seq_grupo_prestador%type, cd_condicao_pagamento_p pls_pp_rp_filtro_prest.cd_condicao_pagamento%type, ie_tipo_pessoa_prest_p pls_pp_rp_filtro_prest.ie_tipo_pessoa_prest%type, ie_prest_vinc_lote_p pls_pp_rp_filtro_prest.ie_prest_vinc_lote%type, nr_seq_lote_p pls_pp_lote.nr_sequencia%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
