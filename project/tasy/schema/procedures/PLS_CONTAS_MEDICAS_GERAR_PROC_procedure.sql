-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_contas_medicas_gerar_proc ( nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, ie_gerar_itens_p text default 'T', nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE

/*
Alteracoes:

--------------------------------------------------------------------------------------

jjung OS 610381 - 24/06/2013

Alteracao:	Removido campo NR_SEQ_PROT_CONTA  do insert na PLS_CONTA. 

Motivo: 	Segundo nosso entendimento nao deve ser vinculado contas de protocolos diferentes em um mesmo titulo.
--------------------------------------------------------------------------------------


ie_gerar_itens_p
 - 'T' Gerar todos os item
 - 'G' Gerar apenas itens glosados
 - 'V' Gerar apenas itens glosados e valores de glosa
 
 ------------------------------------------------------------------------------------

*/
nr_sequencia_w			bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_ww			bigint;
nr_seq_procedimentos_w		bigint;
nr_seq_procedimentos_novo_w	bigint;
nr_seq_materiais_w		bigint;
ie_dt_base_w			varchar(1);
dt_base_w			timestamp;
dt_competencia_w		pls_protocolo_conta.dt_mes_competencia%type;
dt_recebimento_w		pls_protocolo_conta.dt_recebimento%type;
nr_seq_partic_w			pls_proc_participante.nr_sequencia%type;
vl_item_imp_w			pls_conta_proc.vl_procedimento_imp%type;
vl_unitario_imp_w		pls_conta_proc.vl_unitario_imp%type;
vl_glosa_w			pls_conta_proc.vl_glosa%type;
qt_item_imp_w			pls_conta_proc.qt_procedimento_imp%type;
qt_item_w			pls_conta_proc.qt_procedimento%type;

ds_campos_insert_cta_w		varchar(32000);
ds_values_insert_cta_w		varchar(32000);
ds_sql_insert_cta_w		varchar(32000);
ds_virgura_w			varchar(1);
ie_status_w			pls_conta.ie_status%type := 'U';

nr_seq_mat_novo_w		pls_conta_mat.nr_sequencia%type;
qt_registro_w			integer;
nr_seq_item_tiss_w		pls_conta_proc_regra.nr_seq_item_tiss%type;
nr_seq_item_tiss_vinculo_w	pls_conta_proc_regra.nr_seq_item_tiss_vinculo%type;


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	(((vl_glosa	> 0) and (ie_gerar_itens_p in ('V','G'))) or (ie_gerar_itens_p = 'T'))
	and	nr_seq_protocolo	= nr_seq_protocolo_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		qt_procedimento_imp,
		qt_procedimento,
		vl_procedimento_imp,
		vl_glosa,
		vl_unitario_imp		
	from	pls_conta_proc
	where	(((vl_glosa	> 0) and (ie_gerar_itens_p in ('V','G'))) or (ie_gerar_itens_p = 'T'))
	and	nr_seq_conta	= nr_seq_conta_w;

C03 CURSOR FOR
	SELECT	nr_sequencia,
		qt_material_imp,
		qt_material,
		vl_material_imp,
		vl_glosa,
		vl_unitario_imp
	from	pls_conta_mat
	where	(((vl_glosa	> 0) and (ie_gerar_itens_p in ('V','G'))) or (ie_gerar_itens_p = 'T'))
	and	nr_seq_conta	= nr_seq_conta_w;
	
C04 CURSOR FOR
	SELECT	nr_sequencia,
		vl_apresentado,
		vl_glosa
	from	pls_proc_participante
	where	nr_seq_conta_proc 	= nr_seq_procedimentos_w
	and	ie_status 		<> 'C'
	order by 1;

C05 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_diagnostico_conta
	where	nr_seq_conta 	= nr_seq_conta_w
	order by 1;

C06 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_diagnost_conta_obito
	where	nr_seq_conta 	= nr_seq_conta_w
	order by 1;
	
C07 CURSOR(nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_diagnostico_nasc_vivo
	where	nr_seq_conta = nr_seq_conta_pc;
	
c_cta_atributos CURSOR FOR
	SELECT	a.nm_atributo
	from	tabela_atributo		a
	where	a.nm_tabela		= 'PLS_CONTA'
	and	a.ie_tipo_atributo 	not in ('FUNCTION','VISUAL')
	order by a.nr_sequencia_criacao;
	

BEGIN
select	coalesce(ie_data_base_prot_reap,'A')
into STRICT	ie_dt_base_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_dt_base_w = 'A') then
	select	 dt_protocolo,
		dt_mes_competencia,
		dt_recebimento
	into STRICT	dt_base_w,
		dt_competencia_w,
		dt_recebimento_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_p;
else
	dt_base_w		:= clock_timestamp();
	dt_competencia_w	:= clock_timestamp();
	dt_recebimento_w	:= clock_timestamp();
end if;

-- Protocolos
select	nextval('pls_protocolo_conta_seq')
into STRICT	nr_sequencia_w
;

insert into pls_protocolo_conta(nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, nr_protocolo_prestador,
	nr_seq_prestador, dt_protocolo, ie_status,
	ie_situacao, cd_estabelecimento,cd_condicao_pagamento,
	dt_mes_competencia, dt_recebimento, dt_integracao, nr_seq_transacao,
	dt_base_venc, nr_seq_outorgante, nm_usuario_integracao,
	ds_hash, nr_seq_grau_partic, nr_seq_prot_referencia,
	ie_tipo_guia, cd_profissional_executor,ds_observacao,
	ie_tipo_protocolo, ie_apresentacao, ie_origem_protocolo,
	ie_guia_fisica)
(SELECT	nr_sequencia_w, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, nr_protocolo_prestador,
	nr_seq_prestador, dt_base_w, '1',            
	ie_situacao, cd_estabelecimento_p,cd_condicao_pagamento,
	dt_competencia_w, dt_recebimento_w, dt_integracao, nr_seq_transacao,
	dt_base_venc, nr_seq_outorgante, nm_usuario_integracao,
	ds_hash, nr_seq_grau_partic, nr_sequencia, 
	ie_tipo_guia, cd_profissional_executor,ds_observacao,
	ie_tipo_protocolo,'R', ie_origem_protocolo,
	ie_guia_fisica
from	pls_protocolo_conta
where	nr_sequencia	= nr_seq_protocolo_p);


-- Contas
open C01;
loop
fetch C01 into
	nr_seq_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	nextval('pls_conta_seq')
	into STRICT	nr_seq_conta_ww
	;
	
	-- monta o sql dinamico
	ds_virgura_w		:= '';
	ds_campos_insert_cta_w	:= '';
	ds_values_insert_cta_w	:= '';
	
	-- carrega as colunas
	for r_col_w in c_cta_atributos loop
	
		-- acumula os campos da parte de insert
		ds_campos_insert_cta_w	:= ds_campos_insert_cta_w||ds_virgura_w||r_col_w.nm_atributo;
		
		-- trata e acumula os campos da etapa de select do insert
		ds_values_insert_cta_w	:= ds_values_insert_cta_w||ds_virgura_w||	case	r_col_w.nm_atributo
												when 'NR_SEQUENCIA' then to_char(nr_seq_conta_ww) -- seq novo da conta
												when 'NR_SEQ_PROTOCOLO' then to_char(nr_sequencia_w) -- seq do protocolo
												when 'NR_SEQ_ANALISE' then ''''''--nova conta nao deve estar vinculada a analise antiga
												when 'NR_SEQ_PROT_CONTA' then ''''''--nova conta nao deve estar vinculada ao demonstrativo de pagamento antigo
												when 'NM_USUARIO' then ''''||nm_usuario_p||''''
												when 'NM_USUARIO_NREC' then ''''||nm_usuario_p||''''
												when 'DT_ATUALIZACAO' then 'SYSDATE'
												when 'DT_ATUALIZACAO_NREC' then 'SYSDATE'
												when 'IE_STATUS' THEN ''''||ie_status_w||''''
												else r_col_w.nm_atributo
											end;
		ds_virgura_w := ',';
	end loop;
	
	-- monta a sentenca final
	ds_sql_insert_cta_w := 'INSERT INTO PLS_CONTA ('||ds_campos_insert_cta_w||') (SELECT '||ds_values_insert_cta_w||' FROM PLS_CONTA where (((vl_glosa	> 0) and ('''||ie_gerar_itens_p||''' in (''V'',''G''))) or ('''||ie_gerar_itens_p||''' = ''T'')) and nr_sequencia = '||to_char(nr_seq_conta_w)||') ';
	
	EXECUTE ds_sql_insert_cta_w;
	
	CALL pls_conta_tiss_pck.cria_copia_registro(nr_seq_conta_w, nr_seq_conta_ww, nm_usuario_p);
	
	-- Procedimentos
	open C02;
	loop
	fetch C02 into
		nr_seq_procedimentos_w,
		qt_item_imp_w,
		qt_item_w,
		vl_item_imp_w,
		vl_glosa_w,
		vl_unitario_imp_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		
		if (ie_gerar_itens_p = 'V') then
			vl_item_imp_w := vl_glosa_w;
			qt_item_imp_w := qt_item_imp_w - qt_item_w;
			
			if (qt_item_imp_w <= 0) then
				qt_item_imp_w := 1;
			end if;
			
			vl_unitario_imp_w := round((dividir(vl_item_imp_w, qt_item_imp_w))::numeric,2);
		end if;
		
		select	nextval('pls_conta_proc_seq')
		into STRICT	nr_seq_procedimentos_novo_w
		;
		
		insert into pls_conta_proc(cd_conta_cred, cd_conta_deb, cd_conta_glosa_cred,
			cd_conta_glosa_deb, cd_historico, cd_historico_glosa,
			cd_procedimento, ds_justificativa, ds_log,
			dt_atualizacao, dt_atualizacao_nrec, dt_fim_proc,
			dt_inicio_proc, dt_liberacao, dt_procedimento,
			ie_cobranca_prevista, ie_origem_proced, ie_situacao,
			ie_status, ie_tecnica_utilizada, ie_tipo_despesa,
			ie_via_acesso, nm_usuario, nm_usuario_liberacao,
			nm_usuario_nrec, nr_seq_conta, nr_seq_dados_proc, 
			nr_seq_grupo_ans, nr_seq_honorario_crit, nr_seq_pacote,
			nr_seq_regra, nr_seq_regra_ctb_cred, nr_seq_regra_ctb_deb,
			nr_seq_regra_horario, nr_seq_regra_liberacao, nr_seq_regra_pos_estab, 
			nr_seq_tiss_tabela, nr_sequencia, qt_procedimento,
			tx_item, tx_participacao, vl_anestesista, 
			vl_auxiliares, vl_beneficiario, vl_custo_operacional, 
			vl_glosa, vl_liberado, vl_materiais, 
			vl_medico, vl_participacao, vl_procedimento,
			vl_saldo, vl_unitario, cd_procedimento_imp,
			ds_procedimento_imp, qt_procedimento_imp,vl_procedimento_imp,
			vl_unitario_imp)
		(SELECT	cd_conta_cred, cd_conta_deb, cd_conta_glosa_cred,
			cd_conta_glosa_deb, cd_historico, cd_historico_glosa,
			cd_procedimento, ds_justificativa, ds_log,
			clock_timestamp(), clock_timestamp(), dt_fim_proc,
			dt_inicio_proc, dt_liberacao, dt_procedimento,
			ie_cobranca_prevista, ie_origem_proced, ie_situacao,
			'U', ie_tecnica_utilizada, ie_tipo_despesa,
			ie_via_acesso, nm_usuario_p, nm_usuario_liberacao, 
			nm_usuario_p, nr_seq_conta_ww, nr_seq_dados_proc, 
			nr_seq_grupo_ans, nr_seq_honorario_crit, nr_seq_pacote,
			nr_seq_regra, nr_seq_regra_ctb_cred, nr_seq_regra_ctb_deb,
			nr_seq_regra_horario, nr_seq_regra_liberacao, nr_seq_regra_pos_estab, 
			nr_seq_tiss_tabela, nr_seq_procedimentos_novo_w, 0,
			tx_item, tx_participacao, 0, 
			0, 0, 0, 
			0, 0, 0, 
			0, 0, 0,
			0, 0, cd_procedimento_imp,
			ds_procedimento_imp, qt_item_imp_w,vl_item_imp_w,
			vl_unitario_imp_w
		from	pls_conta_proc
		where	(((vl_glosa	> 0) and (ie_gerar_itens_p in ('V','G'))) or (ie_gerar_itens_p = 'T'))
		and	nr_sequencia	= nr_seq_procedimentos_w);
		
		
			-- por garantia, testa se foi criado mesmo
			select	count(1)
			into STRICT	qt_registro_w
			from	pls_conta_proc
			where	nr_sequencia	= nr_seq_procedimentos_novo_w;
			
			-- se foi criado
			if (qt_registro_w > 0) then
			
				CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_procedimentos_novo_w, nm_usuario_p);
				
				select	max(a.nr_seq_item_tiss),
					max(a.nr_seq_item_tiss_vinculo)
				into STRICT	nr_seq_item_tiss_w,
					nr_seq_item_tiss_vinculo_w
				from	pls_conta_proc_regra	a
				where	a.nr_sequencia		= nr_seq_procedimentos_w;
				
				CALL pls_cta_proc_mat_regra_pck.atualiza_seq_tiss_proc(nr_seq_procedimentos_novo_w, nr_seq_item_tiss_w, nr_seq_item_tiss_vinculo_w, nm_usuario_p);
				
			end if;
		
		open C04;
		loop
		fetch C04 into
			nr_seq_partic_w,
			vl_item_imp_w,
			vl_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			
			if (ie_gerar_itens_p = 'V') then
				vl_item_imp_w := vl_glosa_w;
			end if;
			
			insert 	into	pls_proc_participante(	cd_cbo_saude_imp, cd_cgc_imp, cd_guia,
					cd_medico, cd_medico_imp, cd_prestador_imp,
					cd_sistema_ant, dt_atualizacao, dt_atualizacao_nrec,
					ie_atualizado, ie_conselho_profissional, ie_funcao_medico_imp,
					ie_gerada_cta_honorario, ie_glosa, ie_insercao_manual,
					ie_status, ie_status_pagamento, nm_medico_executor_imp,
					nm_usuario, nm_usuario_nrec, nr_cpf_imp,
					nr_crm_imp, nr_seq_cbo_saude, nr_seq_conselho,
					nr_seq_conta_proc, nr_seq_grau_partic, nr_seq_honorario_crit,
					nr_seq_prestador, nr_seq_prestador_pgto, nr_seq_regra,
					nr_sequencia, qt_liberada, sg_conselho_imp,
					uf_conselho, uf_crm_imp, vl_apresentado,
					vl_calculado, vl_calculado_ant, vl_digitado_complemento,
					vl_glosa, vl_honorario_medico, vl_participante)
			( SELECT	cd_cbo_saude_imp, cd_cgc_imp, cd_guia,
					cd_medico, cd_medico_imp, cd_prestador_imp,
					cd_sistema_ant, dt_atualizacao, dt_atualizacao_nrec,
					ie_atualizado, ie_conselho_profissional, ie_funcao_medico_imp,
					ie_gerada_cta_honorario, ie_glosa, ie_insercao_manual,
					'U', ie_status_pagamento, nm_medico_executor_imp,
					nm_usuario, nm_usuario_nrec, nr_cpf_imp,
					nr_crm_imp, nr_seq_cbo_saude, nr_seq_conselho,
					nr_seq_procedimentos_novo_w, nr_seq_grau_partic, nr_seq_honorario_crit,
					nr_seq_prestador, nr_seq_prestador_pgto, nr_seq_regra,
					nextval('pls_proc_participante_seq'), qt_liberada, sg_conselho_imp,
					uf_conselho, uf_crm_imp, vl_item_imp_w,
					vl_calculado, vl_calculado_ant, vl_digitado_complemento,
					0, vl_honorario_medico, vl_participante
			from	pls_proc_participante
			where	nr_sequencia = nr_seq_partic_w);
			end;
		end loop;
		close C04;
		end;
	end loop;
	close C02;
	
	-- Materiais
	open C03;
	loop
	fetch C03 into
		nr_seq_materiais_w,
		qt_item_imp_w,
		qt_item_w,
		vl_item_imp_w,
		vl_glosa_w,
		vl_unitario_imp_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin	

			if (ie_gerar_itens_p = 'V') then
				vl_item_imp_w := vl_glosa_w;
				qt_item_imp_w := qt_item_imp_w - qt_item_w;
				
				if (qt_item_imp_w <= 0) then
					qt_item_imp_w := 1;
				end if;
				
				vl_unitario_imp_w := round((dividir(vl_item_imp_w, qt_item_imp_w))::numeric,2);
			end if;
			
			-- copiado do procedimento, quando chega aqui o c03 deve ter o mesmo where que o select do insert

			-- entao deve criar o material novo
			select	nextval('pls_conta_mat_seq')
			into STRICT	nr_seq_mat_novo_w
			;
		
			insert into pls_conta_mat(cd_conta_cred, cd_conta_deb, cd_conta_glosa_cred,
				cd_conta_glosa_deb, cd_historico, cd_historico_glosa,
				dt_atendimento, dt_atualizacao, dt_atualizacao_nrec, 
				dt_fim_atend, dt_inicio_atend, dt_liberacao, 
				ie_origem_preco, ie_situacao, ie_status, 
				ie_tipo_despesa, nm_usuario, nm_usuario_liberacao,
				nm_usuario_nrec, nr_seq_conta, nr_seq_grupo_ans,
				nr_seq_material, nr_seq_regra, nr_seq_regra_ctb_cred,
				nr_seq_regra_ctb_deb, nr_seq_regra_pos_estab, nr_seq_tiss_tabela,
				nr_sequencia, qt_material, tx_participacao, 
				tx_reducao_acrescimo, vl_beneficiario, vl_gerado,
				vl_glosa, vl_liberado, vl_material,
				vl_participacao, vl_saldo, vl_unitario,
				cd_material_imp, ds_material_imp, qt_material_imp,
				vl_unitario_imp, vl_material_imp)
			(SELECT	cd_conta_cred, cd_conta_deb, cd_conta_glosa_cred, 
				cd_conta_glosa_deb, cd_historico, cd_historico_glosa,
				dt_atendimento, clock_timestamp(), clock_timestamp(), 
				dt_fim_atend, dt_inicio_atend, dt_liberacao, 
				ie_origem_preco, ie_situacao, 'U', 
				ie_tipo_despesa, nm_usuario_p, nm_usuario_liberacao,
				nm_usuario_p, nr_seq_conta_ww, nr_seq_grupo_ans,
				nr_seq_material, nr_seq_regra, nr_seq_regra_ctb_cred,
				nr_seq_regra_ctb_deb, nr_seq_regra_pos_estab, nr_seq_tiss_tabela,
				nr_seq_mat_novo_w, 0, tx_participacao, 
				tx_reducao_acrescimo, 0, 0,
				0, 0, 0,
				vl_participacao, 0, 0,
				cd_material_imp, ds_material_imp, qt_item_imp_w,
				vl_unitario_imp_w, vl_item_imp_w
			from	pls_conta_mat
			where	(((vl_glosa	> 0) and (ie_gerar_itens_p in ('V','G'))) or (ie_gerar_itens_p = 'T'))
			and	nr_Sequencia	= nr_seq_materiais_w);
			
			-- por garantia, testa se foi criado mesmo
			select	count(1)
			into STRICT	qt_registro_w
			from	pls_conta_mat
			where	nr_sequencia	= nr_seq_mat_novo_w;
			
			-- se foi criado
			if (qt_registro_w > 0) then
			
				CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_mat_novo_w, nm_usuario_p);
				
				select	max(a.nr_seq_item_tiss),
					max(a.nr_seq_item_tiss_vinculo)
				into STRICT	nr_seq_item_tiss_w,
					nr_seq_item_tiss_vinculo_w
				from	pls_conta_mat_regra	a
				where	a.nr_sequencia		= nr_seq_materiais_w;
				
				CALL pls_cta_proc_mat_regra_pck.atualiza_seq_tiss_mat(nr_seq_mat_novo_w, nr_seq_item_tiss_w, nr_seq_item_tiss_vinculo_w, nm_usuario_p);
				
			end if;
			
		end;
	end loop;
	close C03;
	
	-- Diagnosticos
	for rec in C05
	loop
		begin
			insert into pls_diagnostico_conta(nr_sequencia,	nr_seq_conta,	dt_atualizacao,	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				ie_tipo_doenca, ie_tipo_doenca_imp, ie_indicacao_acidente, ie_indicacao_acidente_imp, ie_classificacao,
				ie_classificacao_imp, cd_doenca, cd_doenca_imp, ds_diagnostico, ds_diagnostico_imp, ds_doenca_imp,
				nm_tabela_imp, nr_declaracao_obito_imp, ie_estagio_complemento)
			(SELECT	nextval('pls_diagnostico_conta_seq'), nr_seq_conta_ww, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				ie_tipo_doenca, ie_tipo_doenca_imp, ie_indicacao_acidente, ie_indicacao_acidente_imp, ie_classificacao,
				ie_classificacao_imp, cd_doenca, cd_doenca_imp, ds_diagnostico, ds_diagnostico_imp, ds_doenca_imp,
				nm_tabela_imp, nr_declaracao_obito_imp, ie_estagio_complemento
			from	pls_diagnostico_conta
			where	nr_Sequencia	= rec.nr_sequencia);
		end;	
	end loop;
	
	-- Diagnosticos Obito
	for rec in C06
	loop
		begin		
			insert into pls_diagnost_conta_obito(nr_sequencia,	nr_seq_conta,	dt_atualizacao,	nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				cd_doenca, cd_doenca_imp, ds_doenca, ds_doenca_imp, nm_tabela, nm_tabela_imp, nr_seq_imp,
				nr_declaracao_obito, nr_declaracao_obito_imp, ie_indicador_dorn, ie_indicador_dorn_imp)
			(SELECT	nextval('pls_diagnost_conta_obito_seq'), nr_seq_conta_ww, clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				cd_doenca, cd_doenca_imp, ds_doenca, ds_doenca_imp, nm_tabela, nm_tabela_imp, nr_seq_imp,
				nr_declaracao_obito, nr_declaracao_obito_imp, ie_indicador_dorn, ie_indicador_dorn_imp
			from	pls_diagnost_conta_obito
			where	nr_Sequencia	= rec.nr_sequencia);
		end;	
	end loop;
	
	for r_C07_w in C07(nr_seq_conta_w) loop
		insert	into	pls_diagnostico_nasc_vivo(	dt_atualizacao, dt_atualizacao_nrec, ie_indicador_dorn,
				ie_indicador_dorn_imp, nm_usuario, nm_usuario_nrec,
				nr_decl_nasc_vivo, nr_decl_nasc_vivo_imp, nr_seq_conta,
				nr_seq_imp, nr_sequencia)
			(SELECT	clock_timestamp(), clock_timestamp(), ie_indicador_dorn,
				ie_indicador_dorn_imp, nm_usuario_p, nm_usuario_p,
				nr_decl_nasc_vivo, nr_decl_nasc_vivo_imp, nr_seq_conta_ww,
				nr_seq_imp, nextval('pls_diagnostico_nasc_vivo_seq')
			 from	pls_diagnostico_nasc_vivo
			 where	nr_sequencia = r_c07_w.nr_sequencia);
	end loop;
	
	CALL pls_atualiza_valor_conta(nr_seq_conta_ww, nm_usuario_p);
	end;
end loop;
close C01;

--Gerado contas reapresentacao. Protocolo #@nr_seq_protocolo#@
CALL pls_inclui_prot_conta_hist(nr_seq_protocolo_p, wheb_mensagem_pck.get_texto(315916,'nr_seq_protocolo=' || nr_sequencia_w ), nm_usuario_p, '13');
CALL pls_gerar_valores_protocolo(nr_sequencia_w, nm_usuario_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_contas_medicas_gerar_proc ( nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, ie_gerar_itens_p text default 'T', nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
