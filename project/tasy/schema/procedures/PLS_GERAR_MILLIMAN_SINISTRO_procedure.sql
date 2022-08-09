-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_milliman_sinistro ( dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_contratacao_p text, nr_seq_protocolo_p bigint, nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_lote_sip_p bigint default null) AS $body$
DECLARE

				 
 
				 
 
nr_seq_segurado_w		bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_w			bigint;
nr_milliman_sinistro_w		bigint;
ie_origem_proced_w		bigint;
cd_usuario_plano_w		varchar(30);
cd_medico_executor_w		varchar(10);
dt_atendimento_referencia_w	timestamp;
vl_total_w			double precision;
nr_seq_tipo_acomodacao_w	bigint;
dt_procedimento_w		timestamp;
nr_seq_grupo_ans_w		bigint;
vl_liberado_w			double precision;
ie_tipo_despesa_w		varchar(10);
qt_procedimento_w		double precision;
nr_diarias_w			double precision;
nr_diarias_mat_w		smallint;
nr_cti_uti_w			double precision;
vl_proc_copartic_w		double precision;
cd_procedimento_w		bigint;
nr_seq_prestador_w		bigint;
dt_lib_pagamento_w		timestamp;
ie_tipo_contratacao_w		varchar(10);
cd_classificacao_sip_w		varchar(10);
nr_seq_plano_w			bigint;
dt_protocolo_w			timestamp;
cd_especialidade_w		bigint;
nr_seq_lote_pgto_w		bigint;
vl_reembolso_w			double precision;
ie_tipo_atendimento_w		varchar(10);
ie_internado_w			varchar(10);
cd_guia_internacao_w		varchar(20);
cd_guia_w			varchar(20);
cd_guia_ambulatorial_w		varchar(20);
ds_item_despesa_sip_w		varchar(10);
ds_subitem_despesa_sip_w	varchar(10);
sg_ocorrencia_w			varchar(10);
ie_regime_internacao_w		varchar(10);
ds_seq_tipo_acomodacao_w	varchar(10);
ie_tipo_protocolo_w		varchar(10);
ie_tipo_grupo_ans_w		varchar(2);
nr_titulo_w			bigint;
dt_liquidacao_w			timestamp;
vl_glosa_w			double precision;
vl_sinistro_w			double precision;
vl_total_procedimento_w		double precision;
nr_seq_conta_mat_w		bigint;
qt_material_w			double precision;
dt_atendimento_w		timestamp;
VL_MAT_COPARTIC_W		double precision;
cd_material_w			bigint;
vl_total_material_w		double precision;
nr_seq_material_w		bigint;	
cd_material_ops_w		varchar(20);
dt_entrada_w			timestamp;
dt_alta_w			timestamp;
dt_fim_w			timestamp;

C01 CURSOR FOR 
	SELECT	i.nr_sequencia, 
		f.nr_sequencia, 
		g.nr_sequencia, 
		g.cd_medico_executor, 
		g.dt_atendimento_referencia, 
		g.vl_total, 
		g.nr_seq_tipo_acomodacao, 
		g.cd_guia, 
		g.ie_regime_internacao, 
		f.dt_procedimento, 
		f.nr_seq_grupo_ans, 
		f.vl_liberado, 
		f.ie_tipo_despesa, 
		f.qt_procedimento, 
		f.vl_proc_copartic, 
		f.cd_procedimento, 
		f.ie_origem_proced, 
		h.nr_seq_prestador, 
		h.dt_lib_pagamento, 
		i.nr_seq_plano, 
		h.dt_protocolo, 
		h.ie_tipo_protocolo, 
		f.vl_glosa, 
		f.VL_LIQUIDO, 
		b.cd_classificacao_sip 
	from	pls_lote_sip a, 
		sip_lote_item_assistencial b, 
		sip_nv_vinc_dados c, 
		sip_nv_regra_vinc_it d, 
		sip_nv_dados e, 
		pls_conta_proc f, 
		pls_conta g, 
		pls_protocolo_conta h, 
		pls_segurado i, 
		pls_contrato j, 
		pls_plano k 
	where	a.nr_sequencia	= b.nr_seq_lote 
	and	b.nr_sequencia	= c.nr_seq_item_lote 
	and	c.nr_seq_regra_vinc_it = d.nr_sequencia 
	and	e.nr_sequencia = d.nr_seq_sip_nv_dados 
	and	e.nr_seq_conta_proc = f.nr_sequencia 
	and	f.nr_seq_conta	= g.nr_sequencia 
	and	g.nr_seq_protocolo = h.nr_sequencia 
	and	g.nr_seq_segurado = i.nr_sequencia 
	and	j.nr_sequencia = i.nr_seq_contrato 
	and	i.nr_seq_plano = k.nr_sequencia 
	and	a.ie_situacao = 'A' 
	and	(d.nr_seq_regra_assist IS NOT NULL AND d.nr_seq_regra_assist::text <> '') 
	--and	e.nr_seq_lote_sip = nr_seq_lote_sip_p 
	and	e.dt_mes_competencia	between dt_inicio_p and dt_fim_w 
	and	f.vl_liberado > 0 
	and	((j.cd_operadora_empresa <> 57 and (j.cd_operadora_empresa IS NOT NULL AND j.cd_operadora_empresa::text <> '')) or (coalesce(j.cd_operadora_empresa::text, '') = '')) 
		--jung OS 545002 - Mudado para regex devido a interface 2407 usar dois tipos de contratacao. 
		--para separar os tipos de contratacao deve ser usado o caractere |(pipe) no valor do parametro 
	and	((coalesce(ie_tipo_contratacao_p::text, '') = '') or (regexp_like(k.ie_tipo_contratacao,'^'||ie_tipo_contratacao_p||'$')) and (k.ie_tipo_contratacao IS NOT NULL AND k.ie_tipo_contratacao::text <> ''))		 
	and	((coalesce(nr_seq_protocolo_p::text, '') = '') or (h.nr_sequencia = nr_seq_protocolo_p))	 
		-- retira fora os itens que são classificações da internação para que não seja enviado algo duplicado 
	and	exists (SELECT 1 
			from  sip_item_assistencial z 
			where (z.nr_sequencia < 83 or z.nr_sequencia > 108) 
			and   z.nr_sequencia = b.nr_seq_item_sip) 
	and	((coalesce(nr_seq_lote_sip_p::text, '') = '') or (a.nr_sequencia = nr_seq_lote_sip_p));
	
C03 CURSOR FOR 
	SELECT	i.nr_sequencia, 
		f.nr_sequencia, 
		g.nr_sequencia, 
		g.cd_medico_executor, 
		g.dt_atendimento_referencia, 
		g.vl_total, 
		g.nr_seq_tipo_acomodacao, 
		g.cd_guia, 
		g.ie_regime_internacao, 
		f.dt_atendimento, 
		f.nr_seq_grupo_ans, 
		f.vl_liberado, 
		f.ie_tipo_despesa, 
		f.qt_material, 
		f.vl_mat_copartic, 
		f.cd_material, 
		null, 
		h.nr_seq_prestador, 
		h.dt_lib_pagamento, 
		i.nr_seq_plano, 
		h.dt_protocolo, 
		h.ie_tipo_protocolo, 
		f.vl_glosa, 
		f.vl_liberado, 
		f.nr_seq_material, 
		b.cd_classificacao_sip 
	from	pls_lote_sip        a, 
		sip_lote_item_assistencial b, 
		sip_nv_vinc_dados     c, 
		sip_nv_regra_vinc_it    d, 
		sip_nv_dados        e, 
		pls_conta_mat f, 
		pls_conta g, 
		pls_protocolo_conta h, 
		pls_segurado i, 
		pls_contrato j, 
		pls_plano k 
	where	b.nr_seq_lote = a.nr_sequencia 
	and	c.nr_seq_item_lote = b.nr_sequencia        
	and	d.nr_sequencia = c.nr_seq_regra_vinc_it  
	and	e.nr_sequencia = d.nr_seq_sip_nv_dados 
	and	e.nr_seq_conta_mat = f.nr_sequencia 
	and	f.nr_seq_conta	= g.nr_sequencia 
	and	g.nr_seq_protocolo = h.nr_sequencia 
	and	g.nr_seq_segurado = i.nr_sequencia 
	and	j.nr_sequencia = i.nr_seq_contrato 
	and	i.nr_seq_plano = k.nr_sequencia 
	and	a.ie_situacao = 'A' 
	and	(d.nr_seq_regra_assist IS NOT NULL AND d.nr_seq_regra_assist::text <> '') 
	and	e.dt_mes_competencia	between dt_inicio_p and dt_fim_w 
	--and	e.nr_seq_lote_sip = nr_seq_lote_sip_p 
	and	f.vl_liberado > 0 
	and	((j.cd_operadora_empresa <> 57 and (j.cd_operadora_empresa IS NOT NULL AND j.cd_operadora_empresa::text <> '')) or (coalesce(j.cd_operadora_empresa::text, '') = '')) 
		--jjung OS 545002 - Mudado para regex devido a interface 2407 usar dois tipos de contratacao. 
		--para separar os tipos de contratacao deve ser usado o caractere |(pipe) no valor do parametro 
	and	((coalesce(ie_tipo_contratacao_p::text, '') = '') or (regexp_like(k.ie_tipo_contratacao,'^'||ie_tipo_contratacao_p||'$')) and (k.ie_tipo_contratacao IS NOT NULL AND k.ie_tipo_contratacao::text <> ''))		 
	and	((coalesce(nr_seq_protocolo_p::text, '') = '') or (h.nr_sequencia = nr_seq_protocolo_p)) 
	and	((coalesce(nr_seq_lote_sip_p::text, '') = '') or (a.nr_sequencia = nr_seq_lote_sip_p))	 
		-- retira fora os itens que são classificações da internação para que não seja enviado algo duplicado 
	and	exists (SELECT 1 
		    from  sip_item_assistencial f 
		    where (f.nr_sequencia < 83 or f.nr_sequencia > 108) 
		    and   f.nr_sequencia = b.nr_seq_item_sip);


BEGIN 
 
 
 
dt_fim_w := fim_dia(dt_fim_p);
 
begin 
 
delete	FROM pls_milliman_sinistro 
where	nr_seq_lote = nr_seq_lote_p;
 
exception 
when others then 
	/*Um erro ocorreu; 
	Não foi possível excluir as informações geradas anteriormente relacionadas ao lote selecionado.*/
 
	CALL wheb_mensagem_pck.Exibir_mensagem_abort(227224);
end;
 
if	(dt_inicio_p IS NOT NULL AND dt_inicio_p::text <> '' AND dt_fim_p IS NOT NULL AND dt_fim_p::text <> '') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_segurado_w, 
		nr_seq_conta_proc_w, 
		nr_seq_conta_w, 
		cd_medico_executor_w, 
		dt_atendimento_referencia_w, 
		vl_total_w, 
		nr_seq_tipo_acomodacao_w, 
		cd_guia_w, 
		ie_regime_internacao_w, 
		dt_procedimento_w, 
		nr_seq_grupo_ans_w, 
		vl_liberado_w, 
		ie_tipo_despesa_w, 
		qt_procedimento_w, 
		vl_proc_copartic_w, 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		nr_seq_prestador_w, 
		dt_lib_pagamento_w, 
		nr_seq_plano_w, 
		dt_protocolo_w, 
		ie_tipo_protocolo_w, 
		vl_glosa_w, 
		vl_total_procedimento_w, 
		cd_classificacao_sip_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ie_internado_w		:= substr(pls_obter_se_internado(nr_seq_conta_w,''),1,2);
		cd_usuario_plano_w	:= substr(pls_obter_dados_segurado(nr_seq_segurado_w,'C'),1,30);
		 
		select	max(a.cd_especialidade) 
		into STRICT	cd_especialidade_w 
		from	especialidade_medica	a, 
			medico_especialidade	b 
		where	a.cd_especialidade	= b.cd_especialidade 
		and	b.cd_pessoa_fisica	= cd_medico_executor_w 
		and	b.nr_seq_prioridade	=	(SELECT	min(x.nr_seq_prioridade) 
							from	medico_especialidade	x 
							where	x.cd_pessoa_fisica	= cd_medico_executor_w);
		 
		nr_cti_uti_w			:= substr(pls_obter_qt_cti_uti_milliman(nr_seq_conta_proc_w),1,10);
		nr_seq_tipo_acomodacao_w	:= substr(pls_obter_cd_tiss_acomodacao(nr_seq_tipo_acomodacao_w),1,10);
		 
		select	max(substr(obter_dados_pf_pj(cd_pessoa_fisica,cd_cgc, 'UF'),1,2)) 
		into STRICT	sg_ocorrencia_w 
		from	pls_prestador 
		where	nr_sequencia	= nr_seq_prestador_w;
		 
		if (coalesce(sg_ocorrencia_w::text, '') = '') then 
			sg_ocorrencia_w := '00';
		end if;
		 
		cd_guia_internacao_w		:= '';
		ds_seq_tipo_acomodacao_w	:= '';
		cd_guia_ambulatorial_w		:= '';
		nr_diarias_w			:= '';
		vl_reembolso_w			:= '';
		qt_procedimento_w		:= 0;
		 
		select	max(nr_seq_lote_pgto) 
		into STRICT	nr_seq_lote_pgto_w 
		from	pls_conta_medica_resumo 
		where	nr_seq_conta_proc	= nr_seq_conta_proc_w 
		and	nr_seq_conta		= nr_seq_conta_w 
		and	((ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''));
		 
		select	max(nr_titulo) 
		into STRICT	nr_titulo_w 
		from	pls_lote_pagamento		a, 
			pls_pagamento_prestador		b, 
			pls_pag_prest_vencimento	c 
		where	a.nr_sequencia	= b.nr_seq_lote 
		and	b.nr_sequencia	= c.nr_seq_pag_prestador 
		and	a.nr_sequencia	= nr_seq_lote_pgto_w;
		 
		select	max(dt_vencimento_original) 
		into STRICT	dt_liquidacao_w 
		from	titulo_pagar 
		where	nr_titulo	= nr_titulo_w;
		 
		begin 
		select	substr(ie_tipo_grupo_ans,1,2) 
		into STRICT	ie_tipo_grupo_ans_w 
		from	ans_grupo_despesa 
		where	nr_sequencia	= nr_seq_grupo_ans_w;
		exception 
		when others then 
			ie_tipo_grupo_ans_w	:= null;
		end;
		 
		if (ie_internado_w	= 'S') then 
			if (nr_seq_tipo_acomodacao_w = 1) then 
				ds_seq_tipo_acomodacao_w	:= '01';
			else 
				ds_seq_tipo_acomodacao_w	:= '02';
			end if;
			 
			cd_guia_internacao_w	:= cd_guia_w;
			ie_regime_internacao_w	:= ie_regime_internacao_w || '.0';
		else 
			cd_guia_ambulatorial_w	:= cd_guia_w;
			ie_regime_internacao_w	:= '';
		end if;
 
		select	max(ie_tipo_contratacao) 
		into STRICT	ie_tipo_contratacao_w 
		from	pls_plano 
		where	nr_sequencia	= nr_seq_plano_w;
		 
		if (ie_tipo_contratacao_w = 'I') then 
			ie_tipo_contratacao_w	:= 'IN';
		end if;
		 
		if (coalesce(dt_procedimento_w::text, '') = '') then 
			dt_procedimento_w	:= dt_atendimento_referencia_w;
		end if;
		 
		ie_tipo_atendimento_w	:= '02';
		if (coalesce(ie_tipo_protocolo_w,'C') = 'R') then 
			vl_reembolso_w		:= vl_total_procedimento_w /*vl_total_w*/
;
			ie_tipo_atendimento_w	:= '03';
		end if;
		 
		if (coalesce(nr_seq_conta_w,0)>0) then 
			select	max(dt_entrada), 
				max(dt_alta) 
			into STRICT	dt_entrada_w, 
				dt_alta_w 
			from 	pls_conta 
			where	nr_sequencia = nr_seq_conta_w;
			 
			if (dt_entrada_w IS NOT NULL AND dt_entrada_w::text <> '') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
				if (trunc(dt_alta_w) = trunc(dt_entrada_w)) then 
					nr_diarias_w := 1;
				else 
					nr_diarias_w	:= greatest(( trunc(dt_alta_w) - trunc(dt_entrada_w) ),0);
				end if;
			end if;		
		end if;	
		 
		ds_item_despesa_sip_w		:= substr(cd_classificacao_sip_w,1,1) || '.' || substr(cd_classificacao_sip_w,2,1);
		ds_subitem_despesa_sip_w	:= substr(cd_classificacao_sip_w,2,3);
 
		vl_sinistro_w	:= (coalesce(vl_glosa_w,0) + coalesce(vl_liberado_w,0)); -- askono - OS 454061 - Solicitação Alex HVC. 
		insert into pls_milliman_sinistro(nr_sequencia, dt_atualizacao, nm_usuario, 
			nm_usuario_nrec, cd_usuario_plano, dt_atualizacao_nrec, 
			dt_ocorrencia, dt_aviso, cd_evento, 
			cd_especialidade, vl_sinistro, vl_reembolso, 
			vl_pagamento, qt_diaria_uti, qt_diaria_cti_uti, 
			vl_coparticipacao, ie_tipo_atendimento, ie_tipo_acomodacao, 
			cd_procedimento, ie_origem_proced, dt_pagamento, 
			cd_guia_internacao, cd_guia_ambulatorial, qt_procedimento, 
			nr_seq_prestador, ds_item_despesa_sip, sg_ocorrencia, 
			ie_tipo_contratacao, ie_regime_internacao, ds_subitem_despesa_sip, 
			ds_versao_sip, nr_seq_lote, nr_seq_conta, 
			nr_seq_conta_proc) 
		values (nextval('pls_milliman_sinistro_seq'), clock_timestamp(), nm_usuario_p, 
			nm_usuario_p, cd_usuario_plano_w, clock_timestamp(), 
			dt_procedimento_w, dt_protocolo_w, ie_tipo_grupo_ans_w, 
			cd_especialidade_w, vl_sinistro_w , vl_reembolso_w, 
			--jjung - OS 499400 - Conforme solicitado por Alex, se for conta de reembolso o valor de pagamento deve ser gravado em branco. 
			CASE WHEN coalesce(ie_tipo_protocolo_w,'C')='R' THEN null  ELSE vl_liberado_w END , nr_diarias_w, nr_cti_uti_w, 
			vl_proc_copartic_w, ie_tipo_atendimento_w, ds_seq_tipo_acomodacao_w, 
			cd_procedimento_w, ie_origem_proced_w, dt_liquidacao_w, 
			cd_guia_internacao_w, cd_guia_ambulatorial_w, qt_procedimento_w, 
			nr_seq_prestador_w, ds_item_despesa_sip_w, sg_ocorrencia_w, 
			ie_tipo_contratacao_w, ie_regime_internacao_w, ds_subitem_despesa_sip_w, 
			'NI21', nr_seq_lote_p, nr_seq_conta_w, 
			nr_seq_conta_proc_w);
		end;
	end loop;
	close C01;
 
 
	open C03;
	loop 
	fetch C03 into	 
		nr_seq_segurado_w, 
		nr_seq_conta_mat_w, 
		nr_seq_conta_w, 
		cd_medico_executor_w, 
		dt_atendimento_referencia_w, 
		vl_total_w, 
		nr_seq_tipo_acomodacao_w, 
		cd_guia_w, 
		ie_regime_internacao_w, 
		dt_atendimento_w, 
		nr_seq_grupo_ans_w, 
		vl_liberado_w, 
		ie_tipo_despesa_w, 
		qt_material_w, 
		vl_mat_copartic_w, 
		cd_material_w, 
		ie_origem_proced_w, 
		nr_seq_prestador_w, 
		dt_lib_pagamento_w, 
		nr_seq_plano_w, 
		dt_protocolo_w, 
		ie_tipo_protocolo_w, 
		vl_glosa_w, 
		vl_total_material_w, 
		nr_seq_material_w, 
		cd_classificacao_sip_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		cd_especialidade_w	:= '';
		nr_cti_uti_w		:= 0;
		 
		cd_material_ops_w	:= substr(pls_obter_seq_codigo_material(nr_seq_material_w,''),1,255);
		ie_internado_w		:= substr(pls_obter_se_internado(nr_seq_conta_w,''),1,2);
		cd_usuario_plano_w	:= substr(pls_obter_dados_segurado(nr_seq_segurado_w,'C'),1,30);
		 
		begin 
		select	max(a.cd_especialidade) 
		into STRICT	cd_especialidade_w 
		from	especialidade_medica	a, 
			medico_especialidade	b 
		where	a.cd_especialidade	= b.cd_especialidade 
		and	b.cd_pessoa_fisica	= cd_medico_executor_w 
		and	b.nr_seq_prioridade	=	(SELECT	min(x.nr_seq_prioridade) 
							from	medico_especialidade	x 
							where	x.cd_pessoa_fisica	= cd_medico_executor_w);
		exception 
		when others then 
			cd_especialidade_w	:= '';
		end;
 
		nr_seq_tipo_acomodacao_w	:= substr(pls_obter_cd_tiss_acomodacao(nr_seq_tipo_acomodacao_w),1,10);
		 
		begin 
		select	substr(obter_dados_pf_pj(cd_pessoa_fisica,cd_cgc, 'UF'),1,2) 
		into STRICT	sg_ocorrencia_w 
		from	pls_prestador 
		where	nr_sequencia	= nr_seq_prestador_w;
		exception 
		when others then 
			sg_ocorrencia_w	:= '00';
		end;
		 
		cd_guia_internacao_w		:= '';
		ds_seq_tipo_acomodacao_w	:= '';
		cd_guia_ambulatorial_w		:= '';
		nr_diarias_w			:= '';
		vl_reembolso_w			:= '';
		dt_entrada_w			:= null;
		dt_alta_w			:= null;
		 
		select	max(nr_seq_lote_pgto) 
		into STRICT	nr_seq_lote_pgto_w 
		from	pls_conta_medica_resumo 
		where	nr_seq_conta_mat	= nr_seq_conta_mat_w 
		and	nr_seq_conta		= nr_seq_conta_w 
		and	((ie_situacao != 'I') or (coalesce(ie_situacao::text, '') = ''));
		 
		select	max(nr_titulo) 
		into STRICT	nr_titulo_w 
		from	pls_lote_pagamento		a, 
			pls_pagamento_prestador		b, 
			pls_pag_prest_vencimento	c 
		where	a.nr_sequencia	= b.nr_seq_lote 
		and	b.nr_sequencia	= c.nr_seq_pag_prestador 
		and	a.nr_sequencia	= nr_seq_lote_pgto_w;
		 
		select	max(dt_vencimento_original) 
		into STRICT	dt_liquidacao_w 
		from	titulo_pagar 
		where	nr_titulo	= nr_titulo_w;
		 
		begin 
		select	substr(ie_tipo_grupo_ans,1,2) 
		into STRICT	ie_tipo_grupo_ans_w 
		from	ans_grupo_despesa 
		where	nr_sequencia	= nr_seq_grupo_ans_w;
		exception 
		when others then 
			ie_tipo_grupo_ans_w	:= null;
		end;
		 
		if (ie_internado_w = 'S') then 
			if (nr_seq_tipo_acomodacao_w = 1) then 
				ds_seq_tipo_acomodacao_w	:= '01';
			else 
				ds_seq_tipo_acomodacao_w	:= '02';
			end if;
			 
			cd_guia_internacao_w	:= cd_guia_w;
			ie_regime_internacao_w	:= ie_regime_internacao_w|| '.0';
		else 
			cd_guia_ambulatorial_w	:= cd_guia_w;
			ie_regime_internacao_w	:= '';
		end if;
 
		select	max(ie_tipo_contratacao) 
		into STRICT	ie_tipo_contratacao_w 
		from	pls_plano 
		where	nr_sequencia	= nr_seq_plano_w;
		 
		if (ie_tipo_contratacao_w = 'I') then 
			ie_tipo_contratacao_w	:= 'IN';
		end if;
		 
		if (coalesce(dt_atendimento_w::text, '') = '') then 
			dt_atendimento_w	:= dt_atendimento_referencia_w;
		end if;
		 
		ie_tipo_atendimento_w	:= '02';
		if (coalesce(ie_tipo_protocolo_w,'C')	= 'R') then 
			vl_reembolso_w		:= vl_total_material_w /*vl_total_w*/
;
			ie_tipo_atendimento_w	:= '03';
		end if;
		 
		if (coalesce(nr_seq_conta_w,0) > 0) then 
			begin 
			select	max(dt_entrada), 
				max(dt_alta) 
			into STRICT	dt_entrada_w, 
				dt_alta_w 
			from 	pls_conta 
			where	nr_sequencia = nr_seq_conta_w;		
			exception 
			when others then 
				dt_entrada_w	:= null;
				dt_alta_w	:= null;
			end;	
			 
			if (dt_entrada_w IS NOT NULL AND dt_entrada_w::text <> '') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
				if (trunc(dt_alta_w) = trunc(dt_entrada_w)) then 
					nr_diarias_mat_w	:= 1;
				else 
					nr_diarias_mat_w	:= greatest(( trunc(dt_alta_w) - trunc(dt_entrada_w) ),0);
				end if;
			end if;
		end if;		
		 
		ds_item_despesa_sip_w		:= substr(cd_classificacao_sip_w,1,1) || '.' || substr(cd_classificacao_sip_w,2,1);
		ds_subitem_despesa_sip_w	:= substr(cd_classificacao_sip_w,2,3);
			 
		vl_sinistro_w	:= (coalesce(vl_glosa_w,0) + coalesce(vl_liberado_w,0)); -- askono - OS 454061 - Solicitação Alex HVC. 
			
		insert into pls_milliman_sinistro(nr_sequencia, dt_atualizacao, nm_usuario, 
			nm_usuario_nrec, cd_usuario_plano, dt_atualizacao_nrec, 
			dt_ocorrencia, dt_aviso, cd_evento, 
			cd_especialidade, vl_sinistro, vl_reembolso, 
			vl_pagamento, qt_diaria_uti, qt_diaria_cti_uti, 
			vl_coparticipacao, ie_tipo_atendimento, ie_tipo_acomodacao, 
			cd_procedimento, ie_origem_proced, dt_pagamento, 
			cd_guia_internacao, cd_guia_ambulatorial, qt_procedimento, 
			nr_seq_prestador, ds_item_despesa_sip, sg_ocorrencia, 
			ie_tipo_contratacao, ie_regime_internacao, ds_subitem_despesa_sip, 
			ds_versao_sip, nr_seq_lote, nr_seq_conta, 
			nr_seq_conta_mat) 
		values (nextval('pls_milliman_sinistro_seq'), clock_timestamp(), nm_usuario_p, 
			nm_usuario_p, cd_usuario_plano_w, clock_timestamp(), 
			dt_atendimento_w, dt_protocolo_w, ie_tipo_grupo_ans_w, 
			cd_especialidade_w, vl_sinistro_w , vl_reembolso_w, 
			--jjung - OS 499400 - Conforme solicitado por Alex, se for conta de reembolso o valor de pagamento deve ser gravado em branco. 
			CASE WHEN coalesce(ie_tipo_protocolo_w,'C')='R' THEN null  ELSE vl_liberado_w END , nr_diarias_mat_w, nr_cti_uti_w, 
			vl_proc_copartic_w, ie_tipo_atendimento_w, ds_seq_tipo_acomodacao_w, 
			cd_material_ops_w, ie_origem_proced_w, dt_liquidacao_w, 
			cd_guia_internacao_w, cd_guia_ambulatorial_w, qt_material_w, 
			nr_seq_prestador_w, ds_item_despesa_sip_w, sg_ocorrencia_w, 
			ie_tipo_contratacao_w, ie_regime_internacao_w, ds_subitem_despesa_sip_w, 
			'NI21', nr_seq_lote_p, nr_seq_conta_w, 
			nr_seq_conta_mat_w);
		end;
	end loop;
	close C03;
	/*ajustado para material*/
 
else 
 
/* 
Deve ser informado um período válido para geração de dados para esta interface. 
 
Data inicio: dt_inicio_p 
Data fim: dt_fim_p 
*/
 
wheb_mensagem_pck.Exibir_mensagem_abort(227223,'dt_inicio_p='||to_char(dt_inicio_p,'dd/mm/yyyy')||';dt_fim_p='||to_char(dt_fim_p));
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_milliman_sinistro ( dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_contratacao_p text, nr_seq_protocolo_p bigint, nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_lote_sip_p bigint default null) FROM PUBLIC;
