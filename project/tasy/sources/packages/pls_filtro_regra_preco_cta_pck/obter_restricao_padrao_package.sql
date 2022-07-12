-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_padrao ( ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, dt_inicio_vigencia_p pls_cp_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_cp_cta_combinada.dt_fim_vigencia%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_w varchar(4000);


BEGIN
-- inicia a variavel com null

ds_restricao_w := null;

-- tratamento para inicio e fim de vigencia

if (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then

	-- se for regra para material

	if (ie_tipo_regra_p = 'M') then
	
		ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.dt_atendimento_referencia between ' ||
				  ' :dt_inicio_vigencia_pc and :dt_fim_vigencia_pc ' || pls_util_pck.enter_w;
	else
		ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.dt_procedimento_referencia between ' ||
				  ' :dt_inicio_vigencia_pc and :dt_fim_vigencia_pc ' || pls_util_pck.enter_w;
	end if;	
	
	valor_bind_p := sql_pck.bind_variable(	':dt_inicio_vigencia_pc', dt_inicio_vigencia_p, valor_bind_p);
	valor_bind_p := sql_pck.bind_variable(	':dt_fim_vigencia_pc', dt_fim_vigencia_p, valor_bind_p);
end if;

-- verifica os parametros que foram passados para a rotina e monta a restricao de acordo com o que foi informado

-- Lote da conta

if (nr_seq_lote_conta_p IS NOT NULL AND nr_seq_lote_conta_p::text <> '') then

	ds_restricao_w := ds_restricao_w ||' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('protocolo') || '.nr_seq_lote_conta = :nr_seq_lote_conta_pc ' ||
				pls_util_pck.enter_w;			
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_lote_conta_pc', nr_seq_lote_conta_p, valor_bind_p);
end if;

-- Protocolo

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then

	ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('protocolo') || '.nr_sequencia = :nr_seq_protocolo_pc ' ||
				pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_protocolo_pc', nr_seq_protocolo_p, valor_bind_p);
end if;

-- Lote de processo

if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then

	ds_restricao_w := ds_restricao_w || ' and     exists (select 1 ' || pls_util_pck.enter_w ||
					'		 from   pls_cta_lote_proc_conta processo ' || pls_util_pck.enter_w ||
					'		 where  processo.nr_seq_lote_processo = :nr_seq_lote_processo_pc ' || pls_util_pck.enter_w ||
					'		 and    processo.nr_seq_conta = ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_sequencia)' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_lote_processo_pc', nr_seq_lote_processo_p, valor_bind_p);
end if;

-- Conta

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_sequencia = :nr_seq_conta_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta_pc', nr_seq_conta_p, valor_bind_p);
end if;

-- Conta do procedimento 

if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	
	-- se por acaso for uma regra de material e foi passado um procedimento NAO deve retornar nada

	-- seNAO filtra o procedimento normalmente

	if (ie_tipo_regra_p = 'M') then
		ds_restricao_w := ds_restricao_w || ' and '|| pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_sequencia = -1 ' || pls_util_pck.enter_w;
	else
		ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.nr_sequencia = :nr_seq_conta_proc_pc ' ||
				  pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta_proc_pc', nr_seq_conta_proc_p, valor_bind_p);
	end if;
end if;

-- Conta do Material

if (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then

	-- se por acaso NAO for uma regra de material e foi passado um material NAO deve retornar nada

	-- seNAO filtra o procedimento normalmente

	if (ie_tipo_regra_p in ('P', 'S', 'PP')) then
		ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('procedimento') || '.nr_sequencia = -1 ' || pls_util_pck.enter_w;
	else
		ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('material') || '.nr_sequencia = :nr_seq_conta_mat_pc ' ||
				  pls_util_pck.enter_w;
		valor_bind_p := sql_pck.bind_variable(	':nr_seq_conta_mat_pc', nr_seq_conta_mat_p, valor_bind_p);
	end if;
end if;

-- Analise

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then

	ds_restricao_w := ds_restricao_w || 'and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.nr_seq_analise = :nr_seq_analise_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':nr_seq_analise_pc', nr_seq_analise_p, valor_bind_p);
end if;

-- Estabelecimento

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then

	ds_restricao_w := ds_restricao_w || ' and ' || pls_filtro_regra_preco_cta_pck.obter_alias_tabela('conta') || '.cd_estabelecimento = :cd_estabelecimento_pc ' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(	':cd_estabelecimento_pc', cd_estabelecimento_p, valor_bind_p);
end if;

-- retorna a restricao que sera utilizada no select

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_filtro_regra_preco_cta_pck.obter_restricao_padrao ( ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, dt_inicio_vigencia_p pls_cp_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_cp_cta_combinada.dt_fim_vigencia%type, nr_seq_lote_conta_p pls_protocolo_conta.nr_seq_lote%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;