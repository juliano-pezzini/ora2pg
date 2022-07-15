-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_produto_adic_hd ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ds_lista_produto_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
lista_informacao_w			varchar(800);
ie_contador_w			bigint	:= 0;
tam_lista_w			bigint;
ie_pos_virgula_w			smallint;
nr_seq_elem_mat_w		bigint;
nr_sequencia_w			bigint;
cd_unidade_medida_consumo_w	varchar(30);
cd_material_w			integer;
qt_volume_w			double precision;
nr_seq_elemento_w			bigint;
ie_prim_fase_w			varchar(1)	:= 'S';
ie_seg_fase_w			varchar(1)	:= 'S';
ie_terc_fase_w			varchar(1)	:= 'S';
qt_fase_npt_w			bigint;
nr_erro_w			bigint;
cd_unidade_medida_w		varchar(30);

qt_dose_w			double precision;
ie_via_aplicacao_w			varchar(5);
cd_intervalo_w			varchar(7) := '1x';

 
cd_estabelecimento_w		smallint;
dt_prescricao_w			timestamp;
dt_primeiro_horario_w		timestamp;
nr_horas_validade_w		integer;
cd_setor_atendimento_w		integer;

 
cd_unidade_consumo_w		varchar(30);
ds_horarios_w			varchar(2000);
ds_horarios_ww			varchar(2000);
nr_agrupamento_w			double precision;
nr_intervalo_w			bigint;
qt_conversao_dose_w		double precision;
qt_unitaria_w			double precision;
qt_produto_w			double precision;
qt_total_dispensar_w		double precision;
ds_erro_w			varchar(255);
hr_prim_horario_w			varchar(5);

nr_seq_material_w			integer;
qt_solucao_w			double precision;

ie_regra_disp_w			varchar(1);/* Rafael em 15/3/8 OS86206 */
 
 
c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.cd_unidade_medida 
from	nut_elem_material b, 
	nut_elemento a 
where	a.nr_sequencia	= b.nr_seq_elemento 
and	a.ie_situacao	= 'A' 
and	b.ie_situacao	= 'A' 
and	a.ie_hemodialise= 'S' 
and	b.cd_material	= cd_material_w 
and	(a.cd_unidade_medida IS NOT NULL AND a.cd_unidade_medida::text <> '') 
and	coalesce(b.ie_tipo,'NPT') = 'NPT' 
and not exists (	SELECT	1 
			from	hd_prescr_sol_elem c 
			where	c.nr_seq_elemento 	= a.nr_sequencia 
			and	nr_seq_solucao		= nr_seq_solucao_p);


BEGIN 
 
lista_informacao_w	:= ds_lista_produto_p;
 
/* gerar produto */
 
select	coalesce(max(nr_sequencia),0), 
	coalesce(max(nr_agrupamento),0)					 
into STRICT	nr_seq_material_w, 
	nr_agrupamento_w 
from	prescr_material 
where	nr_prescricao = nr_prescricao_p;
 
while	(lista_informacao_w IS NOT NULL AND lista_informacao_w::text <> '') or 
	ie_contador_w > 200 loop 
	begin 
	tam_lista_w		:= length(lista_informacao_w);
	ie_pos_virgula_w	:= position(',' in lista_informacao_w);
 
	if (ie_pos_virgula_w <> 0) then 
		nr_seq_elem_mat_w	:= (substr(lista_informacao_w,1,(ie_pos_virgula_w - 1)))::numeric;
		lista_informacao_w	:= substr(lista_informacao_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;
 
	select	b.cd_unidade_medida_consumo, 
		a.cd_material 
	into STRICT	cd_unidade_medida_consumo_w, 
		cd_material_w 
	from	material b, 
		nut_elem_material a 
	where	a.cd_material	= b.cd_material 
	and	a.nr_sequencia	= nr_seq_elem_mat_w 
	and	coalesce(a.ie_tipo,'NPT') = 'NPT';
 
	select	obter_conversao_ml(cd_material_w,1,cd_unidade_medida_consumo_w) 
	into STRICT	qt_volume_w 
	;
 
	cd_unidade_medida_w	:= obter_unid_med_usua('ml');
	qt_dose_w		:= qt_volume_w;
 
 
	/* obter dados prescricao */
 
	select	cd_estabelecimento, 
		dt_prescricao, 
		dt_primeiro_horario, 
		nr_horas_validade, 
		cd_setor_atendimento 
	into STRICT	cd_estabelecimento_w, 
		dt_prescricao_w, 
		dt_primeiro_horario_w, 
		nr_horas_validade_w, 
		cd_setor_atendimento_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
	 
	/* obter unidade consumo material */
 
	select	cd_unidade_medida_consumo 
	into STRICT	cd_unidade_consumo_w 
	from	material 
	where	cd_material = cd_material_w;
 
	/* obter conversao dose */
 
	select	obter_conversao_unid_med(cd_material_w, cd_unidade_medida_w) 
	into STRICT	qt_conversao_dose_w 
	;
 
	/* obter quantidade consumo */
 
	select	obter_conversao_unid_med_cons(cd_material_w, cd_unidade_medida_w, qt_dose_w) 
	into STRICT	qt_unitaria_w 
	;
 
	/* obter quantidade dispensar */
 
	SELECT * FROM obter_quant_dispensar(cd_estabelecimento_w, cd_material_w, nr_prescricao_p, 0, cd_intervalo_w, ie_via_aplicacao_w, qt_unitaria_w, 0, 1, null, null, cd_unidade_medida_w, null, qt_produto_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, 'N', 'N') INTO STRICT qt_produto_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;
	 
	/* atualizar agrupamento */
 
	nr_agrupamento_w 	:= nr_agrupamento_w + 1;
	nr_seq_material_w	:= nr_seq_material_w + 1;
 
 
	/* inserir produto */
 
	insert into prescr_material( 
			nr_prescricao, 
			nr_sequencia, 
			nr_sequencia_solucao, 
			ie_origem_inf, 
			cd_material, 
			cd_unidade_medida, 
			qt_dose, 
			qt_unitaria, 
			qt_material, 
			qt_solucao, 
			dt_atualizacao, 
			nm_usuario, 
			cd_intervalo, 
			nr_agrupamento, 
			cd_motivo_baixa, 
			ie_utiliza_kit, 
			cd_unidade_medida_dose, 
			qt_conversao_dose, 
			ie_urgencia, 
			nr_ocorrencia, 
			qt_total_dispensar, 
			ie_medicacao_paciente, 
			ie_agrupador, 
			ie_suspenso, 
			ie_se_necessario, 
			ie_bomba_infusao, 
			ie_aplic_bolus, 
			ie_aplic_lenta, 
			ie_acm, 
			ie_cultura_cih, 
			ie_antibiograma, 
			ie_uso_antimicrobiano, 
			ie_recons_diluente_fixo, 
			ie_sem_aprazamento, 
			ie_regra_disp) 
	values ( 
			nr_prescricao_p, 
			nr_seq_material_w, 
			nr_seq_solucao_p, 
			'N', 
			cd_material_w, 
			cd_unidade_consumo_w, 
			qt_dose_w, 
			qt_unitaria_w, 
			qt_produto_w, 
			qt_dose_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_intervalo_w, 
			nr_agrupamento_w, 
			0, 
			'N', 
			cd_unidade_medida_w, 
			qt_conversao_dose_w, 
			'N', 
			nr_intervalo_w, 
			qt_total_dispensar_w, 
			'N', 
			13, 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			'N', 
			ie_regra_disp_w);
			 
	nr_erro_w := Consistir_Prescr_Material(nr_prescricao_p, nr_seq_material_w, nm_usuario_p, obter_perfil_ativo, nr_erro_w); /*Almir em 09/10/2007 OS70754 */
 
	 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_elemento_w, 
		cd_unidade_medida_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	nextval('hd_prescr_sol_elem_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		insert into hd_prescr_sol_elem( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_prescricao, 
			nr_seq_solucao, 
			nr_seq_elemento, 
			cd_unidade_medida, 
			qt_elemento) 
		values ( 
			nr_sequencia_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_prescricao_p, 
			nr_seq_solucao_p, 
			nr_seq_elemento_w, 
			cd_unidade_medida_w, 
			0);
 
		end;
	end Loop;
	close C01;
 
	ie_contador_w	:= ie_contador_w + 1;
	end;
end loop;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_produto_adic_hd ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ds_lista_produto_p text, nm_usuario_p text) FROM PUBLIC;

