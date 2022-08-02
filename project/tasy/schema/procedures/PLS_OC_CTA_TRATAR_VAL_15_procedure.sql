-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_15 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de coparticipação das ocorrências combinadas de conta médica
Ex: Coparticipação não gerada, Coparticipação gerada zerada..
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
jjung OS 602020 - Criação da procedure.
-------------------------------------------------------------------------------------------------------------------
jjung 29/06/2013

Alteração:	Adicionado parametro nos métodos de atualização dos campos IE_VALIDO e IE_VALIDO_TEMP
	da PLS_TIPOS_OCOR_PCK

Motivo:	Se tornou necessário diferenciar os filtros das validações na hora de realizar esta operação
	para que os filtros de exceção funcionem corretamente.
------------------------------------------------------------------------------------------------------------------
dlehmkuhl OS 688483 - 14/04/2014 -

Alteração:	Modificada a forma de trabalho em relação a atualização dos campos de controle
	que basicamente decidem se a ocorrência será ou não gerada. Foi feita também a
	substituição da rotina obterX_seX_geraX.

Motivo:	Necessário realizar essas alterações para corrigir bugs principalmente no que se
	refere a questão de aplicação de filtros (passo anterior ao da validação). Também
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para não inviabilizar a nova solicitação que diz que a exceção deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;

ds_select_w		varchar(4000);
ds_restricao_proc_w	varchar(1000);
ds_restricao_mat_w	varchar(1000);

var_cur_w 		integer;
var_exec_w		integer;
var_retorno_w		integer;

nr_seq_conta_w		pls_conta.nr_sequencia%type;
nr_seq_item_w		bigint;
ie_tipo_item_w		pls_oc_cta_selecao_ocor_v.ie_tipo_registro%type;
ie_registro_valido_w	varchar(1);
v_cur			pls_util_pck.t_cursor;
nr_seq_selecao_w	dbms_sql.number_table;
ds_observacao_w		dbms_sql.varchar2_table;
ie_valido_w		dbms_sql.varchar2_table;


-- Informações da validação de coparticipacao
C02 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
SELECT	a.nr_sequencia	nr_seq_validacao,
	a.ie_coparticipacao
from	pls_oc_cta_val_copartic a
where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

BEGIN
-- Deve haver informação da regra para que a validação seja aplicada
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then
	ie_registro_valido_w := 'S';

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	-- Varrer as informações parametrizadas para esta validação. No caso desta validação será apenas uma linha.
	for	r_C02_w in C02(dados_regra_p.nr_sequencia) loop

		--Verificar o tipo de situação conforme a parametrização do usuário.
		-- Se for para verificar itens com coparticipação zerada
		if (r_C02_w.ie_coparticipacao = 'CZ') then

			-- Deve ser retornado no select os itens quais foi gerado registro de coparticipação porém o valor é zerado ou não informado
			ds_restricao_proc_w :=	'and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'		select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'		from	pls_conta_coparticipacao cop ' || pls_tipos_ocor_pck.enter_w ||
						'		where	cop.nr_seq_conta = sel.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'		and	cop.nr_seq_conta_proc = sel.nr_seq_conta_proc ' || pls_tipos_ocor_pck.enter_w ||
						'		and	(cop.vl_coparticipacao <= 0 or vl_coparticipacao is null)' || pls_tipos_ocor_pck.enter_w ||
						'	) ';

			ds_restricao_mat_w :=	'and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'		select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'		from	pls_conta_coparticipacao cop ' || pls_tipos_ocor_pck.enter_w ||
						'		where	cop.nr_seq_conta = sel.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'		and	cop.nr_seq_conta_mat = sel.nr_seq_conta_mat ' || pls_tipos_ocor_pck.enter_w ||
						'		and	(cop.vl_coparticipacao <= 0 or vl_coparticipacao is null) ' || pls_tipos_ocor_pck.enter_w ||
						'	) ';
		-- Se for para verificar itens sem regra de coparticipacao
		elsif (r_C02_w.ie_coparticipacao = 'SR') then

			-- Deve ser retornado no select os itens quais deveria ter sido gerada a coparticipação porém não existe registro de coparticipacao gerado.
			ds_restricao_proc_w :=	'and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'		select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'		from	pls_conta_proc_ocor_v proc ' || pls_tipos_ocor_pck.enter_w ||
						'		where	proc.nr_seq_conta = sel.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'		and	proc.nr_sequencia = sel.nr_seq_conta_proc ' || pls_tipos_ocor_pck.enter_w ||
						'		and	proc.ie_coparticipacao = ''S'' ' || pls_tipos_ocor_pck.enter_w ||
						'		and	not exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'					select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'					from	pls_conta_coparticipacao cop ' || pls_tipos_ocor_pck.enter_w ||
						'					where	cop.nr_seq_conta = proc.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'					and	cop.nr_seq_conta_proc = proc.nr_sequencia ' || pls_tipos_ocor_pck.enter_w ||
						'				) ' || pls_tipos_ocor_pck.enter_w ||
						'	) ';

			ds_restricao_mat_w :=	'and	exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'		select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'		from	pls_conta_mat_ocor_v mat ' || pls_tipos_ocor_pck.enter_w ||
						'		where	mat.nr_seq_conta = sel.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'		and	mat.nr_sequencia = sel.nr_seq_conta_mat ' || pls_tipos_ocor_pck.enter_w ||
						'		and	mat.ie_coparticipacao = ''S'' ' || pls_tipos_ocor_pck.enter_w ||
						'		and	not exists ( ' || pls_tipos_ocor_pck.enter_w ||
						'					select	1 ' || pls_tipos_ocor_pck.enter_w ||
						'					from	pls_conta_coparticipacao cop ' || pls_tipos_ocor_pck.enter_w ||
						'					where	cop.nr_seq_conta = mat.nr_seq_conta ' || pls_tipos_ocor_pck.enter_w ||
						'					and	cop.nr_seq_conta_mat = mat.nr_sequencia ' || pls_tipos_ocor_pck.enter_w ||
						'				) ' || pls_tipos_ocor_pck.enter_w ||
						'	) ';
		end if;

		ds_select_w	:=	'select	sel.nr_sequencia nr_seq_selecao, ' || pls_tipos_ocor_pck.enter_w ||
					'	'''||ie_registro_valido_w||''' ie_registro_valido, ' ||pls_tipos_ocor_pck.enter_w||
					' 	null ds_obervacao ' ||pls_tipos_ocor_pck.enter_w||
					'from	pls_oc_cta_selecao_ocor_v sel ' || pls_tipos_ocor_pck.enter_w ||
					'where	sel.nr_id_transacao = :nr_id_transacao ' || pls_tipos_ocor_pck.enter_w ||
					'and	sel.ie_valido = ''S'' ' || pls_tipos_ocor_pck.enter_w ||
					'and	sel.ie_tipo_registro = ''P'' ' || pls_tipos_ocor_pck.enter_w ||
					ds_restricao_proc_w || pls_tipos_ocor_pck.enter_w ||
					'union all ' || pls_tipos_ocor_pck.enter_w ||
					'select	sel.nr_sequencia nr_seq_selecao, ' || pls_tipos_ocor_pck.enter_w ||
					'	'''||ie_registro_valido_w||''' ie_registro_valido, ' ||pls_tipos_ocor_pck.enter_w||
					' 	null ds_obervacao ' ||pls_tipos_ocor_pck.enter_w||
					'from	pls_oc_cta_selecao_ocor_v sel ' || pls_tipos_ocor_pck.enter_w ||
					'where	sel.nr_id_transacao = :nr_id_transacao ' || pls_tipos_ocor_pck.enter_w ||
					'and	sel.ie_valido = ''S'' ' || pls_tipos_ocor_pck.enter_w ||
					'and	sel.ie_tipo_registro = ''M'' ' || pls_tipos_ocor_pck.enter_w ||
					ds_restricao_mat_w;
		begin
			open v_cur for EXECUTE ds_select_w using 	nr_id_transacao_p, nr_id_transacao_p;
			loop
				nr_seq_selecao_w	:= pls_util_cta_pck.num_table_vazia_w;
				ie_valido_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				ds_observacao_w		:= pls_util_cta_pck.vchr2_table_vazia_w;
				fetch v_cur bulk collect
				into  nr_seq_selecao_w, ie_valido_w, ds_observacao_w
				limit pls_util_cta_pck.qt_registro_transacao_w;
					exit when nr_seq_selecao_w.count = 0;

					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao( nr_seq_selecao_w, pls_util_cta_pck.clob_table_vazia_w, 'SEQ', ds_observacao_w,
										ie_valido_w, nm_usuario_p);
			end loop;
			close v_cur;
		exception
			when others then
				--Fecha cursor
				close v_cur;
				-- Insere o log na tabela e aborta a operação
				CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p ,ds_select_w , nr_id_transacao_p, nm_usuario_p);
		end;

	end loop; -- C02
	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_15 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

