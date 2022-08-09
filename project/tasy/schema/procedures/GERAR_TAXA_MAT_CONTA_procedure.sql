-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_taxa_mat_conta ( nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text, ie_gerar_estornar_p text, ie_cig_ccg_p text) AS $body$
DECLARE


cd_proc_adic_w			bigint;
ie_orig_proced_adic_w		bigint;
qt_proc_adic_w			double precision;
nr_seq_exame_w			bigint;
nr_seq_material_w		bigint;
ds_observacao_w			varchar(255);
cd_setor_atendimento_w		integer;
cd_setor_prescr_w		integer;
nr_agrup_acum_w			bigint;
nr_seq_acum_w			bigint;
cd_estabelecimento_w		bigint;
nr_seq_proc_interno_w		bigint;
nr_atendimento_w		bigint;
ie_tipo_atendimento_w		bigint;
cont_w				bigint;
ie_agrupador_w			bigint;

dt_prescricao_w			timestamp;
cd_material_w			integer;
nr_dia_util_w			integer;
ie_via_aplicacao_w		varchar(5);
ie_considerar_dia_w		varchar(5);
cd_material_exame_w		varchar(20);
cd_intervalo_w			varchar(7);
ds_horarios_w			varchar(2000);
nr_ocorrencia_w			double precision;
cd_perfil_w			bigint;
cd_convenio_w			bigint;
ie_acm_w			varchar(1);
ie_sn_w				varchar(1);
ie_agora_w			varchar(1);
ie_tipo_item_w			varchar(1);

c01 CURSOR FOR
SELECT	cd_proc_adic,
		ie_orig_proced_adic,
		qt_proc_adic,
		nr_seq_exame,
		nr_seq_material,
		ds_observacao,
		cd_setor_atendimento,
		nr_seq_proc_interno,
		ie_considerar_dia
from		regra_material_proced a
where	coalesce(cd_material,cd_material_w)	= cd_material_w
and		((coalesce(cd_setor_prescr::text, '') = '') or (cd_setor_prescr = cd_setor_prescr_w))
and		((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = ie_tipo_atendimento_w))
and		((coalesce(nr_dia_util::text, '') = '') or (nr_dia_util >= nr_dia_util_w))
and		((coalesce(cd_estab::text, '') = '') or (cd_Estab = cd_estabelecimento_w))
and		((coalesce(cd_convenio::text, '') = '') or (cd_convenio = cd_convenio_w))
and		((coalesce(cd_perfil::text, '') = '') or (cd_perfil = cd_perfil_w))
and		(((coalesce(ie_forma,'R')	= 'A') and (ie_cig_ccg_p = 'C')) or
		 ((coalesce(ie_forma,'R')	= 'G') and (ie_cig_ccg_p = 'G')))
and		not exists (	SELECT	1
					from		regra_material_proced_exc x
					where	x.nr_seq_regra	= a.nr_sequencia
					and		x.cd_material	= cd_material_w)
and 		not exists (	select	1
					from		regra_material_proced_exc x
					where	x.nr_seq_regra	= a.nr_sequencia
					and		coalesce(x.ie_impede_lancamento,'N') = 'S'
					and		x.cd_material	in (select	y.cd_material
												 from	prescr_material y
												 where	y.nr_prescricao = nr_prescricao_p))
and		coalesce(ie_via_aplicacao,coalesce(ie_via_aplicacao_w,'X')) = coalesce(ie_via_aplicacao_w,'X')
and		((cd_perfil = cd_perfil_w) or (coalesce(cd_perfil::text, '') = ''))
and		((cd_setor_atendimento = cd_setor_prescr_w) or (coalesce(cd_setor_atendimento::text, '') = ''));


BEGIN

select	count(*)
into STRICT		cont_w
from		regra_material_proced
where	coalesce(ie_forma,'R') in ('A','G');

if (cont_w > 0) then

	select	max(dt_prescricao),
			max(cd_estabelecimento),
			max(cd_setor_atendimento),
			max(nr_atendimento),
			max(obter_convenio_atendimento(nr_atendimento))
	into STRICT		dt_prescricao_w,
			cd_estabelecimento_w,
			cd_setor_prescr_w,
			nr_atendimento_w,
			cd_convenio_w
	from		prescr_medica
	where	nr_prescricao	= nr_prescricao_p;
	
	cd_perfil_w	:= obter_perfil_ativo;
	
	select	max(ie_tipo_atendimento)
	into STRICT		ie_tipo_atendimento_w
	from		atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;

	select	coalesce(max(cd_material),0),
			coalesce(max(ie_via_aplicacao),'X'),
			coalesce(max(cd_intervalo),'XPTO'),
			max(ds_horarios),
			coalesce(max(nr_ocorrencia),0),
			coalesce(max(ie_acm),'N'),
			coalesce(max(ie_se_necessario),'N'),
			coalesce(max(ie_urgencia),'N'),
			coalesce(max(ie_agrupador),0),
			coalesce(max(NR_DIA_UTIL),0)
	into STRICT		cd_material_w,
			ie_via_aplicacao_w,
			cd_intervalo_w,
			ds_horarios_w,
			nr_ocorrencia_w,
			ie_acm_w,
			ie_sn_w,
			ie_agora_w,
			ie_agrupador_w,
			nr_dia_util_w
	from		prescr_material
	where	nr_prescricao	= nr_prescricao_p
	and		nr_sequencia	= nr_seq_material_p;
	
	ie_tipo_item_w	:= 'M';
	if (ie_agrupador_w = 4) then
		ie_tipo_item_w	:= 'S';
	end if;

	open C01;
	loop
	fetch C01 into	
		cd_proc_adic_w,
		ie_orig_proced_adic_w,
		qt_proc_adic_w,
		nr_seq_exame_w,
		nr_seq_material_w,
		ds_observacao_w,
		cd_setor_atendimento_w,
		nr_seq_proc_interno_w,
		ie_considerar_dia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
		select	max(cd_material_exame)
		into STRICT		cd_material_exame_w
		from		material_exame_lab
		where	nr_sequencia	= nr_seq_material_w;
		
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then
			SELECT * FROM Obter_Proc_Tab_Interno(nr_seq_proc_interno_w, nr_prescricao_p, nr_atendimento_w, 0, cd_proc_adic_w, ie_orig_proced_adic_w, null, null) INTO STRICT cd_proc_adic_w, ie_orig_proced_adic_w;
		end if;
		cont_w	:= 0;
		if (ie_considerar_dia_w = 'S') and (ie_gerar_estornar_p = 'G') then
			select	count(*)
			into STRICT		cont_w
			from		procedimento_paciente a,
					conta_paciente b
			where	a.nr_interno_conta	= b.nr_interno_conta
			and		b.nr_atendimento	= nr_atendimento_w
			and		a.cd_procedimento	= cd_proc_adic_w
			--and		trunc(a.dt_conta,'dd')	= trunc(sysdate,'dd')
			and		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(a.dt_conta)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp())
			and		a.ie_origem_proced	= ie_orig_proced_adic_w;
		end if;
		
		if (ie_gerar_estornar_p = 'E') then
			qt_proc_adic_w	:= qt_proc_adic_w * -1;
		end if;
		
		if (cont_w = 0) then
			CALL gerar_proc_pac_item_prescr(nr_prescricao_p, null,nr_atendimento_w,null,nr_seq_proc_interno_w, cd_proc_adic_w, ie_orig_proced_adic_w, qt_proc_adic_w, cd_setor_atendimento_w,1, clock_timestamp(), nm_usuario_p, NULL, nr_seq_exame_w, NULL,null);
		end if;
	end loop;
	close C01;

	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_taxa_mat_conta ( nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text, ie_gerar_estornar_p text, ie_cig_ccg_p text) FROM PUBLIC;
