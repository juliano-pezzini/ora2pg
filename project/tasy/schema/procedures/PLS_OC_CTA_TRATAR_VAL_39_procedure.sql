-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_39 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Aplicar a validação de quantidade de auxiliares. Caso seja permitido 2 auxiliares para o
procedimento, o sistema somente irá tratar os registros que possuem até posiçao 2.
Posição: Cadastros gerais\Plano de Saúde\OPS - Contas Médicas\Grau de participação auxiliar.
Comparado com o grau de participação informado na conta.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Alterações:
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
jjung OS 659985 -

Alteração:
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_tb_selecao_w		pls_tipos_ocor_pck.dados_table_selecao_ocor;

ds_select_w		text;

-- Informações da validação de não-utilização de item autorizado
C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia	nr_seq_validacao,
		a.ie_consiste_nr_auxiliar
	from	pls_oc_cta_val_auxiliares a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

-- Cenário atual dos procedimentos na tabela de seleção
cs_procs_selecao CURSOR(nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		'A quantidade de auxiliares excede a permitida para este procedimento. '||pls_obter_ds_aux_excedeu(proc.nr_seq_conta, proc.nr_sequencia,  proc.nr_auxiliares)  ds_observacao,
		pls_obter_se_qtde_aux_excedeu(null, proc.nr_seq_conta, proc.nr_sequencia,  proc.nr_auxiliares, null, null)ie_valido
	from	pls_oc_cta_selecao_ocor_v sel,
		pls_conta_proc_ocor_v proc
	where	sel.nr_id_transacao 	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	sel.nr_seq_conta_proc 	= proc.nr_sequencia
	and	sel.ie_tipo_registro 	= 'P';

BEGIN

-- Deve ter a informação da regra para que seja aplicada a validação.
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '')  then

	for r_C01_w in C01( dados_regra_p.nr_sequencia) loop

		if (r_C01_w.ie_consiste_nr_auxiliar = 'S') then

			-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
			CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

			begin
				open cs_procs_selecao(nr_id_transacao_p);
				loop

					fetch cs_procs_selecao
					bulk collect into dados_tb_selecao_w.nr_seq_selecao, dados_tb_selecao_w.ds_observacao,
							dados_tb_selecao_w.ie_valido
					limit pls_cta_consistir_pck.qt_registro_transacao_w;
					exit when dados_tb_selecao_w.nr_seq_selecao.count = 0;




					-- Para as contas que forem retornadas neste select entende-se que a situação está OK, neste caso elas são consideradas como excecão e não será gerada a ocorrência
					-- para elas. Para as demais contas a ocorrência será gerada
					-- O campo ie_valido_temp será atualizado para N e após o final do cursor, quem tiver este valor no campo será atualizado o campo ie_valido com este valor.
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(dados_tb_selecao_w.nr_seq_selecao,
						dados_tb_selecao_w.ds_seqs_selecao, 'SEQ',
						dados_tb_selecao_w.ds_observacao, dados_tb_selecao_w.ie_valido,
						nm_usuario_p);
				end loop;
				close cs_procs_selecao;
			exception
			when others then
				-- o erro ocorreu enquanto o cursor estava aberto então fecha o mesmo.
				if (cs_procs_selecao%isopen) then
					close cs_procs_selecao;
				end if;
				-- Insere o log na tabela e aborta a operação
				CALL pls_tipos_ocor_pck.trata_erro_sql_dinamico(dados_regra_p,null,nr_id_transacao_p,nm_usuario_p);
			end;

			-- seta os registros que serão válidos ou inválidos após o processamento
			CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
		end if;
	end loop; -- C01
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_39 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
