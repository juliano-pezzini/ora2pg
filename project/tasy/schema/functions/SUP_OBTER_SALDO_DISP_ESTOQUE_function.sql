-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_saldo_disp_estoque ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE

 
 
/* Fabio 23/04/2010 
É uma cópia da obter_saldo_disp_estoque.... 
Esta é necessária nos casos em que não deve obter o material de estoque para buscar os saldos. 
Acontece nos casos de obter saldos antigos e o cliente mudou o controlador 
*/
 
 
 
 
qt_saldo_w			double precision;
qt_estoque_w			double precision	:= 0;
qt_cirurgia_w			double precision	:= 0;
qt_esp_cirurgia_w			double precision	:= 0;
qt_emergencia_w			double precision	:= 0;
qt_agenda_cirurgia_w		double precision	:= 0;
qt_emprestimo_w			double precision	:= 0;
qt_quimioterapia_w			double precision	:= 0;
qt_requisicao_w			double precision	:= 0;
qt_req_transf_estab_w		double precision	:= 0;
qt_kit_w				double precision	:= 0;
qt_kit_ww			double precision	:= 0;
cd_material_w			integer;
ie_tipo_local_w			varchar(5);
qt_conv_estoque_w		double precision;
cd_local_estoque_w		integer;
dt_mesano_referencia_w		timestamp;
ie_disp_quimioterapia_w		varchar(1);
ie_disp_req_trans_w		varchar(1);
ie_disp_prescr_eme_w		varchar(1);
ie_disp_ag_cirur_w			varchar(1);
ie_baixa_disp_w			varchar(1);
ie_disp_comp_kit_estoque_w		varchar(1);
ie_disp_reg_kit_estoque_w		varchar(1);
ie_disp_emprestimo_lib_w		varchar(1);
ie_disp_nf_emprestimo_w		varchar(1);
ie_disp_esp_cirurgia_w		varchar(1);
ie_disp_cirurgia_w			varchar(1);
ie_disp_req_trans_estab_w	varchar(1);

c01 CURSOR FOR 
	SELECT	distinct cd_local_estoque 
	from	saldo_estoque 
	where	cd_estabelecimento		= cd_estabelecimento_p 
	and	dt_mesano_referencia	>= dt_mesano_referencia_w 
	and	cd_local_estoque		= cd_local_estoque_p 
	and	cd_material		= cd_material_w 
	and	coalesce(cd_local_estoque_p,0) > 0 
	
union
 
	SELECT	distinct cd_local_estoque 
	from	saldo_estoque 
	where	cd_estabelecimento		= cd_estabelecimento_p 
	and	dt_mesano_referencia	>= dt_mesano_referencia_w 
	and	cd_material		= cd_material_w 
	and	coalesce(cd_local_estoque_p,0) = 0;


BEGIN 
 
select	max(dt_mesano_vigente), 
	coalesce(max(ie_disp_quimioterapia),'N'), 
	coalesce(max(ie_disp_req_trans), 'N'), 
	coalesce(max(ie_disp_prescr_eme), 'S'), 
	coalesce(max(ie_disp_ag_cirur), 'N'), 
	coalesce(max(ie_disp_comp_kit_estoque), 'N'), 
	coalesce(max(ie_disp_reg_kit_estoque), 'N'), 
	coalesce(max(ie_disp_emprestimo_lib), 'N'), 
	coalesce(max(ie_disp_nf_emprestimo), 'N'), 
	coalesce(max(ie_disp_esp_cirurgia),'N'), 
	coalesce(max(ie_disp_cirurgia),'S'), 
	coalesce(max(ie_disp_req_trans_estab),'N') 
into STRICT	dt_mesano_referencia_w, 
	ie_disp_quimioterapia_w, 
	ie_disp_req_trans_w, 
	ie_disp_prescr_eme_w, 
	ie_disp_ag_cirur_w, 
	ie_disp_comp_kit_estoque_w, 
	ie_disp_reg_kit_estoque_w, 
	ie_disp_emprestimo_lib_w, 
	ie_disp_nf_emprestimo_w, 
	ie_disp_esp_cirurgia_w, 
	ie_disp_cirurgia_w, 
	ie_disp_req_trans_estab_w 
from	parametro_estoque 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
cd_material_w	:= cd_material_p;
 
select	coalesce(max(qt_conv_estoque_consumo),1) 
into STRICT	qt_conv_estoque_w 
from	material 
where	cd_material		= cd_material_w;
 
open c01;
loop 
fetch c01 into 
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	qt_emprestimo_w		:= 0;
	qt_cirurgia_w		:= 0;
 
	qt_saldo_w := obter_saldo_estoque(cd_estabelecimento_p, cd_material_w, cd_local_estoque_w, null, qt_saldo_w);
 
	select	ie_tipo_local, 
		coalesce(ie_baixa_disp, 'N') 
	into STRICT	ie_tipo_local_w, 
		ie_baixa_disp_w 
	from 	local_estoque 
	where	cd_local_estoque	= cd_local_estoque_w;
 
	if (ie_tipo_local_w = 2) or (ie_baixa_disp_w = 'S') then /*Baixa do disponível se o local for direto ou se o campo IE_DISP_ESTOQUE estiver marcada*/
 
		begin 
		if (ie_disp_cirurgia_w = 'S') then 
			/*Busca as quantidades que estão em cirurgia no local do setor da cirurgia*/
 
			select	coalesce(sum(qt_total_dispensar),0) 
			into STRICT	qt_cirurgia_w 
			from	setor_atendimento c, 
				cirurgia b, 
				material x, 
				prescr_material a, 
				prescr_medica m 
			where	a.cd_motivo_baixa		= 0 
			and	a.cd_material		= x.cd_material 
			and	x.cd_material_estoque	= cd_material_w 
			and	m.nr_prescricao		= b.nr_prescricao 
			and	m.nr_prescricao		= a.nr_prescricao 
			and	b.cd_setor_atendimento	= c.cd_setor_atendimento 
			and	c.cd_local_estoque	= cd_local_estoque_w 
			and	a.ie_status_cirurgia	in ('CB','AD') 
			and	coalesce(a.ie_baixa_estoque_cir::text, '') = '';
		elsif (ie_disp_cirurgia_w = 'C') then 
			/*Busca as quantidades que estão em cirurgia no local de consistência, se não ter local de consistência, busca do local do setor da cirurgia*/
 
			select	coalesce(sum(qt_total_dispensar),0) 
			into STRICT	qt_cirurgia_w 
			from	setor_atendimento c, 
				cirurgia b, 
				material x, 
				prescr_material a, 
				prescr_medica m 
			where	a.cd_motivo_baixa		= 0 
			and	a.cd_material		= x.cd_material 
			and	x.cd_material_estoque	= cd_material_w 
			and	m.nr_prescricao		= b.nr_prescricao 
			and	m.nr_prescricao		= a.nr_prescricao 
			and	b.cd_setor_atendimento	= c.cd_setor_atendimento 
			and	coalesce(a.cd_local_estoque, c.cd_local_estoque) = cd_local_estoque_w 
			and	a.ie_status_cirurgia	in ('CB','AD') 
			and	coalesce(a.ie_baixa_estoque_cir::text, '') = '';
		else 
			qt_cirurgia_w := 0;
		end if;
		 
		if (ie_disp_esp_cirurgia_w = 'S') then 
			SELECT	/*+ index (d PRESMAT_I3)*/ 
				coalesce(SUM(qt_total_dispensar),0) 
			into STRICT	qt_esp_cirurgia_w 
			FROM	setor_atendimento a, 
				cirurgia b, 
				prescr_medica c, 
				prescr_material d, 
				material e 
			WHERE	b.nr_cirurgia		= c.nr_cirurgia 
			AND	c.nr_prescricao		= d.nr_prescricao 
			AND	a.cd_setor_atendimento	= b.cd_setor_atendimento 
			AND	d.cd_material		= e.cd_material		 
			AND	a.cd_local_estoque	= cd_local_estoque_w 
			AND	e.cd_material_estoque	= cd_material_w 
			AND	d.cd_motivo_baixa	= 0 
			AND	d.ie_status_cirurgia	IN ('CB','AD') 
			AND	coalesce(d.ie_baixa_estoque_cir::text, '') = '';
		end if;		
 
		/*Busca as quantidades que estão prescrição de emergência*/
 
		if (ie_disp_prescr_eme_w = 'S') then 
			select	coalesce(sum(qt_total_dispensar),0) 
			into STRICT	qt_emergencia_w 
			from	setor_atendimento c, 
				material x, 
				prescr_medica b, 
				prescr_material a 
			where	a.cd_motivo_baixa = 0 
			and	a.nr_prescricao		= b.nr_prescricao 
			and	b.ie_emergencia		= 'S' 
			and	a.cd_material      	= x.cd_material 
			and	x.cd_material_estoque  	= cd_material_w 
			and	b.cd_setor_atendimento 	= c.cd_setor_atendimento 
			and	c.cd_local_estoque   	= cd_local_estoque_w 
			and	a.ie_status_cirurgia		= 'PE';
		end if;
 
 
		/*Busca as quantidades que estão consistidos pela gestão da agenda cirurgica, e ainda não tenham cirurgia vinculada*/
 
		if (ie_disp_ag_cirur_w = 'S') then 
			select	coalesce(sum(qt_total_dispensar),0) 
			into STRICT	qt_agenda_cirurgia_w 
			from	setor_atendimento c, 
				material x, 
				prescr_medica b, 
				prescr_material a 
			where	a.cd_motivo_baixa		= 0 
			and	a.cd_material		= x.cd_material 
			and	x.cd_material_estoque	= cd_material_w 
			and	a.nr_prescricao		= b.nr_prescricao 
			and	b.cd_setor_atendimento	= c.cd_setor_atendimento 
			and	c.cd_local_estoque		= cd_local_estoque_w 
			and	a.ie_status_cirurgia		= 'CB' 
			and	(b.nr_seq_agenda IS NOT NULL AND b.nr_seq_agenda::text <> '') 
			and	coalesce(b.nr_cirurgia::text, '') = '' 
			and not exists ( 
				SELECT	1 
				from	cirurgia c 
				where	c.nr_prescricao = a.nr_prescricao);
		end if;
 
		 
		qt_cirurgia_w	:= dividir((coalesce(qt_cirurgia_w,0) + coalesce(qt_emergencia_w,0) + coalesce(qt_agenda_cirurgia_w, 0)) , coalesce(qt_conv_estoque_w,1));
		end;
	end if;
 
	if (ie_disp_nf_emprestimo_w = 'N') then 
		 
		select	/*+ index(b empmate_i1) index (c emprest_pk) */ 
			coalesce(sum(CASE WHEN c.ie_tipo='S' THEN  qt_material * -1  ELSE qt_material END ),0) 
		into STRICT	qt_emprestimo_w 
		from	emprestimo c, 
			emprestimo_material b			 
		where	c.cd_local_estoque		= cd_local_estoque_w 
		and	b.nr_emprestimo		= c.nr_emprestimo 
		and	b.qt_material		> 0 
		and	coalesce(b.ie_atualiza_estoque,'X') <> 'S' 
		and	exists ( 
			SELECT 1 from material a 
			where	a.cd_material_estoque	= cd_material_w 
			and	a.cd_material 		= b.cd_material);
	else 
		select	/*+ index(b empmate_i1) index (c emprest_pk) */ 
			coalesce(sum(CASE WHEN c.ie_tipo='S' THEN (qt_material - coalesce(b.qt_nota_fiscal,0)) * -1  ELSE (qt_material - coalesce(b.qt_nota_fiscal,0)) END ),0) 
		into STRICT	qt_emprestimo_w 
		from	emprestimo c, 
			emprestimo_material b			 
		where	c.cd_local_estoque		= cd_local_estoque_w 
		and	b.nr_emprestimo		= c.nr_emprestimo 
		and	b.qt_material		> 0 
		and	coalesce(b.ie_atualiza_estoque,'X') <> 'S' 
		and	exists ( 
			SELECT 1 from material a 
			where	a.cd_material_estoque	= cd_material_w 
			and	a.cd_material 		= b.cd_material);
	end if;
 
	if (ie_disp_emprestimo_lib_w	= 'S') then 
		begin 
		if (ie_disp_nf_emprestimo_w = 'N') then 
			select	/*+ index(b empmate_i1) index (c emprest_pk) */ 
				coalesce(sum(CASE WHEN c.ie_tipo='S' THEN  qt_material * -1  ELSE qt_material END ),0) 
			into STRICT	qt_emprestimo_w 
			from	emprestimo c, 
				emprestimo_material b			 
			where	c.cd_local_estoque		= cd_local_estoque_w 
			and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '') 
			and	b.nr_emprestimo		= c.nr_emprestimo 
			and	b.qt_material		> 0 
			and	coalesce(b.ie_atualiza_estoque,'X') <> 'S' 
			and	exists ( 
				SELECT 1 from material a 
				where	a.cd_material_estoque	= cd_material_w 
				and	a.cd_material 		= b.cd_material);
		else 
			select	/*+ index(b empmate_i1) index (c emprest_pk) */ 
				coalesce(sum(CASE WHEN c.ie_tipo='S' THEN (qt_material - coalesce(b.qt_nota_fiscal,0)) * -1  ELSE (qt_material - coalesce(b.qt_nota_fiscal,0)) END ),0) 
			into STRICT	qt_emprestimo_w 
			from	emprestimo c, 
				emprestimo_material b			 
			where	c.cd_local_estoque		= cd_local_estoque_w 
			and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '') 
			and	b.nr_emprestimo		= c.nr_emprestimo 
			and	b.qt_material		> 0 
			and	coalesce(b.ie_atualiza_estoque,'X') <> 'S' 
			and	exists ( 
				SELECT 1 from material a 
				where	a.cd_material_estoque	= cd_material_w 
				and	a.cd_material 		= b.cd_material);
		end if;
		end;
	end if;
 
	if (ie_disp_quimioterapia_w = 'S') then 
		select	coalesce(sum(a.qt_dose_real),0) 
		into STRICT	qt_quimioterapia_w 
		from	far_etapa_producao c, 
			can_ordem_prod b, 
			can_ordem_prod_mat a 
		where	a.cd_material in (	SELECT	x.cd_material 
					from	material x 
				 	where	x.cd_material_estoque = cd_material_w) 
		and	b.nr_sequencia = a.nr_seq_ordem 
		and	(b.dt_fim_preparo IS NOT NULL AND b.dt_fim_preparo::text <> '') 
		and	coalesce(b.dt_entrega_setor::text, '') = '' 
		and	coalesce(b.dt_devolucao::text, '') = '' 
		and	b.ie_cancelada <> 'S' 
		and	c.nr_sequencia = b.nr_seq_etapa_prod 
		and	c.nr_seq_cabine in ( 
			SELECT	x.nr_sequencia 
			from	far_cabine_seg_biol x 
			where	x.cd_local_estoque = cd_local_estoque_w);
		qt_quimioterapia_w	:= dividir(coalesce(qt_quimioterapia_w,0) , coalesce(qt_conv_estoque_w,1));
	end if;
 
	if (ie_disp_req_trans_w = 'S') then 
		select	sum(coalesce(a.qt_estoque, 0)) - sum(coalesce(a.qt_material_atendida, 0)) qt_material 
		into STRICT	qt_requisicao_w 
		from	operacao_estoque o, 
			requisicao_material b, 
			item_requisicao_material a 
		where	a.nr_requisicao		= b.nr_requisicao 
		and	b.cd_operacao_estoque	= o.cd_operacao_estoque 
		and	b.cd_estabelecimento	= cd_estabelecimento_p 
		and	b.cd_local_estoque		= cd_local_estoque_w 
		and	o.ie_tipo_requisicao		= '2' 
		and	obter_tipo_motivo_baixa_req(a.cd_motivo_baixa)		= 0 
		and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') 
		and	a.cd_material in ( 
			SELECT	x.cd_material 
			from	material x 
			where	x.cd_material_estoque = cd_material_w);
	end if;
	 
	if (ie_disp_req_trans_estab_w = 'S') then 
		select	coalesce(sum(obter_quantidade_convertida(b.cd_material, coalesce(c.qt_prevista_entrega,0) - coalesce(c.qt_real_entrega,0), b.cd_unidade_medida_compra,'UME')),0) 
		into STRICT	qt_req_transf_estab_w 
		from	ordem_compra a, 
			ordem_compra_item b, 
			ordem_compra_item_entrega c 
		where	a.nr_ordem_compra = b.nr_ordem_compra 
		and	a.nr_ordem_compra = c.nr_ordem_compra 
		and	b.nr_item_oci = c.nr_item_oci 
		and	coalesce(c.dt_cancelamento::text, '') = '' 
		and	coalesce(b.dt_reprovacao::text, '') = '' 
		and	(b.dt_aprovacao IS NOT NULL AND b.dt_aprovacao::text <> '') 
		and	coalesce(a.dt_baixa::text, '') = '' 
		and	coalesce(a.nr_seq_motivo_cancel::text, '') = '' 
		and	a.ie_tipo_ordem = 'T' 
		and (coalesce(c.qt_prevista_entrega,0) - coalesce(c.qt_real_entrega,0)) > 0 
		and	a.cd_local_transf = cd_local_estoque_w 
		and	exists (SELECT	1 
				from	material x 
				where	x.cd_material_estoque = cd_material_w 
				and	x.cd_material = b.cd_material);
	end if;
 
	if (ie_disp_comp_kit_estoque_w = 'S') then 
 
		select	coalesce(sum(a.qt_material), 0) 
		into STRICT	qt_kit_w 
		from	kit_estoque b, 
			kit_estoque_comp a 
		where	a.nr_seq_kit_estoque	= b.nr_sequencia 
		and	b.cd_local_estoque		= cd_local_estoque_w 
		and	b.cd_estabelecimento	= cd_estabelecimento_p 
		and	coalesce(b.dt_utilizacao::text, '') = '' 
		and	a.cd_material in ( 
			SELECT	x.cd_material 
			from	material x 
			where	x.cd_material_estoque = cd_material_w);
 
	end if;
 
 
	if (ie_disp_reg_kit_estoque_w = 'S') then 
 
		select	coalesce(sum(a.qt_material), 0) 
		into STRICT	qt_kit_ww 
		from	kit_estoque_reg c, 
			kit_estoque b, 
			kit_estoque_comp a 
		where	c.nr_sequencia		= b.nr_seq_reg_kit 
		and	c.ie_situacao		<> 'I' 
		and	a.nr_seq_kit_estoque	= b.nr_sequencia 
		and	b.cd_local_estoque		= cd_local_estoque_w 
		and	b.cd_estabelecimento	= cd_estabelecimento_p 
		and	a.ie_gerado_barras	in ('S','A') 
		and	coalesce(a.nr_seq_motivo_exclusao::text, '') = '' 
		and	coalesce(b.dt_utilizacao::text, '') = '' 
		and	a.cd_material in ( 
			SELECT	x.cd_material 
			from	material x 
			where	x.cd_material_estoque = cd_material_w);
 
	end if;
 
	if (trunc(dt_mesano_referencia_p,'mm') = trunc(clock_timestamp(),'mm')) or (trunc(dt_mesano_referencia_p,'mm')	< clock_timestamp() - interval '2000 days') then 
		qt_estoque_w	:=	qt_estoque_w + 
					coalesce(qt_saldo_w, 0) + 
					coalesce(qt_emprestimo_w, 0) - 
					coalesce(qt_cirurgia_w, 0) - 
					coalesce(qt_quimioterapia_w, 0) - 
					coalesce(qt_kit_w, 0) - 
					coalesce(qt_kit_ww, 0) - 
					coalesce(qt_requisicao_w, 0) - 
					coalesce(qt_req_transf_estab_w, 0);
	else 
		qt_estoque_w	:=	coalesce(qt_saldo_w,0);
	end if;
	end;
end loop;
close c01;
 
return qt_estoque_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_saldo_disp_estoque ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) FROM PUBLIC;

