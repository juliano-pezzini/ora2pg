-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ocor_imp_pck.obter_se_processa_filtro ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, qt_filtro_processado_p integer, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, ie_incidencia_selecao_regra_p text, ie_incidencia_selecao_filtro_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE


ie_processa_w		varchar(1);
qt_registro_valido_w	integer;
ds_select_w		varchar(8000);
valor_bind_w		sql_pck.t_dado_bind;
cursor_w		sql_pck.t_cursor;
qt_max_reg_selecao_w	integer;


BEGIN
-- Funaao criada para verificar se a regra do filtro precisa ser processada. 

-- Ela verifica se a quantidade maxima dos itens que fazem podem ser selecionados

-- ja existem na tabela. Os possaveis retornos sao: S -> processa, N -> nao processa e 

-- Z para de executar todas as regras de filtro


ie_processa_w := 'S';
-- quantidade de registros que estao validos na tabela de seleaao

qt_registro_valido_w := pls_ocor_imp_pck.obter_qt_registro_valido(nr_id_transacao_p);

-- se estiver na primeira regra ou se estiver processando uma regra de 

if (qt_filtro_processado_p = 0) then	
	ie_processa_w := 'S';
	
-- se for para processar algo que somente invalide registros e nao tem mais nada valido na tabela de seleaao nem processa

-- a leitura a a seguinte: se for filtro de exceaao ou regra de exceaao mais nao a regra e filtro de exceaao e nao tem registro valido

elsif	((ie_filtro_excecao_p = 'S' or ie_regra_excecao_p = 'S') and (ie_filtro_excecao_p != 'S' or ie_regra_excecao_p != 'S') and (qt_registro_valido_w = 0)) then
	ie_processa_w := 'N';

-- se nao existirem mais registros validos na tabela de seleaao e for um filtro de exceaao em uma regra boa, simplesmente nao precisa mais executar nada.

-- os filtros de exceaao somente tiram registros fora, nunca colocam novos e se nao tem mais nada valido a inatil ficar processando elas.

-- sa deixa ativar novos registros se for uma regra de exceaao com um filtro de exceaao

-- no momento de ler as regras existe um order by que coloca as regras de exceaao para serem processadas por altimo, por isso esse if abaixo resolver a situaaao sem causar problemas.

-- isso aumenta a performance em cenarios onde existe uma regra normal e nove regras de exceaao (cenario tapico em varios clientes)

elsif (ie_filtro_excecao_p = 'S' and ie_regra_excecao_p = 'N' and qt_registro_valido_w = 0) then
	ie_processa_w := 'Z';
	
-- sa precisa verificar para filtros que nao forem de exceaao em regras que nao sao de exceaao, pois os de exceaao podem tirar registros

elsif (ie_filtro_excecao_p = 'N' and ie_regra_excecao_p = 'N') then

	valor_bind_w := pls_ocor_imp_pck.obter_select_filtro(	true, ie_incidencia_selecao_regra_p, ie_incidencia_selecao_filtro_p, ie_processo_excecao_p, nr_seq_ocorrencia_p, nr_id_transacao_p, nr_seq_filtro_p, nr_seq_lote_protocolo_p, nr_seq_protocolo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, dt_inicio_vigencia_p, dt_fim_vigencia_p, null, null, null, null, null, null, null, null, null, cd_estabelecimento_p, valor_bind_w);
						
	ds_select_w := 'select count(1) from ( ' || ds_select_w || ')';

	-- executa o comando sql com os respectivos binds

	valor_bind_w := sql_pck.executa_sql_cursor(	ds_select_w, valor_bind_w);
	-- retorna a quantidade maxima possavel de registros para a tabela de seleaao

	fetch cursor_w into qt_max_reg_selecao_w;
	close cursor_w;
		
	-- se conseguiu trazer registros

	if ((qt_max_reg_selecao_w IS NOT NULL AND qt_max_reg_selecao_w::text <> '') and qt_max_reg_selecao_w > 0) then
		-- se a quantidade de registros validos for igual a quantidade maxima de registros possaveis na tabela de seleaao

		if (qt_max_reg_selecao_w = qt_registro_valido_w) then
			ie_processa_w := 'N';
		end if;
	else
		ie_processa_w := 'S';
	end if;
end if;

return ie_processa_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ocor_imp_pck.obter_se_processa_filtro ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, qt_filtro_processado_p integer, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, ie_filtro_excecao_p pls_oc_cta_filtro.ie_excecao%type, ie_incidencia_selecao_regra_p text, ie_incidencia_selecao_filtro_p text, ie_processo_excecao_p text, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_filtro_p pls_oc_cta_filtro.nr_sequencia%type, nr_seq_lote_protocolo_p pls_protocolo_conta_imp.nr_seq_lote_protocolo%type, nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, nr_seq_conta_p pls_conta_imp.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_imp.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_imp.nr_sequencia%type, dt_inicio_vigencia_p pls_oc_cta_combinada.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_oc_cta_combinada.dt_fim_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
