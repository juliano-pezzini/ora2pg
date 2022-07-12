-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.atualizar_pagamento ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_liberacao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

					
/* ie_tipo_liberacao_p
	F - Fechamento do protocolo
	C - Fechamento da conta
	L - Libera__o do item
*/
					
type t_protocolo is table of bigint index by integer;
vetor_protocolo_w		t_protocolo;
protocolo_anterior_w		pls_protocolo_conta.nr_sequencia%type;
nr_indice_vetor_w		integer;
qt_reg_vetor_w			integer;
ie_status_prot_w		pls_protocolo_conta.ie_status%type;
ie_opcao_w			varchar(10);
qt_reg_w			integer;
nr_seq_evento_w			pls_conta_proc.nr_seq_evento%type;
nr_seq_evento_prod_w		pls_conta_proc.nr_seq_evento_prod%type;
ie_funcao_pagamento_w		pls_parametro_pagamento.ie_funcao_pagamento%type;

C01 CURSOR(	nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced,
		ie_tipo_guia,
		ie_origem_conta,
		nr_seq_tipo_atendimento,
		ie_tipo_despesa,
		nr_seq_segurado
	from	pls_conta_proc_v
	where	nr_seq_conta = nr_seq_conta_pc;
	
C02 CURSOR(	nr_seq_conta_pc	pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		nr_seq_material,
		ie_tipo_guia,
		ie_origem_conta,
		nr_seq_tipo_atendimento,
		ie_tipo_despesa,
		nr_seq_segurado,
		coalesce(nr_seq_prest_fornec, nr_seq_prestador_exec) nr_seq_prestador
	from	pls_conta_mat_v
	where	nr_seq_conta = nr_seq_conta_pc;

-- criar um cursor que retorne todas as an_lises, caso seja passada a conta ent_o retorne a conta e s_ passa a conta

c03 CURSOR(	nr_seq_lote_pc		pls_lote_protocolo_conta.nr_sequencia%type,
		nr_seq_protocolo_pc	pls_protocolo_conta.nr_sequencia%type,
		nr_seq_lote_processo_pc	pls_cta_lote_processo.nr_sequencia%type,
		nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR
	SELECT	distinct nr_seq_analise,
		nr_seq_conta
	from (
		SELECT	b.nr_seq_analise,
			CASE WHEN coalesce(b.nr_seq_analise::text, '') = '' THEN  b.nr_sequencia  ELSE null END  nr_seq_conta
		from	pls_protocolo_conta a,
			pls_conta b
		where	a.nr_seq_lote_conta = nr_seq_lote_pc
		and	b.nr_seq_protocolo = a.nr_sequencia
		
union all

		select	a.nr_seq_analise,
			CASE WHEN coalesce(a.nr_seq_analise::text, '') = '' THEN  a.nr_sequencia  ELSE null END  nr_seq_conta
		from	pls_conta a
		where	a.nr_seq_protocolo = nr_seq_protocolo_pc
		
union all

		select	b.nr_seq_analise,
			CASE WHEN coalesce(b.nr_seq_analise::text, '') = '' THEN  b.nr_sequencia  ELSE null END  nr_seq_conta
		from	pls_cta_lote_proc_conta a,
			pls_conta b
		where	a.nr_seq_lote_processo = nr_seq_lote_processo_pc
		and	b.nr_sequencia = a.nr_seq_conta
		
union all

		select	null nr_seq_analise,
			nr_sequencia nr_seq_conta
		from	pls_conta
		where	nr_sequencia = nr_seq_conta_pc
	) alias4;

BEGIN

-- aqui chama os procedimentos que se referem a atualiza__o de valores nas contas

qt_reg_vetor_w := 0;
for r_c_contas_w in current_setting('pls_cta_consistir_pck.c_contas')::CURSOR((nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p) loop

	CALL pls_cta_consistir_pck.gerar_resumo_conta(null, null, null, r_c_contas_w.nr_seq_conta, nm_usuario_p, cd_estabelecimento_p, null);

	CALL pls_fechar_conta(r_c_contas_w.nr_seq_conta, 'N', 'S', 'N', cd_estabelecimento_p, nm_usuario_p, 'S', null);
	commit;
	
	if (r_c_contas_w.ie_tipo_conta	= 'I') 	and (r_c_contas_w.ie_tipo_protocolo != 'R') 	then
		CALL pls_atualizar_status_int_a500(r_c_contas_w.nr_seq_protocolo, r_c_contas_w.nr_seq_fatura, nm_usuario_p);
		commit;
	end if;
	
	-- se for libera__o, atualiza os itens

	if (ie_tipo_liberacao_p = 'L') then
	
		-- atualizar pls_conta_medica_resumo (pagamento dos prestadores) e faturamento (cobrar as despesas que foram geradas pelo atendimento)

		-- tratamento para procedimentos

		for r_C01_w in C01(r_c_contas_w.nr_seq_conta) loop
			--Atualzia__o dos eventos de produ__o m_dica, necess_rio pensarmos em uma forma de acelerar este processo

			pls_obter_evento_item(	r_C01_w.cd_procedimento, r_C01_w.ie_origem_proced, null,
						cd_estabelecimento_p, r_C01_w.ie_tipo_guia, r_C01_w.ie_origem_conta,
						r_C01_w.nr_seq_tipo_atendimento, r_C01_w.ie_tipo_despesa, r_C01_w.nr_seq_segurado,
						r_c_contas_w.nr_seq_conta, 'N', null, nr_seq_evento_w, nr_seq_evento_prod_w, 'C'
						, r_c_contas_w.ie_regime_atendimento, r_c_contas_w.ie_saude_ocupacional);
			update	pls_conta_proc
			set	nr_seq_evento		= nr_seq_evento_w,
				nr_seq_evento_prod	= nr_seq_evento_prod_w
			where	nr_sequencia		= r_C01_w.nr_sequencia;
			-- pls_conta_medica_resumo

			CALL pls_atualiza_conta_resumo_item(	r_C01_w.nr_sequencia, 'P', nm_usuario_p, 'S');
			commit;
		end loop;
		
		-- tratamento para materiais

		for r_C02_w in C02(r_c_contas_w.nr_seq_conta) loop
		--Atualzia__o dos eventos de produ__o m_dica, necess_rio pensarmos em uma forma de acelerar este processo

			pls_obter_evento_item(	null, null, r_C02_w.nr_seq_material,
						cd_estabelecimento_p, r_C02_w.ie_tipo_guia, r_C02_w.ie_origem_conta,
						r_C02_w.nr_seq_tipo_atendimento, r_C02_w.ie_tipo_despesa, r_C02_w.nr_seq_segurado,
						r_c_contas_w.nr_seq_conta, 'N', r_c02_w.nr_seq_prestador, 
						nr_seq_evento_w, nr_seq_evento_prod_w, 'C', r_c_contas_w.ie_regime_atendimento, 
						r_c_contas_w.ie_saude_ocupacional);
			
			update	pls_conta_mat
			set	nr_seq_evento		= nr_seq_evento_w,
				nr_seq_evento_prod	= nr_seq_evento_prod_w
			where	nr_sequencia		= r_C02_w.nr_sequencia;
			-- pls_conta_medica_resumo

			CALL pls_atualiza_conta_resumo_item(	r_C02_w.nr_sequencia, 'M', nm_usuario_p, 'S');
			commit;
		end loop;
				
	end if;
	--necess_rio passar aqui novamente para evitar que seja gerado "N" vezes no processo acima

	CALL pls_cta_consistir_pck.gerar_resumo_conta(null, null, null, r_c_contas_w.nr_seq_conta, nm_usuario_p, cd_estabelecimento_p,null);
	
	select	count(1)
	into STRICT	qt_reg_w
	from	pls_conta_coparticipacao
	where	nr_seq_conta	= r_c_contas_w.nr_seq_conta  LIMIT 1;
	
	ie_opcao_w	:= '';
	
	if (qt_reg_w	> 0) then
		ie_opcao_w	:= 'C';
	end if;
	
	--Atualiza os valores da pls_conta_proc_contab

	if (ie_opcao_w IS NOT NULL AND ie_opcao_w::text <> '') then
		CALL pls_gerar_contab_val_adic(r_c_contas_w.nr_seq_conta,null,null,null,null,null,null,ie_opcao_w,'N',nm_usuario_p);
	end if;
	
	commit;
	
	select	max(ie_status)
	into STRICT	ie_status_prot_w
	from	pls_protocolo_conta
	where	nr_sequencia	= r_c_contas_w.nr_seq_protocolo;
	-- se mudou o protocolo

	if (ie_status_prot_w	!= '6') and
		((coalesce(protocolo_anterior_w::text, '') = '') or (protocolo_anterior_w != r_c_contas_w.nr_seq_protocolo)) then
		vetor_protocolo_w(qt_reg_vetor_w) := r_c_contas_w.nr_seq_protocolo;
		qt_reg_vetor_w := qt_reg_vetor_w + 1;
	end if;
	
	protocolo_anterior_w := r_c_contas_w.nr_seq_protocolo;
	
	CALL pls_gerar_contab_val_adic(r_c_contas_w.nr_seq_conta, null, null, null, null, null, null, 'P', 'N', nm_usuario_p);
	
	commit;
end loop;

-- percorre o vetor e chama as procedures para fazer os trabalhos com o protocolo

if (vetor_protocolo_w.count > 0) then
	for nr_indice_vetor_w in vetor_protocolo_w.first .. vetor_protocolo_w.last loop
		CALL pls_gerar_valores_protocolo(	vetor_protocolo_w(nr_indice_vetor_w), nm_usuario_p);
		commit;
		CALL pls_altera_status_protocolo(	vetor_protocolo_w(nr_indice_vetor_w), ie_tipo_liberacao_p, 'N',
						cd_estabelecimento_p, nm_usuario_p);
		commit;
	end loop;
end if;

-- verifica se _ a nova fun__o do pagamento de produ__o m_dica

select	coalesce(max(ie_funcao_pagamento), '1')
into STRICT	ie_funcao_pagamento_w
from	pls_parametro_pagamento
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_funcao_pagamento_w = '2') or (obter_se_base_wheb = 'S') then

	
	for r_c03_w in c03(	nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p) loop

		CALL pls_pp_cta_evento_combinada(	r_c03_w.nr_seq_analise, r_c03_w.nr_seq_conta, ie_funcao_pagamento_w,
						cd_estabelecimento_p, nm_usuario_p);
	end loop;
end if;

CALL pls_cta_consistir_pck.executa_update_padrao(	nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p,
			'fim_processo', nm_usuario_p, cd_estabelecimento_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.atualizar_pagamento ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, ie_tipo_liberacao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;