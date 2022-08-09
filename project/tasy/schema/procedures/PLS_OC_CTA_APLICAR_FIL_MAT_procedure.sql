-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplicar_fil_mat ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, ie_incidencia_regra_p text, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, qt_registro_selecao_p integer default null) AS $body$
DECLARE

					 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Verificar se a conta se encaixa nos filtros específicos de conta para 
as ocorrências combinadas de conta médica. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
 
Não incluir restrições nessa procedure, ela é responsável apenas por passar no cursor 
dos filtros de conta e incluir na seleção das contas que devem ter a ocorrência gerada. 
 
Respeitar o conceito de granularidade dos dados durante a montagem das restrições, deve ser respeitado a 
ordem de acesso as tabelas, olhando sempre do maior nível para o menor, começando do lote para o protocolo, 
daí para a conta, para os itens e enfim os participantes. 
 
Alterações: 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 601441 06/06/2013 - 
Alteração:	Linha: 103 
	Alterado parâmetro ie_tipo_registro_p da rotina 
	PLS_TIPOS_OCOR_PCK.GERENCIA_SELECAO_REGISTROS para usar o valor 
	do parameto ie_incidencia_regra_p. 
Motivo: 
	Para que a ocorrência seja lançada para o item ou para a conta de maneira correta. 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 601977 10/06/2013 - 
Alteração: 	Linhas 60 e 113 - Incluído tratamento para alimentação do campo ie_valido_temp 
 
Motivo: 	Para que quando o registro for válido para um filtro e não for válido para o outro 
	o campo ie_valido da tabela de selecao fique como N para que não seja gerada 
	ocorrencia para o item. 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 601998 14/06/2013 - 
Alteração: 	Alterado forma de aplicar os filtros para usar a restrição dentro dos select que será obtido 
	e não concatenar a restrição no select padrão. 
 
Motivo: 	Quando a validação for aplicada em procedimentos ou materiais para que seja possível aplicar 
	os filtros corretos conforme os cadastros do usuário . 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 602057 18/06/2013 - 
 
Alteração:	Foi incluído parâmetro na procedure pls_tipos_ocor_pck.gerencia_selecao_registros 
	para utilizar retorno da function pls_tipos_ocor_pck.obter_se_valido. 
	 
Motivo:	A lógica deste tratamento foi removida da procedure de gerenciamento de selecao dos registros 
	para que evitasse problemas e confusão nas validações. 
------------------------------------------------------------------------------------------------------------------ 
jjung 29/06/2013 
 
Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP 
	da PLS_TIPOS_OCOR_PCK 
	 
Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação 
	para que os filtros de exceção funcionem corretamente. 
------------------------------------------------------------------------------------------------------------------ 
jjung 10/07/2013 
 
Alteração:	Modificado lugar de chamada da atualização dos campos ie_valido_temp e ie_valido da tabela 
	de seleção para fora do for. 
	 
Motivo:	Foi identificado que quando um filtro tinha mais de uma regrinha cadastrado para ele não estava 
	funcionando corretamente. 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 604666 - 29/07/2013 - 
 
Alteração:	Substituído rotinas de manipulação de restrições e selects dinâmicos para as novas: 
	PLS_OC_CTA_MONTAR_SEL_PAD e PLS_OC_CTA_OBTER_RESTR_PADRAO. 
	 
Motivo:	Surgiu a necessidade de separar as restrições devido a criação de reconsistência das ocorrências 
	durante ações no processo de análise. Como deparamos com um cenário diferente do anterior 
	decidimos que seriam criadas novas rotinas para não estragarmos o estado atual e para que pudéssemos 
	atender da melhor forma as novas necessidades das ocorrências. 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 659644 - 22/10/2013 - 
 
Alteração:	Substituído a forma de gravação dos registros no banco para ser feito com arrays e utilizar 
	a estrutura do DEFINE_ARRAY para alimentar as listas em apenas um comando COLUMN_VALUE 
	 
Motivo:	Foi identificado que grande parte do consumo de recursos da geração da ocorrência combinada 
	estava sendo consumido em acessos ao banco para gravar e atualizar a tabela de seleção. Foi utilizado 
	então o comando FORALL que grava e atualiza todos os registros de uma lista no banco em apenas um 
	acesso ao contexto SQL. 
------------------------------------------------------------------------------------------------------------------ 
francisco OS 657536 - 31/10/2013 
 
Alteração:	Incluído tratamento para nova restrição de filtro NR_SEQ_ESTRUT_MAT 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 666950 - 13/11/2013 - 
 
Alteração:	Foi recolocado a chamada para a procedure PLS_TIPOS_OCOR_PCK.ATUALIZA_SEL_IE_VALIDO_TEMP. 
 
Motivo:	Foi identificado que a falta da execução desta rotina ocasionava em falhas no processo 
	de geração da ocorrência onde existiam dois filtros no nível da conta, onde por conta o registro era válido 
	e pela outra característica o item não era atendido, desta forma ainda estava sendo gerada a ocorrência. 
------------------------------------------------------------------------------------------------------------------ 
jjung OS 709376 - 03/03/2014 
 
Alteração:	Adicionado parâmetro dados_forma_geracao_p para passar até na pls_oc_cta_obter_restr_padrao 
 
Motivo:	Como no campo Consistência web na regra pode ser informado Ambos o mais correto é tratar 
	pelo evento sendo executado e não pelo evento informado na regra. 
 ------------------------------------------------------------------------------------------------------------------ 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
dados_filtro_mat_w	pls_tipos_ocor_pck.dados_filtro_mat;			
 
PERFORM_completo_w	varchar(8000);
dados_restricao_w	pls_tipos_ocor_pck.dados_restricao_select;

var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;
qt_cnt_w		integer;

nr_seq_conta_w		dbms_sql.number_table;
nr_seq_conta_proc_w	dbms_sql.number_table;
nr_seq_conta_mat_w	dbms_sql.number_table;
nr_seq_selecao_w	dbms_sql.clob_table;
ds_observacao_w		dbms_sql.varchar2_table;

ret_null_w		varchar(1);

-- FIltros informados 
C_filtro CURSOR(nr_seq_filtro_pc	pls_oc_cta_filtro.nr_sequencia%type) FOR 
	SELECT	a.nr_seq_material, 
		a.ie_tipo_despesa_mat, 
		a.nr_seq_grupo_material, 
		a.ie_feriado, 
		a.dt_dia_semana, 
		a.hr_inicial, 
		a.hr_final, 
		a.ie_tipo_feriado, 
		a.ie_tipo_data, 
		a.ie_consistencia_valor, 
		a.vl_max_item, 
		a.vl_minimo_item, 
		a.nr_seq_estrut_mat 
	from	pls_oc_cta_filtro_mat a 
	where	a.nr_seq_oc_cta_filtro	= nr_seq_filtro_pc;
BEGIN
 
-- Se não tiver informações da regra não será possível aplicar os filtros. 
if (dados_filtro_p.nr_sequencia IS NOT NULL AND dados_filtro_p.nr_sequencia::text <> '') then 
 
	-- Obter o controle padrão para quantidade de registros que será enviada a cada vez para a tabela de seleção. 
	qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;
 
	-- Atualizar o campo ie_valido_temp. 
	CALL pls_tipos_ocor_pck.atualiza_sel_ie_valido_temp(nr_id_transacao_p, dados_filtro_p, 'F', dados_regra_p);
	 
	-- verifica se existe algo para atualizar nas tabelas TM 
	CALL pls_gerencia_upd_obj_pck.atualizar_objetos(nm_usuario_p, 'PLS_OC_CTA_APLICAR_FIL_MAT', 'PLS_ESTRUTURA_MATERIAL_TM');
	CALL pls_gerencia_upd_obj_pck.atualizar_objetos(nm_usuario_p, 'PLS_OC_CTA_APLICAR_FIL_MAT', 'PLS_GRUPO_MATERIAL_TM');
	 
	-- Passar para todos os filtros da regra. 
	for	r_c_filtro_w in C_filtro(dados_filtro_p.nr_sequencia) loop 
 
		-- Atualizar a variável com os dados do filtro 
		dados_filtro_mat_w.nr_seq_material		:= r_c_filtro_w.nr_seq_material;
		dados_filtro_mat_w.ie_tipo_despesa_mat		:= r_c_filtro_w.ie_tipo_despesa_mat;
		dados_filtro_mat_w.nr_seq_grupo_material	:= r_c_filtro_w.nr_seq_grupo_material;
		dados_filtro_mat_w.ie_feriado			:= r_c_filtro_w.ie_feriado;
		dados_filtro_mat_w.dt_dia_semana		:= r_c_filtro_w.dt_dia_semana;
		dados_filtro_mat_w.hr_inicial			:= r_c_filtro_w.hr_inicial;
		dados_filtro_mat_w.hr_final			:= r_c_filtro_w.hr_final;
		dados_filtro_mat_w.ie_tipo_feriado		:= r_c_filtro_w.ie_tipo_feriado;
		dados_filtro_mat_w.ie_tipo_data			:= r_c_filtro_w.ie_tipo_data;
		dados_filtro_mat_w.ie_consistencia_valor	:= r_c_filtro_w.ie_consistencia_valor;
		dados_filtro_mat_w.vl_max_item			:= r_c_filtro_w.vl_max_item;
		dados_filtro_mat_w.vl_minimo_item		:= r_c_filtro_w.vl_minimo_item;
		dados_filtro_mat_w.nr_seq_estrut_mat		:= r_c_filtro_w.nr_seq_estrut_mat;
		 
		-- Obter restrições 
		dados_restricao_w := pls_oc_cta_obter_restr_padrao( 
						'RESTRICAO', dados_consistencia_p, nr_id_transacao_p, dados_regra_p, 
						ie_incidencia_regra_p, null, dados_filtro_p, dados_forma_geracao_ocor_p, 
						cd_estabelecimento_p, nm_usuario_p, 'S', 'N', qt_registro_selecao_p);
		 
		-- Como a restrição por material é aplicável para o nível de item então a restrição montada pelo filtro será aplicada juntamente com a restrição padrão por material, pois conforme 
		-- a regra de granularidade os itens devem ser acessados apenas por último e somenete se os demais dados foram validados, portanto cada tipo de filtro deve ser aplicado ao seu nível. 
		dados_restricao_w.ds_restricao_mat	:= dados_restricao_w.ds_restricao_mat || pls_oc_cta_obter_restr_mat('RESTRICAO',dados_regra_p,var_cur_w,dados_filtro_mat_w);
		 
		-- Montar o select junto com as restrições 
		PERFORM_completo_w := pls_tipos_ocor_pck.montar_select_padrao(dados_regra_p, dados_filtro_p, ie_incidencia_regra_p, dados_restricao_w, nm_usuario_p);
		 
		-- Abrir um novo cursor 
		var_cur_w := dbms_sql.open_cursor;
		begin 
			-- Criar o cursor 
			dbms_sql.parse(var_cur_w, select_completo_w, 1);
			 
			-- Trocar BINDS 
			-- Do select original 
			dados_restricao_w := pls_oc_cta_obter_restr_padrao( 
							'BINDS', dados_consistencia_p, nr_id_transacao_p, dados_regra_p, 
							ie_incidencia_regra_p, var_cur_w, dados_filtro_p, dados_forma_geracao_ocor_p, 
							cd_estabelecimento_p, nm_usuario_p, 'S', 'N', qt_registro_selecao_p);
			 
			-- Trocar binds do select Mats 
			ret_null_w := pls_oc_cta_obter_restr_mat('BIND',dados_regra_p,var_cur_w,dados_filtro_mat_w);
			 
			-- Definir para o DBMS_SQL que o retorno do select será preenchido em arrays, definindo a quantidade de linhas que o array terá a cada iteração do loop 
			-- e a posição inicial que estes ocuparão no array. 
			dbms_sql.define_array(var_cur_w, 1, nr_seq_conta_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 2, nr_seq_conta_proc_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 3, nr_seq_conta_mat_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 4, ds_observacao_w, qt_cnt_w, 1);
			dbms_sql.define_array(var_cur_w, 5, nr_seq_selecao_w, qt_cnt_w, 1);
			 
			 
			var_exec_w := dbms_sql.execute(var_cur_w);
			loop 
			-- O fetch rows irá preencher os buffers do Oracle com as linhas que serão passadas para a lista quando o COLUMN_VALUE for chamado. 
			var_retorno_w := dbms_sql.fetch_rows(var_cur_w);
				 
				-- zerar as listas para que o mesmo valor não seja inserido mais de uma vez na tabela. 
				nr_seq_conta_w.delete;
				nr_seq_conta_proc_w.delete;		
				nr_seq_conta_mat_w.delete;
				ds_observacao_w.delete;
				nr_seq_selecao_w.delete;
				 
				-- Obter as listas que foram populadas. 
				dbms_sql.column_value(var_cur_w, 1, nr_seq_conta_w);
				dbms_sql.column_value(var_cur_w, 2, nr_seq_conta_proc_w);
				dbms_sql.column_value(var_cur_w, 3, nr_seq_conta_mat_w);
				dbms_sql.column_value(var_cur_w, 4, ds_observacao_w);
				dbms_sql.column_value(var_cur_w, 5, nr_seq_selecao_w);
				 
				-- Insere todos os registros das listas na tabela de seleção em um único insert. 
				pls_tipos_ocor_pck.gerencia_selecao(	nr_id_transacao_p, nr_seq_conta_w , 
									nr_seq_conta_proc_w, nr_seq_conta_mat_w, 
									nr_seq_selecao_w, ds_observacao_w, 'S', 
									nm_usuario_p, 'F', dados_filtro_p, dados_regra_p);
									 
				-- Quando número de linhas que foram aplicadas no array for diferente do definido significa que esta foi a última iteração do loop e que todas as linhas foram 
				-- passadas. 
				exit when var_retorno_w != qt_cnt_w;
				 
			end loop; -- Contas filtradas 
			dbms_sql.close_cursor(var_cur_w);
		exception 
			when others then				 
			-- Fechar os cursores que continuam abertos, os cursores que utilizam FOR - LOOP não necessitam serem fechados, serão fechados automáticamente. 
			-- Contas. 
			if (dbms_sql.is_open(var_cur_w)) then 
			 
				dbms_sql.close_cursor(var_cur_w);
			end if;
			 
			-- Insere o log na tabela e aborta a operação 
			CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,select_completo_w,nr_id_transacao_p,nm_usuario_p);
		end;
	end loop;--C_filtro 
 
	-- Atualiza o campo ie_valido da tabela PLS_SELECAO_OCOR_CTA para N aonde o ie_valido_temp continuar N 
	CALL pls_tipos_ocor_pck.atualiza_sel_ie_valido(nr_id_transacao_p, dados_filtro_p, 'F', dados_regra_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplicar_fil_mat ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_consistencia_p pls_tipos_ocor_pck.dados_consistencia, dados_forma_geracao_ocor_p pls_tipos_ocor_pck.dados_forma_geracao_ocor, ie_incidencia_regra_p text, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, qt_registro_selecao_p integer default null) FROM PUBLIC;
