-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Grava taxa de intercambio considerando contrato de intercambio(OPS - Contratos de intercambio), as



CREATE OR REPLACE PROCEDURE pls_taxa_intercambio_pck.grava_taxa_inter_contrato ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type ) AS $body$
DECLARE

ds_sql_w		varchar(4000);
ds_restr_w  		varchar(500);
ds_restr_mat_w  	varchar(500);
var_cur_w		integer;
tb_sequencia_w		dbms_sql.number_table;
nr_seq_item_w		pls_conta_proc.nr_sequencia%type;
dt_item_w		pls_conta_proc.dt_procedimento%type;
ie_tipo_guia_w 		pls_conta.ie_tipo_guia%type;
ie_tipo_conta_w		pls_conta.ie_tipo_conta%type;
dt_alta_conta_w		pls_conta.dt_alta%type;
dt_atendimento_conta_w	pls_conta.dt_atendimento%type;
dt_recebimento_fatura_w ptu_fatura.dt_recebimento_fatura%type;
nr_seq_populacao_w	pls_lote_protocolo_conta.nr_sequencia%type;
var_retorno_w		integer;
var_exec_w		integer;
qt_dias_envio_item_w	integer;
dt_calculo_w		timestamp;
v_cur_w			pls_util_pck.t_cursor;
ie_tipo_item_w		varchar(1);
qt_iteracoes_w		integer;
qt_iteracoes_mat_w	integer;
tb_seq_mat_w 		dbms_sql.number_table;		
tb_seq_regra_mat_w	dbms_sql.number_table;	
tb_pr_mat_w 		dbms_sql.number_table;	
tb_seq_proc_w 		dbms_sql.number_table;		
tb_seq_regra_proc_w	dbms_sql.number_table;	
tb_pr_proc_w 		dbms_sql.number_table;		

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_inicio_vigencia,
		dt_fim_vigencia,
		nr_seq_intercambio,
		qt_dias_envio_conta,
		pr_taxa
	from	pls_regra_intercambio
	where	ie_cobranca_pagamento = 'P'
	and	(nr_seq_intercambio IS NOT NULL AND nr_seq_intercambio::text <> '')
	order 	by dt_inicio_vigencia desc;
						
BEGIN

for r_C01_w in C01 loop
begin
	nr_seq_populacao_w := null;
	
	if (nr_seq_lote_processo_p IS NOT NULL AND nr_seq_lote_processo_p::text <> '') then
		ds_restr_w 	:= '	exists(select	1'|| pls_util_pck.enter_w ||
				'		from	pls_cta_lote_proc_cta_temp lote '|| pls_util_pck.enter_w ||
				'		where	' || nr_seq_populacao_w || '	= :nr_seq_populacao_pc '|| pls_util_pck.enter_w ||
				'		and     lote.nr_seq_conta  		= proc.nr_seq_conta)'|| pls_util_pck.enter_w;
					
		ds_restr_mat_w	:= '	exists(select	1'|| pls_util_pck.enter_w ||
				'		from	pls_cta_lote_proc_cta_temp lote '|| pls_util_pck.enter_w ||
				'		where	' || nr_seq_populacao_w || '	= :nr_seq_populacao_pc '|| pls_util_pck.enter_w ||
				'		and     lote.nr_seq_conta  		= mat.nr_seq_conta)'|| pls_util_pck.enter_w;
		
		
		nr_seq_populacao_w := nr_seq_lote_processo_p;
		

	elsif (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
		ds_restr_w	:= ' proc.nr_seq_lote_conta = :nr_seq_populacao_pc'|| pls_util_pck.enter_w;
		ds_restr_mat_w	:= ' mat.nr_seq_lote_conta = :nr_seq_populacao_pc'|| pls_util_pck.enter_w;
		nr_seq_populacao_w := nr_seq_lote_p;
		
	elsif (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
		ds_restr_w	:= ' proc.nr_seq_protocolo = :nr_seq_populacao_pc'|| pls_util_pck.enter_w;
		ds_restr_mat_w	:= ' mat.nr_seq_protocolo = :nr_seq_populacao_pc'|| pls_util_pck.enter_w;
		nr_seq_populacao_w := nr_seq_protocolo_p;
	
	elsif ((nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') or (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> ''))	then
		
			ds_restr_w	:= 'proc.nr_sequencia = :nr_seq_proc'|| pls_util_pck.enter_w;	
	
	elsif ((nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '') or (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> ''))	then
		
			ds_restr_mat_w	:= 	' 	mat.nr_sequencia = :nr_seq_mat'|| pls_util_pck.enter_w;	
			
	elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
		ds_restr_w	:= ' proc.nr_seq_conta 	= :nr_seq_populacao_pc'|| pls_util_pck.enter_w;	
		ds_restr_mat_w	:= ' mat.nr_seq_conta	= :nr_seq_populacao_pc'|| pls_util_pck.enter_w;	
		nr_seq_populacao_w := nr_seq_conta_p;
		
        elsif (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
		ds_restr_w	:= ' proc.nr_seq_analise	= :nr_seq_populacao_pc'|| pls_util_pck.enter_w;	
		ds_restr_mat_w	:= ' mat.nr_seq_analise		= :nr_seq_populacao_pc'|| pls_util_pck.enter_w;	
		nr_seq_populacao_w := nr_seq_analise_p;
		
	end if;

	ds_sql_w	:= 	'select	proc.nr_sequencia nr_seq_item,'|| pls_util_pck.enter_w ||
				'	proc.dt_procedimento dt_item,'|| pls_util_pck.enter_w ||
				'	proc.ie_tipo_guia, '|| pls_util_pck.enter_w ||
				'	proc.ie_tipo_conta, '|| pls_util_pck.enter_w ||
				'	proc.dt_alta_conta,'|| pls_util_pck.enter_w ||
				'	proc.dt_atendimento_conta,'|| pls_util_pck.enter_w ||
				'	proc.dt_recebimento_fatura,'|| pls_util_pck.enter_w ||
				'	''P'' ie_tipo_item'|| pls_util_pck.enter_w ||
				'from	pls_conta_proc_v proc, '  || pls_util_pck.enter_w ||
				'	pls_segurado seg'   || pls_util_pck.enter_w ||
				'where	'|| ds_restr_w || pls_util_pck.enter_w ||
				'and 	proc.ie_tipo_conta = ''I'''|| pls_util_pck.enter_w ||
				'and 	proc.dt_procedimento between inicio_dia(:dt_inicio_vigencia) and fim_dia(:dt_fim_vigencia)'|| pls_util_pck.enter_w||
				'and	proc.nr_seq_regra_tx_inter is null'||pls_util_pck.enter_w||
				'and	proc.ie_status 	in (''A'', ''C'', ''L'', ''P'', ''S'', ''U'' ) '||pls_util_pck.enter_w||
				'and	proc.ie_status_conta in (''A'',''L'',''P'',''F'',''U'')'||pls_util_pck.enter_w||
				'and	proc.ie_status_protocolo in (''1'',''2'',''3'',''5'')'||pls_util_pck.enter_w||
				'and	seg.nr_sequencia = proc.nr_seq_segurado'||pls_util_pck.enter_w ||
				'and	seg.nr_seq_intercambio = :nr_seq_intercambio'||pls_util_pck.enter_w||
				'union all'||pls_util_pck.enter_w||
				'select	mat.nr_sequencia nr_seq_item,'|| pls_util_pck.enter_w ||
				'	mat.dt_atendimento dt_item,'|| pls_util_pck.enter_w ||
				'	mat.ie_tipo_guia, '|| pls_util_pck.enter_w ||
				'	mat.ie_tipo_conta, '|| pls_util_pck.enter_w ||
				'	mat.dt_alta_conta,'|| pls_util_pck.enter_w ||
				'	mat.dt_atendimento_conta,'|| pls_util_pck.enter_w ||
				'	mat.dt_recebimento_fatura,'|| pls_util_pck.enter_w ||
				'	''M'' ie_tipo_item'|| pls_util_pck.enter_w ||
				'from	pls_conta_mat_v mat, '  || pls_util_pck.enter_w ||
				'	pls_segurado seg'   || pls_util_pck.enter_w ||
				'where	'|| ds_restr_mat_w || pls_util_pck.enter_w ||
				'and 	mat.ie_tipo_conta = ''I'''|| pls_util_pck.enter_w ||
				'and 	mat.dt_atendimento between inicio_dia(:dt_inicio_vigencia) and fim_dia(:dt_fim_vigencia)'|| pls_util_pck.enter_w|| 
				'and	mat.nr_seq_regra_tx_inter is null'||pls_util_pck.enter_w||
				'and	mat.ie_status in (''A'', ''C'', ''L'', ''P'', ''S'', ''U'' ) '||pls_util_pck.enter_w||
				'and	mat.ie_status_conta in (''A'',''L'',''P'',''F'',''U'')'||pls_util_pck.enter_w||
				'and	mat.ie_status_protocolo in (''1'',''2'',''3'',''5'')'||pls_util_pck.enter_w||
				'and	seg.nr_sequencia = mat.nr_seq_segurado'||pls_util_pck.enter_w ||
				'and	seg.nr_seq_intercambio = :nr_seq_intercambio';
		
	--Se for informado material ou procedimento, entao abre o cursor passando uma bind a mais

	begin	
		if ((nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') or (nr_seq_mat_p IS NOT NULL AND nr_seq_mat_p::text <> '')) then
			open v_cur_w for EXECUTE ds_sql_w using nr_seq_populacao_w, nr_seq_proc_p, r_C01_w.dt_inicio_vigencia, r_C01_w.dt_fim_vigencia, r_C01_w.nr_seq_intercambio,
							nr_seq_populacao_w, nr_seq_mat_p, r_C01_w.dt_inicio_vigencia, r_C01_w.dt_fim_vigencia, r_C01_w.nr_seq_intercambio;
		--Quando nao for informado material ou procedimento, entao abre o cursor sem passar bind de item		

		else
			open v_cur_w for EXECUTE ds_sql_w using nr_seq_populacao_w, r_C01_w.dt_inicio_vigencia, r_C01_w.dt_fim_vigencia, r_C01_w.nr_seq_intercambio,
							nr_seq_populacao_w, r_C01_w.dt_inicio_vigencia, r_C01_w.dt_fim_vigencia, r_C01_w.nr_seq_intercambio;
							
		end if;
		qt_iteracoes_w	:= 0;
		qt_iteracoes_mat_w := 0;
		
		loop	
			
			fetch v_cur_w into 	nr_seq_item_w, dt_item_w, ie_tipo_guia_w, ie_tipo_conta_w,  dt_alta_conta_w,
						dt_atendimento_conta_w, dt_recebimento_fatura_w, ie_tipo_item_w;
			
			-- Quando o cursor nao tiver mais linhas entao sai do loop.

			EXIT WHEN NOT FOUND; /* apply on v_cur_w */
	
				--Se for procedimento, entao passa para function que obtem a data a ser considerada,  a sequencia do procedimento(Penultimo parametro) 

				if (ie_tipo_item_w = 'P') then
					dt_calculo_w := pls_taxa_intercambio_pck.obter_data_item( ie_tipo_guia_w, ie_tipo_conta_w, dt_alta_conta_w,
								dt_atendimento_conta_w, dt_item_w, nr_seq_item_w, null);
				--Se for material, entao passa para function a sequencia do material(ultimo parametro) 

				else
					dt_calculo_w := pls_taxa_intercambio_pck.obter_data_item( ie_tipo_guia_w, ie_tipo_conta_w, dt_alta_conta_w,
								dt_atendimento_conta_w,  dt_item_w, null, nr_seq_item_w);
				end if;
								
				-- Calcular o prazo de envio do item pela data de Recebimento. O campo nao existe na tela para o ususario informar, ou seja, e gravado fixo sempre

				qt_dias_envio_item_w := (dt_recebimento_fatura_w - dt_calculo_w);
							
				-- Se o procedimento ou material for enviado dentro do prazo entao prossegue

				if	(((qt_dias_envio_item_w <= r_C01_w.qt_dias_envio_conta) or (coalesce(r_C01_w.qt_dias_envio_conta::text, '') = '')) ) then
					
					--Quando for procedimento, entao aliementa as tabelas referentes a procedimentos

					if (ie_tipo_item_w = 'P') then
					
						tb_seq_proc_w(qt_iteracoes_w) 		:= nr_seq_item_w;
						tb_seq_regra_proc_w(qt_iteracoes_w) 	:= r_C01_w.nr_sequencia;
						tb_pr_proc_w(qt_iteracoes_w) 		:= r_C01_w.pr_taxa;
						
						if (qt_iteracoes_w = pls_util_cta_pck.qt_registro_transacao_w) then
						--Atualiza a informacao da regra de intercambrio e taxa nos procedimentos

						-- faz o update atraves do forall

							CALL pls_taxa_intercambio_pck.atualiza_intercambio_item(tb_seq_proc_w, tb_seq_regra_proc_w, tb_pr_proc_w, 'P');		
							qt_iteracoes_w := 0;
							tb_seq_proc_w.delete;
							tb_seq_regra_proc_w.delete;
							tb_pr_proc_w.delete;
			
						else
							qt_iteracoes_w := qt_iteracoes_w + 1;
						end if;
						
					--Quando nao for  procedimento, entao aliementa as tabelas referentes a materiais

					else
						tb_seq_mat_w(qt_iteracoes_w) 		:= nr_seq_item_w;
						tb_seq_regra_mat_w(qt_iteracoes_w) 	:= r_C01_w.nr_sequencia;
						tb_pr_mat_w(qt_iteracoes_w) 		:= r_C01_w.pr_taxa;
						
						--Testa se quantidade de registros nas listas chegou ao limete(Entao deve fazer update dos resgistros)

						if (qt_iteracoes_mat_w = pls_util_cta_pck.qt_registro_transacao_w) then
						--Atualiza a informacao da regra de intercambio e taxa nos mateiriais

						-- faz o update atraves do forall

							CALL pls_taxa_intercambio_pck.atualiza_intercambio_item(tb_seq_mat_w, tb_seq_regra_mat_w, tb_pr_mat_w, 'M');		
							qt_iteracoes_mat_w := 0;
							tb_seq_mat_w.delete;
							tb_seq_regra_mat_w.delete;
							tb_pr_mat_w.delete;
						else
							qt_iteracoes_mat_w := qt_iteracoes_mat_w + 1;
						end if;
					end if;
				end if;
			
		end loop;
			--Executa novamente as duas, pois pode ter sobrado algum item nas listas.

			CALL pls_taxa_intercambio_pck.atualiza_intercambio_item(tb_seq_proc_w, tb_seq_regra_proc_w, tb_pr_proc_w, 'P');
			CALL pls_taxa_intercambio_pck.atualiza_intercambio_item(tb_seq_mat_w, tb_seq_regra_mat_w, tb_pr_mat_w, 'M');	
			qt_iteracoes_w 		:= 0;
			qt_iteracoes_mat_w 	:= 0;
			tb_seq_proc_w.delete;
			tb_seq_regra_proc_w.delete;
			tb_pr_proc_w.delete;
			tb_seq_mat_w.delete;
			tb_seq_regra_mat_w.delete;
			tb_pr_mat_w.delete;
			close v_cur_w;
		exception			
		when others then
			close v_cur_w;		
	end;
end;
end loop;
						
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_taxa_intercambio_pck.grava_taxa_inter_contrato ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type ) FROM PUBLIC;