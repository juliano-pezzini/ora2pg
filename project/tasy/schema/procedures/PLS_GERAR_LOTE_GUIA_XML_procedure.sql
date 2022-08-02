-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_guia_xml ( nr_seq_lote_p bigint, ie_opcao_p text, nm_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_referencia_w			timestamp;
ie_tipo_guia_param_w		varchar(3);
nr_seq_pagador_w		bigint;
nr_seq_mens_guia_envio_w	bigint;
------------------------------------------------------------------------------------ 
nr_seq_guia_mens_arq_w		bigint;
qt_registros_w			bigint;
qt_guias_geradas_w		bigint;
------------------------------------------------------------------------------------ 
nr_seq_mensalidade_seg_item_w	bigint;
nr_seq_conta_w			bigint;
nr_seq_mensalidade_w		bigint;
nr_seq_segurado_w		bigint;
ie_tipo_guia_w			varchar(5);
cd_registro_ans_w		varchar(30);
--dt_emissao_guia_w		date; alterado para DT_ATEND_REF_GUIA_W 
dt_atend_ref_guia_w		timestamp;
cd_guia_w			varchar(30);
cd_guia_referencia_w		varchar(30);
cd_guia_prestador_w		varchar(30);
cd_usuario_plano_w		varchar(30);
nr_cartao_nac_sus_w		varchar(30);
nm_beneficiario_w		varchar(255);
nm_produto_w			varchar(255);
cd_medico_solic_w		varchar(10);
------------------------------------------------------------------------------------------ 
nm_profissional_solic_w		varchar(255);
sg_conselho_solic_w		varchar(10);
sg_conselho_solic_aux_w		varchar(10);
nr_conselho_solic_w		varchar(20);
uf_conselho_solic_w		varchar(2);
------------------------------------------------------------------------------------------ 
cd_medico_exec_w		varchar(10);
sg_conselho_executante_w	varchar(10);
sg_conselho_executante_aux_w	varchar(10);
uf_conselho_executante_w	varchar(10);
nr_conselho_executante_w	varchar(20);
nm_profissional_executante_w	varchar(255);
------------------------------------------------------------------------------------------ 
nr_seq_prestador_exe_w		bigint;
cd_prestador_exec_w		varchar(255);
cd_cnes_exec_w			varchar(255);
nm_prestador_exec_w		varchar(255);
------------------------------------------------------------------------------------------ 
nr_seq_prestador_solic_w	bigint;
cd_prestador_solic_w		varchar(255);
cd_cnes_solic_w			varchar(255);
nm_prestador_solic_w		varchar(255);

ie_carater_internacao_w		varchar(10);
dt_atendimento_w		timestamp;
nr_seq_saida_spsadt_w		bigint;
nr_seq_tipo_atendimento_w	bigint;
dt_autorizacao_w		timestamp;
cd_senha_w			varchar(20);
dt_validade_autorizacao_w	timestamp;
cd_cbos_w			varchar(15);
nm_tabela_cid_w			varchar(255);
cd_cid_w			varchar(10);
ds_cid_w			varchar(255);
ie_tipo_consulta_w		varchar(10);
nr_seq_tipo_acomodacao_w	bigint;
nr_seq_grau_partic_w		bigint;
nr_seq_saida_int_w		bigint;
ie_regime_internacao_w		varchar(10);
nr_seq_clinica_w		bigint;
dt_entrada_w			timestamp;
dt_saida_w			timestamp;
------------------------------------------------------------------------------------ 
nr_seq_conta_proc_w		bigint;
nr_seq_regra_conver_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_procedimento_w		timestamp;
dt_inicio_proc_w		timestamp;
dt_fim_proc_w			timestamp;
qt_procedimento_w		bigint;
vl_unitario_proc_w		pls_conta_proc.vl_unitario%type;
vl_procedimento_w		double precision;
ie_via_acesso_w			varchar(10);
ie_tecnica_utilizada_w		varchar(10);

cd_tipo_tabela_w		varchar(10);
NR_SEQ_TISS_TAB_CONVERSAO_w	bigint;

------------------------------------------------------------------------------------ 
nr_seq_conta_mat_w		bigint;
nr_seq_material_w		bigint;
nr_seq_regra_mat_conver_w	bigint;
cd_material_ops_w		varchar(20);
cd_material_conver_w		varchar(20);
tx_reducao_acrescimo_w		double precision;
qt_material_w			bigint;
vl_unitario_mat_w		pls_conta_mat.vl_unitario%type;
vl_material_w			double precision;
ie_tipo_despesa_w		varchar(10);

vl_beneficiario_w		double precision;
vl_benef_unit_w			double precision;
nr_seq_guia_w			bigint;

C01 CURSOR FOR 
	SELECT	c.nr_sequencia nr_seq_mensalidade_seg_item, 
		d.nr_sequencia nr_seq_conta, 
		a.nr_sequencia nr_seq_mensalidade, 
		e.nr_sequencia nr_seq_segurado, 
		d.cd_guia, 
		d.cd_guia_referencia, 
		d.cd_guia_prestador, 
		d.dt_atendimento_referencia, 
		coalesce(g.nr_cartao_intercambio,g.cd_usuario_plano), 
		h.nm_pessoa_fisica, 
		f.ds_plano, 
		d.cd_medico_solicitante, 
		d.nr_seq_prestador_exec, 
		d.ie_carater_internacao, 
		coalesce(d.dt_atendimento_referencia, d.dt_atendimento), 
		coalesce(d.nr_seq_saida_spsadt,nr_seq_saida_consulta), 
		d.nr_seq_tipo_atendimento, 
		d.ie_tipo_guia, 
		h.nr_cartao_nac_sus, 
		d.cd_medico_executor, 
		d.nr_seq_conselho_exec, 
		d.nr_seq_conselho_solic, 
		d.ie_tipo_consulta, 
		coalesce(d.nr_seq_prestador,i.nr_seq_prestador), 
		d.nr_seq_tipo_acomodacao, 
		d.nr_seq_grau_partic, 
		d.nr_seq_saida_int, 
		d.ie_regime_internacao, 
		d.nr_seq_clinica, 
		d.dt_alta, 
		d.dt_entrada, 
		d.nr_seq_guia 
	from	pessoa_fisica			h, 
		pls_conta			d, 
		pls_mensalidade_seg_item	c, 
		pls_mensalidade_segurado	b, 
		pls_mensalidade			a, 
		pls_segurado			e, 
		pls_segurado_carteira		g, 
		pls_protocolo_conta		i, 
		pls_plano			f 
	where	h.cd_pessoa_fisica		= e.cd_pessoa_fisica 
	and	b.nr_seq_mensalidade		= a.nr_sequencia 
	and	c.nr_seq_mensalidade_seg	= b.nr_sequencia 
	and	c.nr_seq_conta			= d.nr_sequencia 
	and	b.nr_seq_segurado		= e.nr_sequencia 
	and	b.nr_seq_plano			= f.nr_sequencia 
	and	g.nr_seq_segurado		= e.nr_sequencia 
	and	d.nr_seq_protocolo		= i.nr_sequencia 
	and	coalesce(a.ie_cancelamento::text, '') = '' 
	and	c.ie_tipo_item	in ('6','7') 
	and	trunc(b.dt_mesano_referencia,'month')	= trunc(dt_referencia_w,'month') 
	and	d.ie_tipo_guia = ie_tipo_guia_param_w 
	and	((e.nr_seq_pagador = nr_seq_pagador_w) or (coalesce(nr_seq_pagador_w::text, '') = ''));

C02 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		coalesce(b.CD_ITEM_CONVERTIDO_XML,a.cd_procedimento), 
		a.ie_origem_proced, 
		a.dt_procedimento, 
		a.dt_inicio_proc, 
		a.dt_fim_proc, 
		a.qt_procedimento, 
		a.vl_unitario, 
		a.vl_liberado, 
		a.ie_tecnica_utilizada, 
		a.ie_via_acesso, 
		b.nr_seq_tiss_tab_conversao 
	from	pls_conta_proc			a, 
		PLS_CONTA_POS_ESTABELECIDO	b 
	where	b.nr_seq_conta_proc	= a.nr_sequencia 
	and	a.nr_seq_conta		= nr_seq_conta_w 
	and	a.ie_status		in ('S','L');

C03 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		coalesce(b.CD_ITEM_CONVERTIDO_XML,a.nr_seq_material), 
		a.dt_atendimento, 
		a.tx_reducao_acrescimo, 
		a.qt_material, 
		a.vl_unitario, 
		a.vl_liberado, 
		a.ie_tipo_despesa 
	from	pls_conta_mat			a, 
		PLS_CONTA_POS_ESTABELECIDO	b 
	where	b.nr_seq_conta_mat	= a.nr_sequencia 
	and	a.nr_seq_conta		= nr_seq_conta_w 
	and	a.ie_status		in ('S','L');

C04 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_mens_guia_arquivo 
	where	nr_seq_lote	= nr_seq_lote_p;


BEGIN 
 
if (ie_opcao_p = 'G') then 
	select	dt_referencia, 
		ie_tipo_guia, 
		nr_seq_pagador 
	into STRICT	dt_referencia_w, 
		ie_tipo_guia_param_w, 
		nr_seq_pagador_w 
	from	pls_lote_mens_guia_envio 
	where	nr_sequencia	= nr_seq_lote_p;
	 
	select	nextval('pls_mens_guia_arquivo_seq') 
	into STRICT	nr_seq_guia_mens_arq_w 
	;
	 
	insert into pls_mens_guia_arquivo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, 
			nr_seq_lote,ie_tipo_guia) 
	values (	nr_seq_guia_mens_arq_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, 
			nr_seq_lote_p,ie_tipo_guia_param_w);
	 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_mensalidade_seg_item_w, 
		nr_seq_conta_w, 
		nr_seq_mensalidade_w, 
		nr_seq_segurado_w, 
		cd_guia_w, 
		cd_guia_referencia_w, 
		cd_guia_prestador_w, 
		dt_atend_ref_guia_w, 
		cd_usuario_plano_w, 
		nm_beneficiario_w, 
		nm_produto_w, 
		cd_medico_solic_w, 
		nr_seq_prestador_exe_w, 
		ie_carater_internacao_w, 
		dt_atendimento_w, 
		nr_seq_saida_spsadt_w, 
		nr_seq_tipo_atendimento_w, 
		ie_tipo_guia_w, 
		nr_cartao_nac_sus_w, 
		cd_medico_exec_w, 
		sg_conselho_executante_aux_w, 
		sg_conselho_solic_aux_w, 
		ie_tipo_consulta_w, 
		nr_seq_prestador_solic_w, 
		nr_seq_tipo_acomodacao_w, 
		nr_seq_grau_partic_w, 
		nr_seq_saida_int_w, 
		ie_regime_internacao_w, 
		nr_seq_clinica_w, 
		dt_saida_w, 
		dt_entrada_w, 
		nr_seq_guia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	count(1) 
		into STRICT	qt_registros_w 
		from	pls_mensalidade_guia_envio 
		where	nr_seq_guia_arquivo	= nr_seq_guia_mens_arq_w;
		 
		if (qt_registros_w > 100) then 
			select	nextval('pls_mens_guia_arquivo_seq') 
			into STRICT	nr_seq_guia_mens_arq_w 
			;
			 
			insert into pls_mens_guia_arquivo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, 
					nr_seq_lote,IE_TIPO_GUIA) 
			values (	nr_seq_guia_mens_arq_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, 
					nr_seq_lote_p,ie_tipo_guia_param_w);
		end if;
		 
		nm_profissional_solic_w		:= '';
		sg_conselho_solic_w		:= '';
		nr_conselho_solic_w		:= '';
		uf_conselho_solic_w		:= '';
		cd_prestador_exec_w		:= '';
		cd_cnes_exec_w			:= '';
		nm_prestador_exec_w		:= '';
		nm_tabela_cid_w			:= '';
		ds_cid_w			:= '';
		sg_conselho_executante_w	:= '';
		uf_conselho_executante_w	:= '';
		nr_conselho_executante_w	:= '';
		nm_profissional_executante_w	:= '';
		 
		if (cd_medico_solic_w IS NOT NULL AND cd_medico_solic_w::text <> '') then 
			nm_profissional_solic_w		:= substr(obter_nome_medico(cd_medico_solic_w,'N'),1,255);
			sg_conselho_solic_w		:= coalesce(substr(pls_obter_seq_conselho_prof(cd_medico_solic_w),1,255),sg_conselho_solic_aux_w);
			nr_conselho_solic_w		:= substr(obter_crm_medico(cd_medico_solic_w),1,255);
			uf_conselho_solic_w		:= substr(obter_dados_medico(cd_medico_solic_w,'UFCRM'),1,255);
		end if;
		 
		if (cd_medico_exec_w IS NOT NULL AND cd_medico_exec_w::text <> '') then 
			nm_profissional_executante_w	:= substr(obter_nome_medico(cd_medico_exec_w,'N'),1,255);
			sg_conselho_executante_w	:= coalesce(substr(pls_obter_seq_conselho_prof(cd_medico_exec_w),1,255),sg_conselho_executante_aux_w);
			nr_conselho_executante_w	:= substr(obter_crm_medico(cd_medico_exec_w),1,255);
			uf_conselho_executante_w	:= substr(obter_dados_medico(cd_medico_exec_w,'UFCRM'),1,255);
		end if;
		 
		if (nr_seq_prestador_exe_w IS NOT NULL AND nr_seq_prestador_exe_w::text <> '') then 
			cd_prestador_exec_w		:= substr(pls_obter_cod_prestador(nr_seq_prestador_exe_w,null),1,255);
			cd_cnes_exec_w			:= substr(pls_obter_cnes_prestador(nr_seq_prestador_exe_w),1,255);
			nm_prestador_exec_w		:= substr(pls_obter_dados_prestador(nr_seq_prestador_exe_w,'N'),1,255);
		end if;
		 
		if (nr_seq_prestador_solic_w IS NOT NULL AND nr_seq_prestador_solic_w::text <> '') then 
			cd_prestador_solic_w		:= substr(pls_obter_cod_prestador(nr_seq_prestador_solic_w,null),1,255);
			cd_cnes_solic_w			:= substr(pls_obter_cnes_prestador(nr_seq_prestador_solic_w),1,255);
			nm_prestador_solic_w		:= substr(pls_obter_dados_prestador(nr_seq_prestador_solic_w,'N'),1,255);
		end if;
		 
		begin 
		select	max(dt_autorizacao), 
			max(cd_senha), 
			max(dt_validade_senha) 
		into STRICT	dt_autorizacao_w, 
			cd_senha_w, 
			dt_validade_autorizacao_w 
		from	pls_guia_plano 
		where	cd_guia	= cd_guia_w;
		exception 
		when others then 
			dt_autorizacao_w		:= null;
			cd_senha_w			:= null;
			dt_validade_autorizacao_w	:= null;
		end;
		 
		select	max(cd_doenca) 
		into STRICT	cd_cid_w 
		from	pls_diagnostico_conta 
		where	nr_seq_conta	= nr_seq_conta_w;
		 
		if (cd_cid_w IS NOT NULL AND cd_cid_w::text <> '') then 
			nm_tabela_cid_w	:= substr(obter_categoria_cid(cd_cid_w),1,255);
			ds_cid_w	:= substr(obter_desc_cid(cd_cid_w),1,255);
		end if;
		 
		 
		nr_conselho_executante_w	:= somente_numero(nr_conselho_executante_w);
		 
		select	nextval('pls_mensalidade_guia_envio_seq') 
		into STRICT	nr_seq_mens_guia_envio_w 
		;
		 
		insert	into	pls_mensalidade_guia_envio(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, nr_seq_lote, 
				cd_estabelecimento,nr_seq_guia_arquivo,cd_guia,cd_guia_referencia,cd_guia_prestador, 
				dt_emissao_guia,dt_autorizacao,cd_senha,dt_validade_autorizacao,cd_usuario_plano, 
				nr_cartao_nac_sus,nr_seq_segurado,nm_beneficiario,cd_prestador_exec,cd_cnes_exec, 
				nm_prestador_exec,nr_conselho_solic,nm_profissional_solic,sg_conselho_solic,uf_conselho_solic, 
				ie_carater_internacao,dt_atendimento,ie_tipo_atendimento,ie_tipo_saida,cd_cid, 
				ds_cid,ie_tipo_guia,nm_produto,nm_tabela_cid,nr_seq_conta, 
				nr_seq_mensalidade_seg_item,sg_conselho_executante,uf_conselho_executante,nr_conselho_executante,nm_profissional_executante, 
				ie_tipo_consulta,cd_prestador_solic,cd_cnes_prestador,nm_prestador_solic,nr_seq_tipo_acomodacao, 
				nr_seq_grau_partic,nr_seq_saida_int,ie_regime_internacao,nr_seq_clinica,dt_entrada, 
				dt_saida, nr_seq_guia_plano) 
		values (	nr_seq_mens_guia_envio_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, nr_seq_lote_p, 
				cd_estabelecimento_p,nr_seq_guia_mens_arq_w,cd_guia_w,cd_guia_referencia_w,cd_guia_prestador_w, 
				dt_atend_ref_guia_w,dt_autorizacao_w,cd_senha_w,dt_validade_autorizacao_w,cd_usuario_plano_w, 
				nr_cartao_nac_sus_w,nr_seq_segurado_w,nm_beneficiario_w,cd_prestador_exec_w,cd_cnes_exec_w, 
				nm_prestador_exec_w,nr_conselho_solic_w,nm_profissional_solic_w,sg_conselho_solic_w,uf_conselho_solic_w, 
				ie_carater_internacao_w,dt_atendimento_w,nr_seq_tipo_atendimento_w,nr_seq_saida_spsadt_w,cd_cid_w, 
				ds_cid_w,ie_tipo_guia_w,nm_produto_w,nm_tabela_cid_w,nr_seq_conta_w, 
				nr_seq_mensalidade_seg_item_w,sg_conselho_executante_w,uf_conselho_executante_w,nr_conselho_executante_w,nm_profissional_executante_w, 
				ie_tipo_consulta_w,cd_prestador_solic_w,cd_cnes_solic_w,nm_prestador_solic_w,NR_SEQ_TIPO_ACOMODACAO_w, 
				nr_seq_grau_partic_w,nr_seq_saida_int_w,ie_regime_internacao_w,nr_seq_clinica_w,dt_entrada_w, 
				dt_saida_w, nr_seq_guia_w);
		 
		update	pls_mensalidade_seg_item 
		set	nr_seq_item_envio_guia	= nr_seq_mens_guia_envio_w 
		where	nr_sequencia		= nr_seq_mensalidade_seg_item_w;
		 
		open C02;
		loop 
		fetch C02 into 
			nr_seq_conta_proc_w, 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			dt_procedimento_w, 
			dt_inicio_proc_w, 
			dt_fim_proc_w, 
			qt_procedimento_w, 
			vl_unitario_proc_w, 
			vl_procedimento_w, 
			ie_via_acesso_w, 
			ie_tecnica_utilizada_w, 
			NR_SEQ_TISS_TAB_CONVERSAO_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			 
			if (coalesce(dt_procedimento_w::text, '') = '') then 
				dt_procedimento_w	:= dt_atend_ref_guia_w;
			end if;
			 
			cd_tipo_tabela_w	:= '';
			 
			if (nr_seq_tiss_tab_conversao_w IS NOT NULL AND nr_seq_tiss_tab_conversao_w::text <> '') then 
				select	max(cd_tabela_xml) 
				into STRICT	cd_tipo_tabela_w 
				from	tiss_tipo_tabela 
				where	nr_sequencia	= nr_seq_tiss_tab_conversao_w;
			end if;
			 
			if (coalesce(cd_tipo_tabela_w::text, '') = '') then 
				/* AMB */
 
				if (ie_origem_proced_w = 1) then 
					cd_tipo_tabela_w	:= '01';
				/* CBHPM */
 
				elsif (ie_origem_proced_w = 5) then 
					cd_tipo_tabela_w	:= '06';
				/* SUS_2008 */
 
				elsif (ie_origem_proced_w = 7) then 
					cd_tipo_tabela_w	:= '10';
				/* TUSS */
 
				elsif (ie_origem_proced_w = 8) then 
					cd_tipo_tabela_w	:= '16';
				/* PROPRIO */
 
				elsif (ie_origem_proced_w = 4) then 
					cd_tipo_tabela_w	:= '94';
				end if;
			end if;
			 
			select	sum(vl_beneficiario) 
			into STRICT	vl_beneficiario_w 
			from	pls_conta_pos_estabelecido 
			where	nr_seq_conta_proc	= nr_seq_conta_proc_w;
			 
			if (coalesce(qt_procedimento_w,0) > 0) then 
				vl_benef_unit_w	:= vl_beneficiario_w / qt_procedimento_w;
			else 
				vl_benef_unit_w	:= vl_beneficiario_w;
			end if;
			 
			insert	into pls_mens_guia_envio_proc(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				nr_seq_guia_envio, nr_seq_conta_proc, cd_procedimento, ie_origem_proced, cd_tipo_tabela, 
				dt_procedimento, dt_inicio_proc, 
				dt_fim_proc, vl_unitario, vl_procedimento, qt_procedimento, ie_via_acesso, 
				ie_tecnica_utilizada, vl_beneficiario, vl_beneficiario_unit) 
			values (	nextval('pls_mens_guia_envio_proc_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(),nm_usuario_p, 
				nr_seq_mens_guia_envio_w, nr_seq_conta_proc_w, cd_procedimento_w, ie_origem_proced_w, cd_tipo_tabela_w, 
				dt_procedimento_w, dt_inicio_proc_w, 
				dt_fim_proc_w,vl_unitario_proc_w, vl_procedimento_w, qt_procedimento_w, ie_via_acesso_w, 
				ie_tecnica_utilizada_w, vl_beneficiario_w, vl_benef_unit_w);
			end;
		end loop;
		close C02;
		 
		open C03;
		loop 
		fetch C03 into 
			nr_seq_conta_mat_w, 
			nr_seq_material_w, 
			dt_atendimento_w, 
			tx_reducao_acrescimo_w, 
			qt_material_w, 
			vl_unitario_mat_w, 
			vl_material_w, 
			ie_tipo_despesa_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			 
			if (coalesce(dt_atendimento_w::text, '') = '') then 
				dt_atendimento_w	:= dt_atend_ref_guia_w;
			end if;
			 
			select	max(cd_material_ops) 
			into STRICT	cd_material_ops_w 
			from	pls_material 
			where	nr_sequencia	= nr_seq_material_w;
			 
			select	sum(vl_beneficiario) 
			into STRICT	vl_beneficiario_w 
			from	pls_conta_pos_estabelecido 
			where	nr_seq_conta_mat	= nr_seq_conta_mat_w;
			 
			if (coalesce(qt_material_w,0) > 0) then 
				vl_benef_unit_w	:= vl_beneficiario_w / qt_material_w;
			else 
				vl_benef_unit_w	:= vl_beneficiario_w;
			end if;
			 
			insert	into pls_mens_guia_envio_mat(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				nr_seq_conta_mat, cd_material_ops, nr_seq_material, 
				dt_atendimento, tx_reducao_acrescimo, qt_material, vl_unitario,vl_material, 
				ie_tipo_despesa, nr_seq_guia_envio, vl_beneficiario, vl_beneficiario_unit) 
			values (	nextval('pls_mens_guia_envio_mat_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				nr_seq_conta_mat_w, cd_material_ops_w, nr_seq_material_w, 
				dt_atendimento_w, tx_reducao_acrescimo_w, qt_material_w, vl_unitario_mat_w, vl_material_w, 
				ie_tipo_despesa_w, nr_seq_mens_guia_envio_w, vl_beneficiario_w, vl_benef_unit_w);
			end;
		end loop;
		close C03;
		end;
	end loop;
	close C01;
	 
	select	count(1) 
	into STRICT	qt_guias_geradas_w 
	from	pls_mens_guia_arquivo	b, 
		pls_mensalidade_guia_envio	a 
	where	a.nr_seq_guia_arquivo	= b.nr_sequencia 
	and	b.nr_seq_lote		= nr_seq_lote_p;
	 
	if (qt_guias_geradas_w > 0) then 
		open c04;
		loop 
		fetch c04 into 
			nr_seq_guia_mens_arq_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin 
			select	count(1) 
			into STRICT	qt_guias_geradas_w 
			from	pls_mensalidade_guia_envio 
			where	nr_seq_guia_arquivo	= nr_seq_guia_mens_arq_w;
			 
			update	pls_mens_guia_arquivo 
			set	qt_contas	= qt_guias_geradas_w 
			where	nr_sequencia	= nr_seq_guia_mens_arq_w;
			 
			end;
		end loop;
		close c04;
		 
		update	pls_lote_mens_guia_envio 
		set	dt_geracao_lote	= clock_timestamp() 
		where	nr_sequencia	= nr_seq_lote_p;
	else 
		delete	FROM pls_mens_guia_arquivo 
		where	nr_seq_lote	= nr_seq_lote_p;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_guia_xml ( nr_seq_lote_p bigint, ie_opcao_p text, nm_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

