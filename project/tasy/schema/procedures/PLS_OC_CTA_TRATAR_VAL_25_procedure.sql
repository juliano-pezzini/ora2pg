-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_25 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Validar se o profissional solicitante da contas esta informado.

Validacao realizada em base na glosa 1411
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
------------------------------------------------------------------------------------------------------------------

dlehmkuhl OS 688483 - 14/04/2014 -

Alteracao:	Modificada a forma de trabalho em relacao a atualizacao dos campos de controle
	que basicamente decidem se a ocorrencia sera ou nao gerada. Foi feita tambem a 
	substituicao da rotina obterX_seX_geraX.

Motivo:	Necessario realizar essas alteracoes para corrigir bugs principalmente no que se
	refere a questao de aplicacao de filtros (passo anterior ao da validacao). Tambem
	tivemos um foco especial em performance, visto que a mesma precisou ser melhorada
	para nao inviabilizar a nova solicitacao que diz que a excecao deve verificar todo
	o atendimento.
------------------------------------------------------------------------------------------------------------------

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
i			integer;
nr_seq_selecao_w	dbms_sql.number_table;
ie_valido_w		dbms_sql.varchar2_table;
ds_observacao_w		dbms_sql.varchar2_table;
dados_filtro_w		pls_tipos_ocor_pck.dados_filtro;
ie_gerar_ocorrencia_w	varchar(1);
qt_medico		integer;

qt_participante_w	integer; -- pode ser que estoure a variavel verificar essa pls_integer
uf_crm_part_imp_w	pls_proc_participante.uf_crm_imp%type;
sg_conselho_part_imp_w	pls_proc_participante.sg_conselho_imp%type;
nm_medico_part_imp_w	pls_proc_participante.nm_medico_executor_imp%type;
nr_crm_part_imp_w	pls_proc_participante.nr_crm_imp%type;
nr_seq_proc_particip_w	pls_proc_participante.nr_sequencia%type;


C01 CURSOR(	nr_seq_oc_cta_comb_p	dados_regra_p.nr_sequencia%type) FOR
	SELECT	a.ie_valida_prof_solic_info,
		a.ie_valida_prof_exec_info,
		a.ie_valida_prof_part_info
	from	pls_oc_cta_val_prof_solic a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

	
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_id_transacao%type) FOR
	SELECT	'C' ie_tipo_item,
		a.cd_medico_solicitante,
		a.cd_medico_solicitante_imp,
		a.nr_sequencia,
		x.nr_sequencia nr_seq_selecao,
		a.nr_crm_solic_imp,
		a.uf_crm_solic_imp,
		a.sg_conselho_solic_imp,
		a.nm_medico_solic_imp,
		a.cd_medico_executor,
		a.nr_crm_exec_imp,
		a.uf_crm_exec_imp,
		a.nm_medico_executor_imp,
		a.sg_conselho_exec_imp
	from	pls_oc_cta_selecao_ocor_v	x,
		pls_conta_ocor_v		a
	where	x.ie_valido		= 'S'
	and	x.nr_id_transacao	= nr_id_transacao_pc
	and	a.nr_sequencia 		= x.nr_seq_conta;
BEGIN

for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
	
	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);
	
	if (r_C01_w.ie_valida_prof_solic_info = 'S') or (r_C01_w.ie_valida_prof_exec_info = 'S') or (r_C01_w.ie_valida_prof_part_info = 'S') then
		
		-- Incializar as listas para cada regra.
		ie_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		ds_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
		nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
		
		i := 0;
		for r_C02_w in C02(nr_id_transacao_p) loop
			
			ie_gerar_ocorrencia_w	:= 'N';
			ds_observacao_w(i) := null;
			nr_seq_selecao_w(i) := r_C02_w.nr_seq_selecao;
			
			if (coalesce(r_c02_w.cd_medico_solicitante::text, '') = '') and (r_C01_w.ie_valida_prof_solic_info = 'S') and (ie_gerar_ocorrencia_w = 'N')then
				begin
				
				ie_gerar_ocorrencia_w	:= 'S';
				
				if (dados_regra_p.ie_evento = 'IMP') then
					begin
					ds_observacao_w(i):= 	'CRM: ' || r_c02_w.nr_crm_solic_imp ||
								'UF CRM: ' || r_c02_w.uf_crm_solic_imp ||
								'NOME MEDICO: ' || r_c02_w.nm_medico_solic_imp ||
								'SIGLA CONSELHO: ' || r_c02_w.sg_conselho_solic_imp;
					end;
				end if;
				
				end;
			end if;
			
			if (coalesce(r_c02_w.cd_medico_executor::text, '') = '') and (r_C01_w.ie_valida_prof_exec_info = 'S') and (ie_gerar_ocorrencia_w = 'N')then
				begin
				
				ie_gerar_ocorrencia_w	:= 'S';
				
				if (dados_regra_p.ie_evento = 'IMP') then
					begin
					ds_observacao_w(i):= 	'CRM: ' || r_c02_w.nr_crm_exec_imp ||
								'UF CRM: ' || r_c02_w.uf_crm_exec_imp ||
								'NOME MEDICO: ' || r_c02_w.nm_medico_executor_imp ||
								'SIGLA CONSELHO: ' || r_c02_w.sg_conselho_exec_imp;
					end;
				end if;
				
				end;
			end if;
			
			if (r_C01_w.ie_valida_prof_part_info = 'S') and (ie_gerar_ocorrencia_w = 'N')then
				
				begin
				
				select	max(b.nr_sequencia)
				into STRICT	nr_seq_proc_particip_w
				from 	pls_conta_proc a,
					pls_proc_participante b
				where	a.nr_seq_conta = r_c02_w.nr_sequencia
				and 	a.nr_sequencia = b.nr_seq_conta_proc
				and	coalesce(b.cd_medico::text, '') = ''  LIMIT 1;
				
				if (coalesce(nr_seq_proc_particip_w, 0) <> 0) then
					begin
					
					select	1,
						uf_crm_imp,
					        sg_conselho_imp,
					        nm_medico_executor_imp,
					        nr_crm_imp
					into STRICT	qt_participante_w,
						uf_crm_part_imp_w,
						sg_conselho_part_imp_w,
						nm_medico_part_imp_w,
						nr_crm_part_imp_w
					from	pls_proc_participante a
					where 	a.nr_sequencia = nr_seq_proc_particip_w  LIMIT 1;
					
					end;
				else
					qt_participante_w := 0;
				end if;
				
				exception
				when others then
					qt_participante_w:= 0;
				end;
				
				if (qt_participante_w = 1) then
					begin
					
					ie_gerar_ocorrencia_w	:= 'S';
					
					if (dados_regra_p.ie_evento = 'IMP') then
						begin
						ds_observacao_w(i):= 	'CRM: ' || nr_crm_part_imp_w ||
									'UF CRM: ' || uf_crm_part_imp_w ||
									'NOME MEDICO: ' || nm_medico_part_imp_w ||
									'SIGLA CONSELHO: ' || sg_conselho_part_imp_w;
						end;
					end if;
					
					end;
				end if;
			end if;
		
			-- Verificar se o registro atual e valido ou nao conforme as parametrizacoes de regras e regras de excecao.
			ie_valido_w(i) := ie_gerar_ocorrencia_w;
			
			-- Quando a quantidade de itens da lista tiver chegado ao maximo definido na PLS_CTA_CONSISTIR_PCK, entao os registros sao levados para 

			-- o BD e gravados todos de uma vez, pela procedure GERENCIAL_SELECAO_VALIDACAO, que atualiza os registros conforme passado por 

			-- parametro, o indice e as listas sao reiniciados para carregar os novos registros e para que os registros atuais nao sejam atualizados novamente em 

			-- na proxima carga.
			if (i = pls_cta_consistir_pck.qt_registro_transacao_w) then
				
				-- Sera passado uma lista com todas a sequencias da selecao para a conta e para seus itens, estas sequencias serao atualizadas com os mesmos dados da conta, 

				-- conforme passado por parametro,
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
										'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
				
				-- Zerar o indice
				i := 0;
				
				-- Zerar as listas.
				ie_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				ds_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				nr_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
			-- Enquanto os registros nao tiverem atingido a carga para gravar na selecao incrementa o indice para armazenar os proximos registros.
			else
				i := i + 1;
			end if;
		end loop;
		
		-- Quando tiver sobrado algo na lista ira gravar o que restou apos a execucao do loop.
		if (nr_seq_selecao_w.count > 0) then
		
			-- Sera passado uma lista com todas a sequencias da selecao para a conta e para seus itens, estas sequencias serao atualizadas com os mesmos dados da conta, 

			-- conforme passado por parametro,
			CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	nr_seq_selecao_w, pls_tipos_ocor_pck.clob_table_vazia,
									'SEQ', ds_observacao_w, ie_valido_w, nm_usuario_p);
		end if;
		
		-- seta os registros que serao validos ou invalidos apos o processamento 
		CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);
	end if;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_25 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

