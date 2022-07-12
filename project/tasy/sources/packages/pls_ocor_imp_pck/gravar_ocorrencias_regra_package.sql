-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.gravar_ocorrencias_regra ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, cd_validacao_p pls_oc_cta_tipo_validacao.cd_validacao%type, ie_aplicacao_ocorrencia_p pls_oc_cta_combinada.ie_aplicacao_ocorrencia%type, ie_utiliza_filtro_p pls_oc_cta_combinada.ie_utiliza_filtro%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

					
ie_tipo_aplicacao_ocor_w	pls_oc_cta_tipo_validacao.ie_aplicacao_ocorrencia%type;
qt_filtro_regra_w		integer;
	

BEGIN
-- busca a aplicaaao da regra

ie_tipo_aplicacao_ocor_w := pls_ocor_imp_pck.obter_aplicacao_regra(nr_seq_combinada_p, cd_validacao_p, ie_aplicacao_ocorrencia_p);

-- Conta

if (ie_tipo_aplicacao_ocor_w = 'C') then
	-- gera ocorrancia para todas as contas que estao como validos na tabela de seleaao

	CALL CALL pls_ocor_imp_pck.grava_ocor_conta(	nr_id_transacao_p, nr_seq_ocorrencia_p,
				nm_usuario_p);
	
-- Se nao for para gerar por conta entende-se que deve ser gerado para qualquer registro da tabela de seleaao.

else
	select	count(1)
	into STRICT	qt_filtro_regra_w
	from	pls_oc_cta_filtro a
	where	a.nr_seq_oc_cta_comb = nr_seq_combinada_p
	and	a.ie_situacao = 'A';
	
	-- Vai que nao deve utilizar filtro e teve filtro cadastrado no passado

	if (qt_filtro_regra_w > 0 and (ie_utiliza_filtro_p = 'S' or cd_validacao_p = 1)) then
		-- grava as ocorrancias respeitando a incidancia de cada filtro

		CALL CALL pls_ocor_imp_pck.grava_ocor_filtro(	nr_id_transacao_p, nr_seq_ocorrencia_p,
					nr_seq_combinada_p, ie_tipo_aplicacao_ocor_w,
					nm_usuario_p);
	else
		-- gera ocorrancia para todos os registros que estao como validos na tabela de seleaao

		CALL CALL pls_ocor_imp_pck.grava_ocor_selecao(	nr_id_transacao_p, nr_seq_ocorrencia_p,
					nm_usuario_p);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.gravar_ocorrencias_regra ( nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, cd_validacao_p pls_oc_cta_tipo_validacao.cd_validacao%type, ie_aplicacao_ocorrencia_p pls_oc_cta_combinada.ie_aplicacao_ocorrencia%type, ie_utiliza_filtro_p pls_oc_cta_combinada.ie_utiliza_filtro%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;