-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atual_w_resumo_conta_ptu ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_princ_p bigint, nr_seq_analise_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_prestador_exec_w		bigint;
nr_seq_grau_partic_w		bigint;
nr_seq_conta_referencia_w	bigint;
nr_seq_item_w			bigint;
ie_tipo_item_w			varchar(1);
cd_item_w			bigint;
ie_origem_proced_w		bigint;
ie_tipo_despesa_w		varchar(10);
ie_via_acesso_w			varchar(10);
dt_item_w			timestamp;
tx_item_w			double precision;
qt_apresentado_w		double precision;
qt_liberado_w			double precision;
vl_unitario_w			pls_conta_proc.vl_unitario%type;

vl_total_w			double precision;
vl_taxa_servico_imp_w		double precision;
vl_taxa_co_imp_w		double precision;
vl_taxa_material_imp_w		double precision;
vl_taxa_material_w		double precision;
vl_taxa_servico_w		double precision;
vl_taxa_co_w			double precision;
vl_taxa_mat_material_w		double precision;
vl_taxa_mat_material_imp_w	double precision;
vl_taxa_intercambio_imp_w	double precision;
vl_taxa_intercambio_w		double precision;
cd_medico_executor_w		varchar(10);
ie_tipo_guia_w			varchar(10);
cd_guia_referencia_w		varchar(20);
cd_guia_w			varchar(20);
nr_seq_apres_w			bigint;
ds_grau_participacao_w		varchar(255);
ds_item_w			varchar(255);
ds_via_acesso_w			varchar(255);
nm_prestador_w			varchar(255);
nm_participante_w		varchar(255);
ds_tipo_guia_w			varchar(255);
ie_status_w			varchar(1);
qt_glosa_w			integer;
ie_glosa_w			varchar(1);
qt_ocorrencia_w			integer;
ie_ocorrencia_glosa_w		varchar(1);
vl_total_apres_w		double precision;
vl_unitario_apres_w		double precision;
vl_calculado_w			double precision;
qt_ocorrencia_glosa_w		integer;
nr_seq_protocolo_w		bigint;
ie_status_conta_w		varchar(1);
ds_status_conta_w		varchar(120);
cd_porte_anestesico_w		varchar(10);
nr_auxiliares_w			bigint;
nm_prestador_pag_w		varchar(255);
nr_seq_prestador_pgto_w		bigint;
nr_seq_guia_w			bigint;
ie_autorizado_w			varchar(1)	:= 'N';
cd_classificacao_sip_w		varchar(15);
cd_classif_cred_w		varchar(40);
cd_classif_deb_w		varchar(40);
ie_carater_internacao_w		varchar(1);
ie_exige_nf_w			varchar(1);
nr_nota_fiscal_w		numeric(20);
nr_seq_prestador_solic_w	bigint;
nm_prestador_solic_w		varchar(255);
vl_coparticipacao_unit_w	double precision;
vl_coparticipacao_w		double precision;
ie_nota_fiscal_w		varchar(1);
nr_seq_restricao_w		bigint;
dt_atendimento_referencia_w	timestamp;
nr_seq_prest_fornec_w		bigint;
ds_fornecedor_w			varchar(255);
nr_seq_segurado_w		bigint;
cd_usuario_plano_w		varchar(30);
nm_segurado_w			varchar(255);
nm_prestador_exec_w		varchar(255);
nr_identificador_w		bigint;
nr_seq_item_analise_w		bigint;
nr_seq_partic_w			bigint;
cd_medico_w			varchar(10);
nr_seq_cbo_saude_w		bigint;
nr_seq_conselho_w		bigint;
nr_seq_honorario_crit_w		bigint;
nr_seq_prestador_w		bigint;
vl_honorario_medico_w		double precision;
vl_participante_w		double precision;
nr_seq_proc_ref_w		bigint;
vl_apresentado_w		double precision;
nr_seq_grau_partic_ww		bigint;
ds_grau_participacao_ww		varchar(255);
nr_seq_cbo_saude_ww		bigint;
nm_participante_ww		varchar(255);
nr_seq_apres_ww			bigint;
dt_inicio_item_w		timestamp;
nr_seq_setor_atend_w		bigint;
ds_setor_atendimento_w		varchar(255);
cd_estabelecimento_w		bigint;
ds_item_importacao_w		varchar(300);
tx_intercambio_w		double precision;
tx_intercambio_imp_w		double precision;
vl_glosa_w			double precision;
qt_partics_w			double precision;
nr_ordem_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_cbo_ww			bigint;
ie_valor_base_w			varchar(1);

vl_calc_hi_util_w		double precision;
vl_calc_co_util_w		double precision;
vl_calc_mat_util_w		double precision;

qt_liberado_conta_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		'P', 
		cd_procedimento, 
		ie_origem_proced, 
		ie_tipo_despesa, 
		ie_via_acesso, 
		dt_procedimento, 
		tx_item, 
		qt_procedimento_imp, 
		qt_procedimento, 
		vl_unitario, 
		vl_liberado, 
		vl_unitario_imp, 
		vl_procedimento_imp, 
		vl_procedimento, 
		ie_status, 
		cd_porte_anestesico, 
		nr_auxiliares, 
		cd_classificacao_sip, 
		cd_classif_cred, 
		cd_classif_deb, 
		null, 
		null, 
		'', 
		coalesce(nr_seq_proc_ref,nr_sequencia), 
		dt_inicio_proc, 
		nr_seq_setor_atend, 
		pls_obter_ds_setor_atend(nr_seq_setor_atend), 
		(cd_procedimento_imp||' - '||ds_procedimento_imp) ds_item, 
		vl_taxa_servico_imp, 
		vl_taxa_co_imp, 
		vl_taxa_material_imp, 
		vl_taxa_material, 
		vl_taxa_servico, 
		vl_taxa_co, 
		0, 
		0, 
		tx_intercambio_imp, 
		tx_intercambio, 
		vl_glosa, 
		nr_sequencia, 
		null, 
		coalesce(ie_valor_base,'1'), 
		vl_calc_hi_util, 
		vl_calc_co_util, 
		vl_calc_mat_util 
	from	pls_conta_proc 
	where	((nr_seq_conta	= nr_seq_conta_p) and ((coalesce(nr_seq_conta_proc_p,0) = 0) and (coalesce(nr_seq_conta_mat_p,0) = 0))) 
	or	nr_sequencia = nr_seq_conta_proc_p 
	
union
 
	SELECT	nr_sequencia, 
		'M', 
		nr_seq_material, 
		null, 
		ie_tipo_despesa, 
		'', 
		dt_atendimento, 
		tx_reducao_acrescimo, 
		qt_material_imp, 
		qt_material, 
		vl_unitario, 
		vl_liberado, 
		vl_unitario_imp, 
		vl_material_imp, 
		vl_material, 
		ie_status, 
		'', 
		null, 
		cd_classificacao_sip, 
		cd_classif_cred, 
		cd_classif_deb, 
		nr_nota_fiscal, 
		nr_seq_prest_fornec, 
		substr(pls_obter_dados_prestador(nr_seq_prest_fornec,'N'),1,255), 
		null, 
		dt_inicio_atend, 
		nr_seq_setor_atend, 
		pls_obter_ds_setor_atend(nr_seq_setor_atend), 
		(cd_material_imp||' - '||ds_material_imp) ds_item, 
		0, 
		0, 
		0, 
		0, 
		0, 
		0, 
		vl_taxa_material, 
		vl_taxa_material_imp, 
		tx_intercambio_imp, 
		tx_intercambio, 
		vl_glosa, 
		null, 
		nr_sequencia, 
		coalesce(ie_valor_base,'1'), 
		0, 
		0, 
		vl_material 
	from	pls_conta_mat 
	where	((nr_seq_conta	= nr_seq_conta_p) and ((coalesce(nr_seq_conta_proc_p,0) = 0) and (coalesce(nr_seq_conta_mat_p,0) = 0))) 
	or	nr_sequencia = nr_seq_conta_mat_p;


BEGIN 
 
/* Obter dados conta */
 
select	nr_seq_prestador_exec, 
	nr_seq_prestador, 
	nr_seq_grau_partic, 
	nr_seq_conta_referencia, 
	cd_medico_executor, 
	ie_tipo_guia, 
	cd_guia_referencia, 
	cd_guia, 
	nr_seq_protocolo, 
	ie_status, 
	obter_valor_dominio(1746,ie_tipo_guia), 
	obter_valor_dominio(1961,ie_status), 
	nr_seq_guia, 
	ie_carater_internacao, 
	dt_atendimento_referencia, 
	nr_seq_segurado, 
	pls_obter_dados_segurado(nr_seq_segurado,'C'), 
	pls_obter_dados_segurado(nr_seq_segurado,'N'), 
	nr_seq_cbo_saude, 
	cd_estabelecimento 
into STRICT	nr_seq_prestador_exec_w, 
	nr_seq_prestador_solic_w, 
	nr_seq_grau_partic_w, 
	nr_seq_conta_referencia_w, 
	cd_medico_executor_w, 
	ie_tipo_guia_w, 
	cd_guia_referencia_w, 
	cd_guia_w, 
	nr_seq_protocolo_w, 
	ie_status_conta_w, 
	ds_tipo_guia_w, 
	ds_status_conta_w, 
	nr_seq_guia_w, 
	ie_carater_internacao_w, 
	dt_atendimento_referencia_w, 
	nr_seq_segurado_w, 
	cd_usuario_plano_w, 
	nm_segurado_w, 
	nr_seq_cbo_saude_w, 
	cd_estabelecimento_w 
from	pls_conta 
where	nr_sequencia	= nr_seq_conta_p;
 
/*OS 453202 - Diego - No pretador pagamento deve ser informado a unimed atendimento*/
 
begin 
select	substr(pls_obter_seq_codigo_coop(nr_seq_congenere,'')||' - '||pls_obter_nome_congenere(nr_seq_congenere),1,255) 
into STRICT	nm_prestador_pag_w 
from	pls_protocolo_conta 
where	nr_sequencia = nr_seq_protocolo_w;
exception 
when others then 
	null;
end;
 
begin 
select	nr_seq_apres 
into STRICT	nr_seq_apres_w 
from	pls_grau_participacao 
where	nr_sequencia = nr_seq_grau_partic_w;
exception 
when others then 
	nr_seq_apres_w := null;
end;
 
if (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') then 
	ds_grau_participacao_w 	:= pls_obter_grau_participacao(nr_seq_grau_partic_w);
	nm_participante_w	:= Obter_nome_medico(cd_medico_executor_w,'N');
end if;
 
open C01;
loop 
fetch C01 into 
	nr_seq_item_w, 
	ie_tipo_item_w, 
	cd_item_w, 
	ie_origem_proced_w, 
	ie_tipo_despesa_w, 
	ie_via_acesso_w, 
	dt_item_w, 
	tx_item_w, 
	qt_apresentado_w, 
	qt_liberado_w, 
	vl_unitario_w, 
	vl_total_w, 
	vl_unitario_apres_w, 
	vl_total_apres_w, 
	vl_calculado_w, 
	ie_status_w, 
	cd_porte_anestesico_w, 
	nr_auxiliares_w, 
	cd_classificacao_sip_w, 
	cd_classif_cred_w, 
	cd_classif_deb_w, 
	nr_nota_fiscal_w, 
	nr_seq_prest_fornec_w, 
	ds_fornecedor_w, 
	nr_seq_proc_ref_w, 
	dt_inicio_item_w, 
	nr_seq_setor_atend_w, 
	ds_setor_atendimento_w, 
	ds_item_importacao_w, 
	vl_taxa_servico_imp_w, 
	vl_taxa_co_imp_w, 
	vl_taxa_material_imp_w, 
	vl_taxa_material_w, 
	vl_taxa_servico_w, 
	vl_taxa_co_w, 
	vl_taxa_mat_material_w, 
	vl_taxa_mat_material_imp_w, 
	tx_intercambio_imp_w, 
	tx_intercambio_w, 
	vl_glosa_w, 
	nr_seq_conta_proc_w, 
	nr_seq_conta_mat_w, 
	ie_valor_base_w, 
	vl_calc_hi_util_w, 
	vl_calc_co_util_w, 
	vl_calc_mat_util_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if (ie_tipo_item_w = 'P' ) or (ie_tipo_item_w = 'R') then 
		begin 
		select	nr_seq_cbo_saude 
		into STRICT	nr_seq_cbo_ww 
		from	pls_proc_participante	a, 
			pls_conta_proc		c 
		where	a.nr_seq_conta_proc	= c.nr_sequencia 
		and	c.nr_sequencia		= nr_seq_item_w;
		exception 
		when others then 
			nr_seq_cbo_ww := null;
		end;
	end if;
 
	vl_taxa_intercambio_imp_w	:= coalesce(vl_taxa_servico_imp_w,0) + coalesce(vl_taxa_co_imp_w,0) + coalesce(vl_taxa_material_imp_w,0) + coalesce(vl_taxa_mat_material_imp_w,0);
	vl_taxa_intercambio_w		:= coalesce(vl_taxa_mat_material_w,0) + coalesce(vl_taxa_servico_w,0) + coalesce(vl_taxa_material_w,0) + coalesce(vl_taxa_co_w,0);
	ie_nota_fiscal_w := '';
 
	if (coalesce(vl_unitario_apres_w,0) = 0) then 
		vl_unitario_apres_w := Dividir_sem_round(vl_total_apres_w, qt_apresentado_w);
	end if;
 
	/*Diego OS 324844 - Obter o prestador solic */
 
	select	max(nm_prestador) 
	into STRICT	nm_prestador_solic_w 
	from (SELECT	b.nr_crm||' - '||pls_obter_dados_prestador(nr_seq_prestador_solic_w, 'N') nm_prestador 
		from	pls_prestador a, 
			medico b 
		where	a.nr_sequencia = nr_seq_prestador_solic_w 
		and	coalesce(a.cd_cgc,'X') = 'X' 
		and	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
		
union
 
		SELECT	a.cd_prestador||' - '||pls_obter_dados_prestador(nr_seq_prestador_solic_w, 'N') nm_prestador 
		from	pls_prestador a 
		where	a.nr_sequencia = nr_seq_prestador_solic_w 
		and	coalesce(a.cd_cgc,'X') <> 'X') alias5;
 
	select	CASE WHEN coalesce(ie_origem_proced_w::text, '') = '' THEN pls_obter_desc_material(cd_item_w)  ELSE obter_descricao_procedimento(cd_item_w,ie_origem_proced_w) END , 
		obter_valor_dominio(1268,ie_via_acesso_w) 
	into STRICT	ds_item_w, 
		ds_via_acesso_w 
	;
 
	select	count(1) 
	into STRICT	qt_glosa_w 
	from	pls_conta_glosa 
	where	((nr_seq_conta_proc = nr_seq_item_w 
	and 	ie_tipo_item_w = 'P') 
	or (nr_seq_conta_mat = nr_seq_item_w 
	and	ie_tipo_item_w = 'M')) 
	and	ie_situacao <> 'I';
 
	select	count(1) 
	into STRICT	qt_ocorrencia_w 
	from	pls_ocorrencia_benef 
	where	((nr_seq_proc = nr_seq_item_w 
	and	ie_tipo_item_w = 'P') 
	or (nr_seq_mat = nr_seq_item_w 
	and	ie_tipo_item_w = 'M')) 
	and	nr_seq_conta = nr_seq_conta_p;
 
	qt_ocorrencia_glosa_w := coalesce(qt_ocorrencia_w,0) + coalesce(qt_glosa_w,0);
 
	if (qt_ocorrencia_glosa_w > 0) then 
		ie_ocorrencia_glosa_w := 'S';
	else 
		ie_ocorrencia_glosa_w := null;
	end if;
 
	if (coalesce(nr_seq_guia_w,0) > 0) then 
		select	CASE WHEN ie_status=1 THEN  'S'  ELSE 'N' END  
		into STRICT	ie_autorizado_w 
		from	pls_guia_plano 
		where	nr_sequencia = nr_seq_guia_w;
	end if;
 
	/*Diego OS 332168 - Obter valor de faturamento (cooparticipação + pós-estabelecido) do item.*/
 
 
	/* William - OS 397802 - Performance, select não é mais utilizado */
 
	/*begin 
	select	vl_coparticipacao_unit, 
		vl_coparticipacao 
	into	vl_coparticipacao_unit_w, 
		vl_coparticipacao_w 
	from	pls_conta_coparticipacao 
	where	(((ie_tipo_item_w = 'P') and (nr_seq_conta_proc = nr_seq_item_w)) 
	or	 ((ie_tipo_item_w = 'M') and (nr_seq_conta_mat = nr_seq_item_w))); 
	exception 
	when others then 
		vl_coparticipacao_unit_w := null; 
		vl_coparticipacao_w	 := null; 
	end;*/
 
 
	/*Obter exigência de materiais*/
 
	if (ie_tipo_item_w = 'M') then 
		if (coalesce(nr_nota_fiscal_w,0) <> 0)then 
			ie_exige_nf_w	:= 'S';	--Entregue 
		else
			nr_seq_restricao_w := pls_obter_mat_restricao_data(cd_item_w, coalesce(dt_item_w,dt_atendimento_referencia_w), nr_seq_restricao_w);
 
			ie_exige_nf_w := 'N';
 
			if (coalesce(nr_seq_restricao_w,0) > 0) then 
				select	coalesce(ie_nota_fiscal,'N') 
				into STRICT	ie_nota_fiscal_w 
				from	pls_material_restricao 
				where	nr_sequencia	= nr_seq_restricao_w;
 
				if (ie_nota_fiscal_w = 'S') then 
					ie_exige_nf_w := 'E';
				end if;
			end if;
		end if;
	else 
		ie_exige_nf_w := '';
	end if;
 
	nm_prestador_exec_w := pls_obter_dados_prestador(nr_seq_prestador_exec_w,'N');
 
	if (ie_tipo_item_w = 'P') then 
 
		select	count(a.nr_sequencia) 
		into STRICT	qt_partics_w 
		from	pls_proc_participante	a, 
			pls_conta_proc		c 
		where	a.nr_seq_conta_proc	= c.nr_sequencia 
		and	c.nr_seq_conta		= nr_seq_conta_p 
		and	coalesce(c.nr_seq_proc_ref,c.nr_sequencia)	= nr_seq_proc_ref_w;
 
		if (qt_partics_w = 0) then 
			ie_status_w := 'L';
		elsif (qt_partics_w = 1) then 
 
			select	max(a.cd_medico), 
				max(a.nr_seq_conselho), 
				max(a.nr_seq_grau_partic), 
				max(a.nr_seq_prestador), 
				max(a.nr_seq_prestador_pgto), 
				'P', 
				max(CASE WHEN coalesce(a.nr_seq_prestador::text, '') = '' THEN coalesce(Obter_nome_medico(a.cd_medico,'N'), a.nm_medico_executor_imp)  ELSE pls_obter_dados_prestador(a.nr_Seq_prestador,'N') END ), 
				max(pls_obter_grau_participacao(a.nr_seq_grau_partic)), 
				max(b.nr_seq_apres) 
			into STRICT	cd_medico_w, 
				nr_seq_conselho_w, 
				nr_seq_grau_partic_w, 
				nr_seq_prestador_w, 
				nr_seq_prestador_pgto_w, 
				ie_tipo_item_w, 
				nm_prestador_w, 
				ds_grau_participacao_w, 
				nr_seq_apres_w 
			FROM pls_conta_proc c, pls_proc_participante a
LEFT OUTER JOIN pls_grau_participacao b ON (a.nr_seq_grau_partic = b.nr_sequencia)
WHERE a.nr_seq_conta_proc	= c.nr_sequencia and c.nr_sequencia		= nr_seq_item_w;
		else 
			select	max(a.cd_medico), 
				max(a.nr_seq_conselho), 
				max(a.nr_seq_grau_partic), 
				max(a.nr_seq_prestador), 
				max(a.nr_seq_prestador_pgto), 
				'R', 
				max(CASE WHEN coalesce(a.nr_seq_prestador::text, '') = '' THEN coalesce(Obter_nome_medico(a.cd_medico,'N'), a.nm_medico_executor_imp)  ELSE pls_obter_dados_prestador(a.nr_Seq_prestador,'N') END ), 
				max(pls_obter_grau_participacao(a.nr_seq_grau_partic)), 
				max(b.nr_seq_apres) 
			into STRICT	cd_medico_w, 
				nr_seq_conselho_w, 
				nr_seq_grau_partic_w, 
				nr_seq_prestador_w, 
				nr_seq_prestador_pgto_w, 
				ie_tipo_item_w, 
				nm_participante_w, 
				ds_grau_participacao_w, 
				nr_seq_apres_w 
			FROM pls_conta_proc c, pls_proc_participante a
LEFT OUTER JOIN pls_grau_participacao b ON (a.nr_seq_grau_partic = b.nr_sequencia)
WHERE a.nr_seq_conta_proc	= c.nr_sequencia and c.nr_sequencia		= nr_seq_item_w;
 
		end if;
	end if;
 
	select	CASE WHEN ie_tipo_item_w || ie_tipo_despesa_w='P1' THEN '1' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P2' THEN '3' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P3' THEN '2' WHEN ie_tipo_item_w || ie_tipo_despesa_w='P4' THEN '4' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M1' THEN '6' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M2' THEN '5' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M3' THEN '7' WHEN ie_tipo_item_w || ie_tipo_despesa_w='M7' THEN '8' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R1' THEN '1' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R2' THEN '3' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R3' THEN '2' WHEN ie_tipo_item_w || ie_tipo_despesa_w='R4' THEN '4' END  
	into STRICT	nr_ordem_w 
	;
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_item_analise_w 
	from	w_pls_resumo_conta 
	where (nr_seq_conta_proc 	= nr_seq_conta_proc_w 
	or	nr_seq_conta_mat 	= nr_seq_conta_mat_w) 
	and	nr_seq_analise		= nr_seq_analise_p;
 
	update w_pls_resumo_conta 
	set	nr_seq_conta = nr_seq_conta_p, 
		nr_seq_item = nr_seq_item_w, 
		ds_tipo_despesa = ie_tipo_item_w || ie_tipo_despesa_w, 
		ie_via_acesso = ie_via_acesso_w, 
		nr_seq_prestador_exec = nr_seq_prestador_exec_w, 
		dt_item = dt_item_w, 
		cd_item = cd_item_w, 
		ie_origem_proced = ie_origem_proced_w, 
		nr_seq_grau_partic = nr_seq_grau_partic_w, 
		tx_item = tx_item_w, 
		ds_grau_participacao = ds_grau_participacao_w, 
		qt_apresentado = coalesce(qt_apresentado_w,1), 
		qt_liberado = coalesce(qt_liberado_w,0), 
		vl_unitario = coalesce(vl_unitario_w,0), 
		vl_total = coalesce(vl_total_w,0), 
		nr_seq_conta_referencia = nr_seq_conta_referencia_w, 
		cd_medico_executor = cd_medico_executor_w, 
		ie_tipo_guia = ie_tipo_guia_w, 
		cd_guia_referencia = cd_guia_referencia_w, 
		cd_guia = cd_guia_w, 
		nr_seq_apres_prof = coalesce(nr_seq_apres_w,0), 
		nm_usuario = nm_usuario_p, 
		dt_atualizacao = clock_timestamp(), 
		nm_usuario_nrec = nm_usuario_p, 
		dt_atualizacao_nrec = clock_timestamp(), 
		ds_item = ds_item_w, 
		nm_participante = nm_participante_w, 
		ds_via_acesso = ds_via_acesso_w, 
		nm_prestador = nm_prestador_w, 
		ds_tipo_guia = ds_tipo_guia_w, 
		ie_status = ie_status_w, 
		vl_calculado = coalesce(vl_calculado_w,0), 
		ie_ocorrencia_glosa = ie_ocorrencia_glosa_w, 
		vl_unitario_apres = coalesce(vl_unitario_apres_w,0), 
		vl_total_apres = coalesce(vl_total_apres_w,0), 
		nr_seq_protocolo = nr_seq_protocolo_w, 
		ie_status_conta = ie_status_conta_w, 
		nm_prestador_pagamento = nm_prestador_pag_w, 
		ie_tipo_despesa = ie_tipo_despesa_w, 
		ie_tipo_item = ie_tipo_item_w, 
		ds_status_conta = ds_status_conta_w, 
		nr_seq_analise = nr_seq_analise_p, 
		cd_porte_anestesico = cd_porte_anestesico_w, 
		nr_auxiliares = nr_auxiliares_w, 
		nr_seq_prestador_pgto = nr_seq_prestador_pgto_w, 
		nr_seq_guia = nr_seq_guia_w, 
		ie_autorizado = ie_autorizado_w, 
		cd_classificacao_sip = cd_classificacao_sip_w, 
		cd_classif_cred = cd_classif_cred_w, 
		cd_classif_deb = cd_classif_deb_w, 
		ie_carater_internacao = ie_carater_internacao_w, 
		ie_exige_nf = ie_exige_nf_w, 
		nr_nota_fiscal = nr_nota_fiscal_w, 
		nr_seq_res_conta_princ = nr_seq_conta_princ_p, 
		nr_seq_prestador_solic = nr_seq_prestador_solic_w, 
		nm_prestador_solic = nm_prestador_solic_w, 
		nr_seq_prest_fornec = nr_seq_prest_fornec_w, 
		ds_fornecedor = ds_fornecedor_w, 
		ie_pagamento = 'G', 
		nr_seq_segurado = nr_seq_segurado_w, 
		nm_segurado = nm_segurado_w, 
		cd_usuario_plano = cd_usuario_plano_w, 
		nm_prestador_exec = nm_prestador_exec_w, 
		nr_seq_cbo_saude = coalesce(nr_seq_cbo_saude_w,nr_seq_cbo_ww), 
		nr_seq_item_ref = nr_seq_proc_ref_w, 
		dt_inicio_item = dt_inicio_item_w, 
		ds_setor_atendimento = ds_setor_atendimento_w, 
		nr_seq_setor_atend = nr_seq_setor_atend_w, 
		ds_item_importacao = ds_item_importacao_w, 
		vl_taxa_intercambio_imp = vl_taxa_intercambio_imp_w, 
		vl_taxa_intercambio = vl_taxa_intercambio_w, 
		tx_intercambio_imp = tx_intercambio_imp_w, 
		tx_intercambio = tx_intercambio_w, 
		vl_glosa = vl_glosa_w, 
		nr_ordem = nr_ordem_w, 
		nr_seq_conta_proc = nr_seq_conta_proc_w, 
		nr_seq_conta_mat = nr_seq_conta_mat_w, 
		ie_valor_base = ie_valor_base_w, 
		vl_calculado_hi    	= coalesce(vl_calc_hi_util_w,0), 
		vl_calculado_co    	= coalesce(vl_calc_co_util_w,0), 
		vl_calculado_material 	= coalesce(vl_calc_mat_util_W,0) 
	where	nr_sequencia = nr_seq_item_analise_w;
 
	CALL pls_analise_status_item(nr_seq_conta_p,	nr_seq_conta_mat_w, nr_seq_conta_proc_w, 
				nr_seq_analise_p, cd_estabelecimento_w,	nm_usuario_p, 
				null);
 
	CALL pls_analise_status_pgto(nr_seq_conta_p,	nr_seq_conta_mat_w, nr_seq_conta_proc_w, 
				nr_seq_analise_p, cd_estabelecimento_w,	nm_usuario_p, 
				null, null, null, 
				null);
				 
	CALL pls_atualizar_proc_desmembrado(nr_seq_conta_proc_w, nr_seq_analise_p, 'N', cd_estabelecimento_w, nm_usuario_p);
	end;
end loop;
close C01;
 
select	coalesce(sum(qt_liberado),0) 
into STRICT	qt_liberado_conta_w 
from	w_pls_resumo_conta 
where	nr_seq_conta	= nr_seq_conta_p;
 
if (qt_liberado_conta_w = 0) then 
	update	pls_conta 
	set	ie_glosa	= 'S' 
	where	nr_sequencia	= nr_seq_conta_p;
else 
	update	pls_conta 
	set	ie_glosa	= 'N' 
	where	nr_sequencia	= nr_seq_conta_p;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atual_w_resumo_conta_ptu ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_princ_p bigint, nr_seq_analise_p bigint, nm_usuario_p text) FROM PUBLIC;
