-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_substituir_item_conta ( cd_item_p bigint, ie_tipo_p text, ie_origem_proced_p bigint, qt_item_p bigint, vl_uni_apres_p bigint, vl_total_apres_p bigint, nr_seq_conta_p bigint, nr_seq_item_subs_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_motivo_glosa_p bigint, nr_id_transacao_p bigint, nr_seq_item_criado_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
/*Realizar testes na função OPS - Análise de produção médica e OPS - Gestão de contas médicas, verificar se ao alterar para umas das funções mencionadas continua a atender para a outra
verificar principalmente em relação a função OPS - Gestão de contas médicas, devido a maioria dos clientes utilizar estas
/*
No NR_SEQ_OCOR_BENEF_P e no NR_SEQ_CONTA_GLOSA_P
iremos passar a sequência da ocorrência/glosa que foi lançada na análise, para não inativar a mesma
*/
nr_nota_fiscal_w			varchar(255);
ie_status_proc_w			varchar(3);
ie_via_acesso_w				varchar(1);
ie_tecnica_utilizada_w			varchar(1);
ds_observacao_w				varchar(255);
tx_medico_w				double precision;
tx_co_w					double precision;
tx_material_w				double precision;
nr_seq_analise_w			bigint;
cd_procedimento_w			bigint;
cd_proc_anterior_w			bigint;
ie_origem_proc_anterior_w		bigint;
nr_seq_material_w			bigint;
nr_seq_material_anterior_w		bigint;
nr_seq_conta_proc_w			bigint;
nr_seq_conta_mat_w			bigint;
nr_seq_proc_participante_w		bigint;
nr_seq_setor_atend_w			bigint;
nr_seq_prest_fornec_w			bigint;
nr_seq_regra_canc_item_orig_w		bigint;
nr_seq_proc_honor_w			bigint;
tx_item_w				double precision;
dt_item_w				timestamp;
dt_inicio_w				timestamp;
dt_fim_w				timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_proc_participante a,
		pls_conta_proc b,
		pls_conta c
	where	a.nr_seq_conta_proc 	= b.nr_sequencia
	and	b.nr_seq_conta      	= c.nr_sequencia
	and	b.nr_sequencia 		= nr_seq_item_subs_p
	and (coalesce(a.ie_status,'U') <> 'C' or (nr_seq_regra_canc_item_orig_w IS NOT NULL AND nr_seq_regra_canc_item_orig_w::text <> ''))
	order by 1;
	
C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_conta_proc	a,
		pls_conta	b
	where	b.nr_sequencia	= a.nr_seq_conta
	and	a.nr_seq_agrup_analise		= nr_seq_item_subs_p
	and	b.nr_seq_conta_referencia	= nr_seq_conta_p;


BEGIN

begin
	select 	max(nr_seq_analise)
	into STRICT	nr_seq_analise_w
	from 	w_pls_analise_item 
	where	nr_seq_conta	= nr_seq_conta_p
	and	((nr_id_transacao = nr_id_transacao_p) or (coalesce(nr_id_transacao_p::text, '') = ''));
exception
	when others then
	nr_seq_analise_w	:= null;	
end;

if (ie_tipo_p = 'P') then
	begin
	select	a.dt_procedimento,
		a.dt_inicio_proc,
		a.dt_fim_proc,
		a.ie_via_acesso,
		a.ie_tecnica_utilizada,
		a.nr_seq_setor_atend,
		a.tx_item,
		a.tx_medico,
		a.tx_custo_operacional,
		a.tx_material,
		a.ie_status,
		nr_seq_regra_canc_item_orig
	into STRICT	dt_item_w,
		dt_inicio_w,
		dt_fim_w,
		ie_via_acesso_w,
		ie_tecnica_utilizada_w,
		nr_seq_setor_atend_w,
		tx_item_w,
		tx_medico_w,
		tx_co_w,
		tx_material_w,
		ie_status_proc_w,
		nr_seq_regra_canc_item_orig_w
	from	pls_conta_proc	a
	where	a.nr_sequencia	= nr_seq_item_subs_p;
	exception
	when others then
		dt_item_w		:= null;
		dt_inicio_w		:= null;
		dt_fim_w		:= null;
		ie_via_acesso_w		:= null;
		ie_tecnica_utilizada_w	:= null;
		nr_seq_setor_atend_w	:= null;
		tx_item_w		:= null;
		tx_medico_w		:= null;
		tx_co_w			:= null;
		tx_material_w		:= null;
	end;
	
	/* Francisco - 24/12/2012 - OS 531926 - Se o item que está sendo substituído tinha sido
	cancelado para geração dos honorários, cancelar os honorários primeiro, senão vai ficar
	duplicado */
	
	select	nextval('pls_conta_proc_seq')
	into STRICT	nr_seq_conta_proc_w
	;
	
	insert into pls_conta_proc(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento_imp,
		vl_procedimento_imp,
		vl_unitario_imp,
		nr_seq_conta,
		ie_status,
		ie_situacao,
		ie_glosa,
		nr_seq_proc_princ,
		dt_procedimento,
		dt_inicio_proc,
		dt_fim_proc,
		ie_via_acesso,
		ie_tecnica_utilizada,
		nr_seq_setor_atend,
		tx_item,
		tx_medico,
		tx_custo_operacional,
		tx_material,
		ie_acao_analise)
	values (nr_seq_conta_proc_w,
		nm_usuario_p,clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_item_p,
		ie_origem_proced_p,
		qt_item_p,
		vl_total_apres_p,
		vl_uni_apres_p,
		nr_seq_conta_p,
		'U',
		'D',
		'N',
		nr_seq_item_subs_p,
		dt_item_w,
		dt_inicio_w,
		dt_fim_w,
		ie_via_acesso_w,
		ie_tecnica_utilizada_w,
		nr_seq_setor_atend_w,
		tx_item_w,
		tx_medico_w,
		tx_co_w,
		tx_material_w,
		'S');
	
	CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_conta_proc_w, nm_usuario_p);
	CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_proc(nr_seq_conta_proc_w, null, null, nr_seq_conta_p, nm_usuario_p);
		
	nr_seq_item_criado_p	:= nr_seq_conta_proc_w;

	insert into pls_conta_log(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario_alteracao,
		dt_alteracao,
		nr_seq_conta,
		nr_seq_conta_proc,
		ds_alteracao)
	values (nextval('pls_conta_log_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_conta_p,
		nr_seq_item_subs_p,
		'Conta proc: ' || nr_seq_item_subs_p || ' substituída pela conta ' || nr_seq_conta_proc_w);
	
	if (nr_seq_regra_canc_item_orig_w IS NOT NULL AND nr_seq_regra_canc_item_orig_w::text <> '') then
		open C02;
		loop
		fetch C02 into	
			nr_seq_proc_honor_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			CALL pls_cancelar_item_conta('P', nr_seq_conta_p, nr_seq_proc_honor_w, nm_usuario_p,nr_seq_ocorrencia_p,nr_seq_motivo_glosa_p,cd_estabelecimento_p);
			end;
		end loop;
		close C02;
	end if;
	
	open C01;
	loop
	fetch C01 into	
		nr_seq_proc_participante_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		insert into pls_proc_participante(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_conta_proc,
			cd_medico,
			nr_cpf_imp,
			nm_medico_executor_imp,
			sg_conselho_imp,
			nr_crm_imp,
			uf_crm_imp,
			ie_funcao_medico_imp,
			cd_cgc_imp,
			cd_medico_imp,
			nr_seq_grau_partic,
			nr_seq_cbo_saude,
			cd_cbo_saude_imp,
			vl_participante,
			vl_honorario_medico,
			nr_seq_honorario_crit,
			ie_conselho_profissional,
			nr_seq_prestador_pgto,
			cd_guia,
			nr_seq_conselho,
			cd_prestador_imp,
			nr_seq_prestador,
			uf_conselho,
			vl_apresentado,
			ie_atualizado,
			ie_insercao_manual,
			vl_calculado,
			ie_glosa,
			vl_glosa,
			nr_seq_regra,
			ie_status,
			vl_digitado_complemento)
			SELECT	nextval('pls_proc_participante_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_conta_proc_w,
				cd_medico,
				nr_cpf_imp,
				nm_medico_executor_imp,
				sg_conselho_imp,
				nr_crm_imp,
				uf_crm_imp,  
				ie_funcao_medico_imp,
				cd_cgc_imp,
				cd_medico_imp,           
				nr_seq_grau_partic,
				nr_seq_cbo_saude,
				cd_cbo_saude_imp,
				0,
				0,
				null,      
				ie_conselho_profissional,
				null,
				cd_guia,                      
				nr_seq_conselho,
				cd_prestador_imp,
				nr_seq_prestador,
				uf_conselho,
				0,
				ie_atualizado,            
				ie_insercao_manual,
				0,
				ie_glosa,          
				0,
				nr_seq_regra,
				'U',      
				vl_digitado_complemento
			from	pls_proc_participante
			where	nr_sequencia	= nr_seq_proc_participante_w;
				
			update	pls_proc_participante
			set	ie_status	= 'C'
			where	nr_sequencia	= nr_seq_proc_participante_w;
			
			update	pls_conta_glosa a
			set	a.ie_situacao		= 'I',
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	a.nr_seq_proc_partic	= nr_seq_proc_participante_w;
			
			update	pls_ocorrencia_benef
			set	ie_situacao		= 'I',
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
			where	nr_seq_proc_partic	= nr_seq_proc_participante_w;
		end;
	end loop;
	close C01;
	
	CALL pls_cancelar_item_conta('P', nr_seq_conta_p, nr_seq_item_subs_p, nm_usuario_p,nr_seq_ocorrencia_p,nr_seq_motivo_glosa_p,cd_estabelecimento_p);
	
	update	pls_conta_glosa a
	set	a.ie_situacao		= 'I',
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
	where	a.nr_seq_conta_proc	= nr_seq_item_subs_p
	and (a.nr_seq_motivo_glosa	<> nr_seq_motivo_glosa_p or coalesce(nr_seq_motivo_glosa_p::text, '') = '');
	
	update	pls_ocorrencia_benef a
	set	ie_situacao		= 'I',
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
	where	nr_seq_proc		= nr_seq_item_subs_p
	and (a.nr_seq_ocorrencia <> nr_seq_ocorrencia_p or coalesce(nr_seq_ocorrencia_p::text, '') = '');
	
	begin
		select	
			max(cd_procedimento),
			max(ie_origem_proced)
		into STRICT	cd_proc_anterior_w,
			ie_origem_proc_anterior_w
		from	w_pls_analise_item
		where	nr_seq_conta_proc = nr_seq_item_subs_p
		and	((nr_id_transacao = nr_id_transacao_p) or (coalesce(nr_id_transacao_p::text, '') = ''));
	exception
		when others then
		cd_proc_anterior_w	:= null;
		ie_origem_proc_anterior_w := null;
	end;	
	
	if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then
		ds_observacao_w :=	'Procedimento Alterado: '|| substr(cd_proc_anterior_w || '-' || pls_obter_desc_procedimento(cd_proc_anterior_w,ie_origem_proc_anterior_w),1,100) ||
						chr(13) || chr(10) || 'Novo procedimento: ' || substr(cd_item_p || '-' || pls_obter_desc_procedimento(cd_item_p,ie_origem_proced_p),1,100);
		/*Inserindo histórico*/

		CALL pls_inserir_hist_analise(nr_seq_conta_p, nr_seq_analise_w, 14,
					 nr_seq_conta_proc_w, 'P', null,
					 null,ds_observacao_w, nr_seq_item_subs_p,
					 nm_usuario_p,cd_estabelecimento_p);
	end if;
else

	begin
	select	a.dt_atendimento,
		a.dt_inicio_atend,
		a.dt_fim_atend,
		a.nr_nota_fiscal,
		a.nr_seq_prest_fornec
	into STRICT	dt_item_w,
		dt_inicio_w,
		dt_fim_w,
		nr_nota_fiscal_w,
		nr_seq_prest_fornec_w
	from	pls_conta_mat	a
	where	a.nr_sequencia	= nr_seq_item_subs_p;
	exception
		when others then
		dt_item_w	:= null;
		dt_inicio_w	:= null;
		dt_fim_w	:= null;
		nr_nota_fiscal_w	:= null;
		nr_seq_prest_fornec_w	:= null;
	end;
	
	select	nextval('pls_conta_mat_seq')
	into STRICT	nr_seq_conta_mat_w
	;
	
	insert into pls_conta_mat(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_material,
		qt_material_imp,
		vl_material_imp,
		vl_unitario_imp,
		nr_seq_conta,
		ie_status,
		ie_situacao,
		ie_glosa,
		nr_seq_mat_princ,
		dt_atendimento,
		dt_inicio_atend,
		dt_fim_atend,
		nr_nota_fiscal,
		nr_seq_prest_fornec,
		ie_acao_analise)
	values (nr_seq_conta_mat_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_item_p,
		qt_item_p,
		vl_total_apres_p,
		vl_uni_apres_p,
		nr_seq_conta_p,
		'U',
		'D',
		'N',
		nr_seq_item_subs_p,
		dt_item_w,
		dt_inicio_w,
		dt_fim_w,
		nr_nota_fiscal_w,
		nr_seq_prest_fornec_w,
		'S');
	
	CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);
	CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_mat(nr_seq_conta_mat_w, null, null, nr_seq_conta_p, nm_usuario_p);
		
	nr_seq_item_criado_p	:= nr_seq_conta_mat_w;

	insert into pls_conta_log(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario_alteracao,
		dt_alteracao,
		nr_seq_conta,
		nr_seq_conta_mat,
		ds_alteracao)
	values (nextval('pls_conta_log_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_conta_p,
		nr_seq_item_subs_p,
		'Conta mat: ' || nr_seq_item_subs_p || ' substituída pela conta ' || nr_seq_conta_mat_w);
	
	CALL pls_cancelar_item_conta('M', nr_seq_conta_p, nr_seq_item_subs_p, nm_usuario_p,nr_seq_ocorrencia_p,nr_seq_motivo_glosa_p,cd_estabelecimento_p);
	
	update	pls_conta_glosa a
	set	a.ie_situacao		= 'I',
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
	where	a.nr_seq_conta_mat	= nr_seq_item_subs_p
	and (a.nr_seq_motivo_glosa	<> nr_seq_motivo_glosa_p or coalesce(nr_seq_motivo_glosa_p::text, '') = '');
	
	update	pls_ocorrencia_benef a
	set	ie_situacao		= 'I',
		ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
	where	nr_seq_mat		= nr_seq_item_subs_p
	and (a.nr_seq_ocorrencia <> nr_seq_ocorrencia_p or coalesce(nr_seq_ocorrencia_p::text, '') = '');
	
	begin
		select	max(nr_seq_material)
		into STRICT	nr_seq_material_anterior_w
		from	w_pls_analise_item
		where	nr_seq_conta_mat = nr_seq_item_subs_p
		and	((nr_id_transacao = nr_id_transacao_p) or (coalesce(nr_id_transacao_p::text, '') = ''));
	exception
		when others then
		cd_proc_anterior_w	:= null;
		ie_origem_proc_anterior_w := null;
	end;
	if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then
		ds_observacao_w :=	'Material alterado: '||nr_seq_material_anterior_w || '-' || pls_obter_desc_material(nr_seq_material_anterior_w) || chr(13) || chr(10) ||
				'novo material: '||cd_item_p || '-' || pls_obter_desc_material(cd_item_p);
		/*Inserindo histórico*/

		CALL pls_inserir_hist_analise(nr_seq_conta_p,  nr_seq_analise_w, 14, nr_seq_conta_mat_w, 'M', null, null,ds_observacao_w, nr_seq_material_anterior_w, nm_usuario_p,cd_estabelecimento_p);
	end if;
end if;

CALL pls_atualiza_valor_conta(nr_seq_conta_p, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_substituir_item_conta ( cd_item_p bigint, ie_tipo_p text, ie_origem_proced_p bigint, qt_item_p bigint, vl_uni_apres_p bigint, vl_total_apres_p bigint, nr_seq_conta_p bigint, nr_seq_item_subs_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_motivo_glosa_p bigint, nr_id_transacao_p bigint, nr_seq_item_criado_p INOUT bigint) FROM PUBLIC;
