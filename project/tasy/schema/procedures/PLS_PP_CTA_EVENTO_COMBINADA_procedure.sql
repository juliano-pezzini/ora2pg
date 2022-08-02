-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_pp_cta_evento_combinada ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_funcao_pagamento_p pls_parametro_pagamento.ie_funcao_pagamento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_registro_w		integer;


BEGIN
-- puxar se tem regra de evento produção médica
select	count(1)
into STRICT	qt_registro_w
from	pls_pp_cta_combinada LIMIT 1;

-- verificar se existe regra de evento cadastrado na base
if (qt_registro_w > 0) then
	-- verifica se tem algo para atualizar nas tabelas
	CALL pls_gerencia_upd_obj_pck.atualizar_objetos('Tasy', 'PLS_FILTRO_REGRA_EVENT_CTA_PCK.GERENCIA_REGRA_FILTRO', 'PLS_GRUPO_SERVICO_TM');
	CALL pls_gerencia_upd_obj_pck.atualizar_objetos('Tasy', 'PLS_FILTRO_REGRA_EVENT_CTA_PCK.GERENCIA_REGRA_FILTRO', 'PLS_ESTRUTURA_MATERIAL_TM');

	-- Faz a chamada para os filtros dos eventos combinados, responsável por vincular um item da pls_conta_medica_resumo a um evento
	CALL pls_filtro_regra_event_cta_pck.gerencia_regra_filtro(	nr_seq_analise_p, nr_seq_conta_p, cd_estabelecimento_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_cta_evento_combinada ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_funcao_pagamento_p pls_parametro_pagamento.ie_funcao_pagamento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

