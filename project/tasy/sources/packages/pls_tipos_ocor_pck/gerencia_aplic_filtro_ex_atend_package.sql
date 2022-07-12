-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_tipos_ocor_pck.gerencia_aplic_filtro_ex_atend ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_regra_p pls_tipos_ocor_pck.dados_regra, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Verificar o atendimento de todos os registros que ficaram validos apos processar o
	filtro de excecao. Em resumo, o filtro de excecao e processado novamente para
	todo o atendimento e se "casar" algum registro, a excecao nao e mais gerada para
	o item original que esta na tabela de selecao. A tabela de selecao original e a
	pls_selecao_ocor_cta e a tabela utilizada para este novo processamento de
	excecao e a pls_selecao_ex_ocor_cta. Foi separado por motivos de performance e
	facilidade de manutencao.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Nao deve ser mudada a sequencia de aplicacao dos filtros, pois a mesma precisa seguir a
granularidade dos dados.

Alteracoes:
 ------------------------------------------------------------------------------------------------------------------

 usuario OS XXXXXX 01/01/2000 -
 Alteracao:	Descricao da alteracao.
Motivo:	Descricao do motivo.
 ------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

nr_id_transacao_ex_w	pls_selecao_ex_ocor_cta.nr_id_transacao%type;

BEGIN

-- se for filtro de excecao e a opcao para validar o atendimento estiver marcada

if	((dados_filtro_p.ie_excecao = 'S') and (dados_filtro_p.ie_valida_todo_atend = 'S') or (dados_filtro_p.ie_valida_conta_princ = 'S')) then

	 -- modifica o comportamento de algumas rotinas para trabalhar verificando todo o atendimento

	 PERFORM set_config('pls_tipos_ocor_pck.ie_controle_todo_atendimento_w', 'S', false);

	-- alimenta a tabela de selecao

	if (dados_filtro_p.ie_valida_conta_princ = 'S') then
		-- alimenta a tabela de selecao de excecao quando for aplicado o filtro pela conta principal

		nr_id_transacao_ex_w := pls_tipos_ocor_pck.alimenta_selecao_excecao_cp(	nr_id_transacao_p, dados_filtro_p, nm_usuario_p, cd_estabelecimento_p, nr_id_transacao_ex_w);
	else
		nr_id_transacao_ex_w := pls_tipos_ocor_pck.alimenta_selecao_excecao(	nr_id_transacao_p, dados_filtro_p, nm_usuario_p, cd_estabelecimento_p, nr_id_transacao_ex_w);
	end if;
	-- filtro de Protocolo

	if (dados_filtro_p.ie_filtro_protocolo = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_protocolo_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- filtro de conta

	if (dados_filtro_p.ie_filtro_conta = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_conta_ex(		dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- Prestador

	if (dados_filtro_p.ie_filtro_prest = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_prestador_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- Profissional

	if (dados_filtro_p.ie_filtro_prof = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_profissional_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- contrato

	if (dados_filtro_p.ie_filtro_contrato = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_contrato_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- produto

	if (dados_filtro_p.ie_filtro_produto = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_produto_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- Intercambio

	if (dados_filtro_p.ie_filtro_interc = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_intercambio_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- beneficiario

	if (dados_filtro_p.ie_filtro_benef = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_beneficiario_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- procedimento

	if (dados_filtro_p.ie_filtro_proc = 'S')  then
		CALL pls_tipos_ocor_pck.aplica_filtro_procedimento_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- material

	if (dados_filtro_p.ie_filtro_mat = 'S')  then
		CALL pls_tipos_ocor_pck.aplica_filtro_material_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- operadora

	if (dados_filtro_p.ie_filtro_oper_benef = 'S') then
		CALL pls_tipos_ocor_pck.aplica_filtro_operadora_ex(	dados_regra_p, dados_filtro_p, nm_usuario_p, nr_id_transacao_ex_w);
	end if;

	-- invalida os registros que estao como validos se acaso algum item do seu atendimento casar na regra de excecao

	CALL pls_tipos_ocor_pck.atualiza_ie_valido_ex(nr_id_transacao_ex_w, nr_id_transacao_p, dados_filtro_p);

	-- limpa os registros da tabela

	CALL pls_tipos_ocor_pck.limpa_selecao_excecao(nr_id_transacao_ex_w);

	PERFORM set_config('pls_tipos_ocor_pck.ie_controle_todo_atendimento_w', 'N', false);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tipos_ocor_pck.gerencia_aplic_filtro_ex_atend ( nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, dados_filtro_p pls_tipos_ocor_pck.dados_filtro, dados_regra_p pls_tipos_ocor_pck.dados_regra, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
