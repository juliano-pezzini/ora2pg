-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_reposicao_consig ( cd_estabelecimento_p bigint, cd_fornecedor_consignado_p text, cd_material_p bigint, qt_total_dispensar_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_atendimento_p bigint, cd_local_estoque_p bigint, ds_observacao_p text, cd_local_entrega_p bigint, cd_centro_custo_p bigint, pr_desconto_p bigint, nr_serie_material_p text, cd_pessoa_solicitante_p text, nr_seq_lote_fornec_p bigint, cd_setor_atendimento_p bigint, nr_seq_matpaci_p bigint, qt_compra_p bigint, cd_unidade_medida_compra_p text, cd_comprador_padrao_p text) AS $body$
DECLARE


nr_item_oci_w				integer;
cd_comprador_padrao_w			varchar(10);
cd_moeda_padrao_w			bigint;
cd_condicao_pagamento_padrao_w  	bigint;
cd_pessoa_solic_padrao_w        	varchar(10);
qt_dia_prazo_entrega_w			bigint;
cd_estabelecimento_w        		smallint    	:= 1;
cd_pessoa_fisica_w  	    		varchar(10) 	:= '';
nr_ordem_compra_w			bigint;
ds_observacao_w				varchar(2000)	:= '';
dt_prevista_entrega_w			timestamp;
nm_paciente_w				pessoa_fisica.nm_pessoa_fisica%type;
nm_medico_w				varchar(60)	:= '';
cd_convenio_w				integer;
ds_convenio_w				varchar(255)	:= '';
cd_categoria_w				varchar(10);
nr_atendimento_w			bigint	:= '';
cd_local_estoque_w			integer	:= '';
cd_local_entrega_w			integer	:= '';
cd_usuario_convenio_w			varchar(30);
nr_doc_convenio_w			varchar(20);
cd_centro_custo_w			integer	:= '';
dt_cirurgia_w				timestamp;
vl_unitario_material_w			double precision	:= 0;
nr_cirurgia_w				bigint;
dt_entrega_w				timestamp;
ie_aprova_auto_w			varchar(01);
cd_senha_w				varchar(20);
ie_tipo_conta_w				integer;
cd_conta_contabil_w			varchar(20);
nr_crm_w				varchar(20);
dt_validade_carteira_w			timestamp;
nm_pessoa_contato_w			varchar(255);
tx_desc_ordem_w				double precision;
pr_desc_financeiro_w			double precision;
cd_procedimento_w			bigint;
ie_agrupa_oc_novo_item_w		varchar(1);
nr_item_oci_ww				integer;
nr_seq_entrega_w			bigint;
ie_atualizou_item_w			varchar(1) := 'N';
qt_existe_w				bigint;
nr_seq_marca_w				bigint;
ie_erro_email_w				varchar(1);
ie_avisa_consumo_w			varchar(1);
nr_seq_bras_preco_w			bigint;
nr_seq_mat_bras_w			bigint;
nr_seq_conv_bras_w			bigint;
nr_seq_marca_consig_w			bigint;
nr_seq_grupo_w				bigint;
cd_comprador_grupo_w			varchar(10);
dt_validade_w				timestamp;
pr_desc_financ_w			double precision;
ie_replicar_desc_financ_item_w		varchar(15);
ds_setor_w				setor_atendimento.ds_setor_atendimento%type;
ie_tipo_atendimento_w			smallint;
ie_preco_sus_oc_w			varchar(1);
nr_seq_agenda_w				agenda_paciente.nr_sequencia%type;
ie_obs_nm_consig_w		parametro_compras.ie_obs_nm_consig%type;
			


BEGIN
cd_estabelecimento_w	:= coalesce(cd_estabelecimento_p,1);


select	coalesce(cd_comprador_consig, cd_comprador_padrao),
      	cd_moeda_padrao,
      	cd_condicao_pagamento_padrao,
      	coalesce(cd_pessoa_solic_consig,cd_pessoa_solic_padrao),
	ie_aprova_ordem_consig,
	coalesce(cd_local_entrega_consig, cd_local_entrega_p),
	coalesce(ie_agrupa_oc_novo_item,'N'),
	to_date(clock_timestamp() + coalesce(qt_dias_entrega_oc_consig,0)),
	coalesce(ie_preco_sus_oc,'N')
into STRICT  	cd_comprador_padrao_w,
      	cd_moeda_padrao_w,
      	cd_condicao_pagamento_padrao_w,
      	cd_pessoa_solic_padrao_w,
	ie_aprova_auto_w,
	cd_local_entrega_w,
	ie_agrupa_oc_novo_item_w,
	dt_prevista_entrega_w,
	ie_preco_sus_oc_w
from  	parametro_compras
where 	cd_estabelecimento = cd_estabelecimento_w;

if (ie_preco_sus_oc_w = 'S') and (nr_atendimento_p > 0) then

	select	Obter_Dados_Atendimento(nr_atendimento_p, 'TC')
	into STRICT	ie_tipo_atendimento_w
	;
end if;


if (cd_centro_custo_p > 0) then
	cd_centro_custo_w  := cd_centro_custo_p;
end if;

if (coalesce(cd_pessoa_solic_padrao_w::text, '') = '') or (coalesce(cd_moeda_padrao_w::text, '') = '') or (coalesce(cd_comprador_padrao_w::text, '') = '') then
	--(-20011,'Os parametros de compra estao incompletos');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(195748);
end if;

select	coalesce(obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_fornecedor_consignado_p, 'EPE'),0),
	coalesce(obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_fornecedor_consignado_p, 'ECP'), cd_condicao_pagamento_padrao_w)
into STRICT	qt_dia_prazo_entrega_w,
	cd_condicao_pagamento_padrao_w
;

dt_entrega_w	:= trunc(clock_timestamp(),'dd') + qt_dia_prazo_entrega_w;

select	coalesce(obter_ordem_atend_consignado(cd_estabelecimento_p, cd_fornecedor_consignado_p, cd_local_entrega_w, 0, nr_atendimento_p, nr_prescricao_p,'W'),0)
into STRICT	nr_ordem_compra_w
;

if (nr_ordem_compra_w = 0) then
        begin
		
		select	coalesce(max(ie_obs_nm_consig), 'N')
		into STRICT	ie_obs_nm_consig_w
		from	parametro_compras
		where	cd_estabelecimento 	=	cd_estabelecimento_p;
		
	if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
		begin
		
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	cirurgia
		where	nr_prescricao		= nr_prescricao_p;

		if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
			update	prescr_medica
			set	cd_pessoa_fisica	=	cd_pessoa_fisica_w
			where	nr_prescricao		=	nr_prescricao_p
			and	coalesce(cd_pessoa_fisica::text, '') = '';
		end if;
		
		select 	max(SUBSTR(OBTER_NOME_PF(m.CD_PESSOA_FISICA), 0, 40)),
			OBTER_SE_INICIAIS_PACIENTE(max(SUBSTR(OBTER_NOME_PF(p.CD_PESSOA_FISICA), 0, 40)), ie_obs_nm_consig_w),
			max(a.nr_atendimento),
			max(a.nr_cirurgia)
		into STRICT	nm_medico_w,
			nm_paciente_w,
			nr_atendimento_w,
			nr_cirurgia_w
		from 	pessoa_fisica m,
			Pessoa_fisica p,
			prescr_medica a
		where 	a.nr_prescricao 	= nr_prescricao_p
		  and	a.cd_pessoa_fisica	= p.cd_pessoa_fisica
		  and	a.cd_medico		= m.cd_pessoa_fisica;
		
		/* Marcus 07/01/2005 - Tratamento da cirurgia pela tabela cirurgia ou prescricao */

		if (coalesce(nr_cirurgia_w::text, '') = '') then
			select	max(nr_cirurgia),
				max(cd_pessoa_fisica)
			into STRICT	nr_cirurgia_w,
				cd_pessoa_fisica_w
			from	cirurgia
			where	nr_prescricao		= nr_prescricao_p;
		end if;
		
		select	coalesce(max(a.nr_sequencia),0)
		into STRICT	nr_seq_agenda_w
		from	agenda_paciente a,
			cirurgia b
		where	a.nr_cirurgia	= b.nr_cirurgia
		and	b.nr_prescricao	= nr_prescricao_p;

		if (nr_seq_agenda_w = 0) then
			select	coalesce(max(a.nr_sequencia),0)
			into STRICT	nr_seq_agenda_w
			from	agenda_paciente a,
				cirurgia b
			where	a.nr_cirurgia	= b.nr_cirurgia
			and	b.nr_cirurgia	= nr_cirurgia_w;
		end if;

		/* Ricardo 07/04/2004 - Incluido o numero do atendimento na observacao abaixo a pedido do Wander Os 7185 */

		if (ie_obs_nm_consig_w = 'S') then
			ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(301950,'NM_PACIENTE_W='||nm_paciente_w||';NR_ATENDIMENTO_W='||nr_atendimento_w||';NM_MEDICO_W='||nm_medico_w),1,4000);
		else
			ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(1203966,'NR_ATENDIMENTO_W='||nr_atendimento_w||';NM_MEDICO_W='||nm_medico_w),1,4000);
		end if;

		if (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') then
			select	max(trunc(coalesce(a.dt_inicio_real, a.dt_inicio_prevista), 'dd'))
			into STRICT	dt_cirurgia_w
			from	cirurgia a
			where	a.nr_cirurgia		= nr_cirurgia_w;
			ds_observacao_w	:= wheb_mensagem_pck.get_texto(301952,'DS_OBSERVACAO_W='||ds_observacao_w||';DT_CIRURGIA_W='|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_cirurgia_w, 'shortDate', cd_estabelecimento_p,	nm_usuario_p));
		end if;

		if (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') then
			select	max(cd_procedimento_princ)
			into STRICT	cd_procedimento_w
			from	cirurgia a
			where	a.nr_cirurgia		= nr_cirurgia_w;
			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
				ds_observacao_w	:= wheb_mensagem_pck.get_texto(301953,'DS_OBSERVACAO_W='||ds_observacao_w||';CD_PROCEDIMENTO_W='||  to_char(cd_procedimento_w));
			end if;
		end if;

		end;

	else
		begin
		select 	b.nr_atendimento,
		OBTER_SE_INICIAIS_PACIENTE(max(SUBSTR(OBTER_NOME_PF(p.CD_PESSOA_FISICA), 0, 40)), ie_obs_nm_consig_w)
		into STRICT	nr_atendimento_w,
				nm_paciente_w
		from 	Pessoa_fisica p,
			Atendimento_Paciente b
		where b.cd_pessoa_fisica	= p.cd_pessoa_fisica
		  and	b.nr_atendimento	= nr_atendimento_p;
		
		if (ie_obs_nm_consig_w = 'S') then
			ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(301950,'NM_PACIENTE_W='||nm_paciente_w||';NR_ATENDIMENTO_W='||nr_atendimento_w||';NM_MEDICO_W='||nm_medico_w),1,4000);
		else
			ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(1203966,'NR_ATENDIMENTO_W='||nr_atendimento_w||';NM_MEDICO_W='||nm_medico_w),1,4000);
		end if;
		
		exception
		when no_data_found or too_many_rows then
			ds_observacao_w	:= null;
 		end;
	end if;
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
		begin
		select	substr(ds_convenio, 1,40),
			cd_convenio,
			substr(cd_usuario_convenio, 1,30),
			nr_doc_convenio,
			cd_categoria,
			cd_senha,
			nm_medico,
			nr_crm,
			dt_validade_carteira
		into STRICT	ds_convenio_w,
			cd_convenio_w,
			cd_usuario_convenio_w,
			nr_doc_convenio_w,
			cd_categoria_w,
			cd_senha_w,
			nm_medico_w,
			nr_crm_w,
			dt_validade_carteira_w
		from	atendimento_paciente_v
		where	nr_atendimento	= nr_atendimento_w;
		ds_observacao_w := wheb_mensagem_pck.get_texto(301967,'DS_OBSERVACAO_W='||ds_observacao_w||';DS_CONVENIO_W='||ds_convenio_w||';CD_USUARIO_CONVENIO_W='||cd_usuario_convenio_w||';DT_VALIDADE_CARTEIRA_W='||dt_validade_carteira_w||';NR_DOC_CONVENIO_W='||nr_doc_convenio_w||';CD_SENHA_W='||cd_senha_w||';NM_MEDICO_W='||nm_medico_w||';NR_CRM_W='||nr_crm_w); /*Fabio 16/08/2004 - Inclui o medico */
		end;
	end if;
	select	nextval('ordem_compra_seq')
	into STRICT	nr_ordem_compra_w
	;

	--nr_ordem_compra_gerada_p	:= nr_ordem_compra_w;
	if (cd_setor_atendimento_p > 0) then
		select	obter_nome_setor(cd_setor_atendimento_p)
		into STRICT	ds_setor_w
		;
	end if;

	ds_observacao_w	:= substr(wheb_mensagem_pck.get_texto(301980,'DS_OBSERVACAO_W='||ds_observacao_w||';DT_ATUALIZACAO_P='||PKG_DATE_FORMATERS.TO_VARCHAR(dt_atualizacao_p, 'timestamp', cd_estabelecimento_p,	nm_usuario_p)||';DS_SETOR_W='||ds_setor_w),1,2000);

	select	substr(obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_fornecedor_consignado_p, 'ENC'),1,255),
		obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_fornecedor_consignado_p, 'TDO'),
		obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_fornecedor_consignado_p, 'TDF')
	into STRICT	nm_pessoa_contato_w,
		tx_desc_ordem_w,
		pr_desc_financeiro_w
	;	
	
	insert into ordem_compra(
		nr_ordem_compra,
		cd_estabelecimento,
		cd_cgc_fornecedor,
		cd_condicao_pagamento,
		cd_comprador,
		dt_ordem_compra,
		dt_atualizacao,
		nm_usuario,
		cd_moeda,
		ie_situacao,
		dt_inclusao,
		cd_pessoa_solicitante,
		cd_cgc_transportador,
		ie_frete,
		vl_frete,
		pr_multa_atraso,
		pr_desc_pgto_antec,
		pr_juros_negociado,
		dt_emissao,
		ds_observacao,
		cd_motivo_alteracao,
		cd_local_entrega,
		dt_entrega,
		nr_prescricao,
		dt_aprovacao,
		dt_baixa,
		ie_aviso_chegada,
		ie_emite_obs,
		ie_urgente,
		nr_atendimento,
		ie_somente_pagto,
		cd_convenio,
		ie_tipo_ordem,
		nr_cirurgia,
		ds_pessoa_contato,
		pr_desconto,
		pr_desc_financeiro,
		cd_centro_custo)
	values (	nr_ordem_compra_w,
		cd_estabelecimento_w,
		cd_fornecedor_consignado_p,
		cd_condicao_pagamento_padrao_w,
		cd_comprador_padrao_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		cd_moeda_padrao_w,
		'A',
		clock_timestamp(),
		coalesce(cd_pessoa_solicitante_p,cd_pessoa_solic_padrao_w),
		null,
		'C',
		0,
		null,
		0,
		0,
		null,
		ds_observacao_w,
		null,
		coalesce(cd_local_entrega_w, cd_local_estoque_w),
		dt_entrega_w,
		nr_prescricao_p,
		null,
		null,
		'N',
		'S',
		'N',
		nr_atendimento_w,
		'N',
		cd_convenio_w,
		'W',
		nr_cirurgia_w,
		nm_pessoa_contato_w,
		tx_desc_ordem_w,
		pr_desc_financeiro_w,
		cd_centro_custo_w);
	
	end;
end if;

begin
select	coalesce(max(nr_item_oci) + 1,1)
into STRICT	nr_item_oci_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_w;
exception
	when others then
		nr_item_oci_w 	:= 1;
end;

ie_tipo_conta_w		:= 3;
if (coalesce(cd_centro_custo_w::text, '') = '') then
	ie_tipo_conta_w	:= 2;
end if;	
	
SELECT * FROM define_conta_material(cd_estabelecimento_w, cd_material_p, ie_tipo_conta_w, null, null, null, null, null, null, null, cd_local_estoque_w, Null, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;


ie_atualizou_item_w := 'N';

if (ie_agrupa_oc_novo_item_w = 'S') then
	begin
	select	coalesce(max(nr_item_oci),0)
	into STRICT	nr_item_oci_ww
	from	ordem_compra_item
	where	nr_ordem_compra = nr_ordem_compra_w
	and	cd_material = cd_material_p;
	
	if (nr_item_oci_ww > 0) then
		begin
		update	ordem_compra_item
		set	qt_material = (qt_material + qt_compra_p),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			vl_total_item = round(( (qt_material + qt_compra_p) * vl_unitario_material),4)
		where	nr_ordem_compra = nr_ordem_compra_w
		and	nr_item_oci = nr_item_oci_ww;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_entrega_w
		from	ordem_compra_item_entrega
		where	nr_ordem_compra = nr_ordem_compra_w
		and	nr_item_oci = nr_item_oci_ww;
		
		update	ordem_compra_item_entrega
		set	qt_prevista_entrega = (qt_prevista_entrega + qt_compra_p),
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_ordem_compra = nr_ordem_compra_w
		and	nr_item_oci = nr_item_oci_ww
		and	nr_sequencia = nr_seq_entrega_w;
		
		ie_atualizou_item_w	:= 'S';
		end;
	end if;
	end;
end if;

select	obter_regra_oc_opme(cd_estabelecimento_w, cd_fornecedor_consignado_p, cd_convenio_w, cd_material_p)			
into STRICT	pr_desc_financ_w
;

if (pr_desc_financ_w < 0) then
	pr_desc_financ_w := 0;
end if;

select	obter_valor_param_usuario(917, 130, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)
into STRICT	ie_replicar_desc_financ_item_w
;

if (ie_replicar_desc_financ_item_w = 'S') then
	pr_desc_financ_w := pr_desc_financeiro_w;
end if;


if (ie_atualizou_item_w = 'N') then
	begin
	
	
	vl_unitario_material_w := obter_valor_mat_ordem_consig(	
				cd_estabelecimento_w, cd_fornecedor_consignado_p, cd_material_p, nr_ordem_compra_w, nr_prescricao_p, nr_atendimento_p, ie_tipo_atendimento_w, nr_seq_agenda_w, dt_atualizacao_p, nr_seq_lote_fornec_p, cd_convenio_w, cd_categoria_w, clock_timestamp(), vl_unitario_material_w);
	
	
	
	insert into ordem_compra_item(
		nr_ordem_compra,
		nr_item_oci,
		cd_material,
		cd_unidade_medida_compra,
		vl_unitario_material,
		qt_material,
		qt_original,
		dt_atualizacao,
		nm_usuario,
		ie_situacao,
		cd_pessoa_solicitante,
		qt_material_entregue,
		pr_descontos,
		cd_local_estoque,
		ds_material_direto,
		ds_observacao,
		cd_motivo_alteracao,
		nr_cot_compra,
		nr_item_cot_compra,
		cd_centro_custo,
		cd_conta_contabil,
		nr_serie_material,
		nr_seq_lote_fornec,
		nr_seq_prescr_item,
		nr_atendimento,
		ds_lote,
		dt_validade,
		nr_seq_marca,
		pr_desc_financ,
		nr_seq_matpaci,
		vl_total_item,
		cd_sequencia_parametro)
	values ( nr_ordem_compra_w,
		nr_item_oci_w,
		cd_material_P,
		cd_unidade_medida_compra_p,
		vl_unitario_material_w,
		qt_compra_p,
		qt_compra_p,
		clock_timestamp(),
		nm_usuario_p,
		'A',
		coalesce(cd_pessoa_solicitante_p,cd_pessoa_solic_padrao_w),
		0,
		coalesce(pr_desconto_p,0),
		cd_local_estoque_p,
		null,
		null,
		null,
		null,
		null,
		cd_centro_custo_w,
		cd_conta_contabil_w,
		nr_serie_material_p,
		nr_seq_lote_fornec_p,
		nr_seq_prescricao_p,
		nr_atendimento_w,
		null,
		dt_validade_w,
		nr_seq_marca_consig_w,
		pr_desc_financ_w,
		nr_seq_matpaci_p,
		round((qt_compra_p * vl_unitario_material_w)::numeric,4),
		philips_contabil_pck.get_parametro_conta_contabil);
	
	insert into ordem_compra_item_entrega(
		nr_sequencia,
		nr_ordem_compra,
		nr_item_oci,
		dt_prevista_entrega,
		dt_real_entrega,
		dt_entrega_original,
		dt_entrega_limite,
		qt_prevista_entrega,
		qt_real_entrega,
		dt_atualizacao,
		nm_usuario,
		ds_observacao)
	values (	nextval('ordem_compra_item_entrega_seq'),
		nr_ordem_compra_w,
		nr_item_oci_w,
		dt_prevista_entrega_w,
		null,
		dt_entrega_w,
		dt_entrega_w,
		qt_compra_p,
		null,
		clock_timestamp(),
		nm_usuario_p,
		null);
	
	end;
end if;

Calcular_Liquido_Ordem_Compra(nr_ordem_compra_w, nm_usuario_p);
if (ie_aprova_auto_w = 'S') then
	begin
	select	count(*)
	into STRICT	qt_existe_w
	from	ordem_compra
	where	nr_ordem_compra	= nr_ordem_compra_w
	and	coalesce(dt_aprovacao::text, '') = '';
	/*Para verificar se a OC ja nao esta aprovada ou reprovada*/

	if (qt_existe_w > 0) then
		CALL Gerar_Aprov_Ordem_Compra(nr_ordem_compra_w, null, 'S', nm_usuario_p);
	end if;
	end;
end if;

CALL gerar_ordem_compra_venc(nr_ordem_compra_w, nm_usuario_p);		

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_reposicao_consig ( cd_estabelecimento_p bigint, cd_fornecedor_consignado_p text, cd_material_p bigint, qt_total_dispensar_p bigint, dt_atualizacao_p timestamp, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescricao_p bigint, nr_atendimento_p bigint, cd_local_estoque_p bigint, ds_observacao_p text, cd_local_entrega_p bigint, cd_centro_custo_p bigint, pr_desconto_p bigint, nr_serie_material_p text, cd_pessoa_solicitante_p text, nr_seq_lote_fornec_p bigint, cd_setor_atendimento_p bigint, nr_seq_matpaci_p bigint, qt_compra_p bigint, cd_unidade_medida_compra_p text, cd_comprador_padrao_p text) FROM PUBLIC;

