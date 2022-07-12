-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE pls_gerenciar_reembolso_pck.pls_gerenciar_reembolso ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE
 		

dados_consistencia_w		pls_gerenciar_reembolso_pck.dados_consistencia;
dados_regra_w			pls_gerenciar_reembolso_pck.dados_regra;
qt_registro_w			integer;
dt_atendimento_w		pls_conta.dt_atendimento%type;
nr_id_transacao_w		integer;

-- Cursor com as regras

C01 CURSOR( dt_atendimento_pc	pls_conta.dt_atendimento%type) FOR
	SELECT	regra.nr_sequencia,
		regra.dt_inicio_vigencia,
		regra.dt_fim_vigencia, 		
		regra.nr_seq_grupo_regra
	from	pls_regra_reembolso	regra
	where	dt_atendimento_pc between
			CASE WHEN coalesce(dt_inicio_vigencia::text, '') = '' THEN  dt_atendimento_pc  ELSE dt_inicio_vigencia END  and 
			CASE WHEN coalesce(dt_fim_vigencia::text, '') = '' THEN  dt_atendimento_pc  ELSE dt_fim_vigencia END 
	order by	coalesce(nr_ordem_execucao, 0) desc; --desc por que quando obtem uma regra, seta a mesma ao item, entao comeca pela maior ordem

BEGIN

if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then

	select	coalesce(dt_atendimento_referencia,clock_timestamp())
	into STRICT	dt_atendimento_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_p;

	-- Limpa as regras do procedimento e material

	CALL pls_gerenciar_reembolso_pck.pls_reemb_limpa_regra(nr_seq_conta_p);
	
	dados_consistencia_w.nr_seq_conta := nr_seq_conta_p;
		
	for r_C01_w in C01(dt_atendimento_w) loop
	
		dados_regra_w.nr_sequencia := r_C01_w.nr_sequencia;
		dados_regra_w.dt_inicio_vigencia := r_C01_w.dt_inicio_vigencia;
		dados_regra_w.dt_fim_vigencia := r_C01_w.dt_fim_vigencia;
		dados_regra_w.nr_seq_grupo_regra := r_C01_w.nr_seq_grupo_regra;
		
		select	nextval('pls_id_transacao_reemb_seq') nr_id_transacao
		into STRICT	nr_id_transacao_w
		;
		
		-- Limpa a selecao

		CALL CALL pls_gerenciar_reembolso_pck.gerencia_selecao(nr_id_transacao_w,null,null,'S',nm_usuario_p,'3',null);
		
		qt_registro_w := pls_gerenciar_reembolso_pck.gerencia_aplicacao_filtro(	dados_consistencia_w, dados_regra_w, nr_id_transacao_w, nm_usuario_p, cd_estabelecimento_p, qt_registro_w);
	
		if (qt_registro_w > 0) then
					
			CALL pls_gerenciar_reembolso_pck.aplica_acao_regra(	dados_regra_w, dt_atendimento_w, nm_usuario_p, cd_estabelecimento_p);		
			
		end if;
		
		commit;		
	end loop; -- Regras de reembolso
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerenciar_reembolso_pck.pls_gerenciar_reembolso ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
