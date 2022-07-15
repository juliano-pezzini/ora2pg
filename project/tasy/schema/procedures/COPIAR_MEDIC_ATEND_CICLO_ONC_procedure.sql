-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_medic_atend_ciclo_onc ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atendimento_w		bigint;
nr_seq_paciente_w			bigint;
nr_seq_material_w			bigint;
nr_seq_material_diluido_w		bigint;
cd_material_diluido_w		bigint;
nr_agrupamento_w			bigint;
nr_atendimento_w			bigint;
nr_ciclo_w			smallint;
cd_estab_usuario_w		smallint;
ie_consid_todos_dias_agrup_w	varchar(3)	:= 'N';

c01 CURSOR FOR
	SELECT	*
	from	paciente_atend_medic
	where	nr_seq_atendimento	= nr_seq_atendimento_p
	and	nr_seq_material		= nr_seq_material_p;
c01_w	c01%rowtype;

c02 CURSOR FOR
	SELECT	nr_seq_atendimento,
		null nr_seq_material_diluido
	from	paciente_atendimento
	where	coalesce(cd_material_diluido_w::text, '') = ''
	and	nr_seq_paciente		= nr_seq_paciente_w
	and	nr_seq_atendimento	<> nr_seq_atendimento_p
	and	coalesce(nr_prescricao::text, '') = ''
	
union all

	SELECT	a.nr_seq_atendimento,
		m.nr_seq_material nr_seq_material_diluido
	from	paciente_atendimento a,
		paciente_atend_medic m
	where	(cd_material_diluido_w IS NOT NULL AND cd_material_diluido_w::text <> '')
	and	m.nr_seq_atendimento	= a.nr_seq_atendimento
	and	m.cd_material		= cd_material_diluido_w
	and	a.nr_seq_paciente		= nr_seq_paciente_w
	and	a.nr_seq_atendimento	<> nr_seq_atendimento_p
	and	coalesce(m.nr_seq_diluicao::text, '') = ''
	and	coalesce(a.nr_prescricao::text, '') = '';
	
c03 CURSOR FOR
	SELECT	nr_ciclo
	from	paciente_atendimento
	where	nr_seq_paciente = nr_seq_paciente_w;


BEGIN

cd_estab_usuario_w	:= wheb_usuario_pck.get_cd_estabelecimento;

ie_consid_todos_dias_agrup_w := obter_param_usuario(281, 1208, obter_perfil_ativo, nm_usuario_p, cd_estab_usuario_w, ie_consid_todos_dias_agrup_w);

select	nr_seq_paciente,
	nr_atendimento
into STRICT	nr_seq_paciente_w,
	nr_atendimento_w
from	paciente_atendimento
where	nr_seq_atendimento	= nr_seq_atendimento_p;

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	RAISE NOTICE 'Inicio';

	cd_material_diluido_w := null;
	if (c01_w.nr_seq_diluicao IS NOT NULL AND c01_w.nr_seq_diluicao::text <> '') then
		select	cd_material
		into STRICT	cd_material_diluido_w
		from	paciente_atend_medic
		where	nr_seq_atendimento	= nr_seq_atendimento_p
		and	nr_seq_material		= c01_w.nr_seq_diluicao;
	end if;

	open c02;
	loop
	fetch c02 into
		nr_seq_atendimento_w,
		nr_seq_material_diluido_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		RAISE NOTICE 'C02 Inicio';

		nr_agrupamento_w	:= c01_w.nr_agrupamento;
		if (ie_consid_todos_dias_agrup_w = 'N') and (coalesce(c01_w.nr_seq_diluicao::text, '') = '') then
			select	coalesce(max(nr_agrupamento),0) + 1
			into STRICT	nr_agrupamento_w
			from	paciente_atend_medic
			where	nr_seq_atendimento = nr_seq_atendimento_w
			and	coalesce(nr_seq_diluicao::text, '') = '';
		end if;

		select	coalesce(max(nr_seq_material),0)	+ 1
		into STRICT	nr_seq_material_w
		from	paciente_atend_medic
		where	nr_seq_atendimento	= nr_seq_atendimento_w;

		insert into paciente_atend_medic(
			nr_seq_atendimento, 		nr_seq_material, 			cd_material,
			dt_atualizacao, 			nm_usuario, 			nr_agrupamento,
			qt_dose, 				cd_unid_med_dose, 		qt_dose_prescricao,
			cd_unid_med_prescr, 		ds_recomendacao, 			ie_via_aplicacao,
			nr_seq_diluicao, 			qt_min_aplicacao, 			ie_bomba_infusao,
			cd_intervalo, 			qt_hora_aplicacao, 			qt_dias_util,
			nr_seq_interno, 			nr_seq_prot_medic, 		ie_cancelada,
			dt_cancelamento, 			nm_usuario_cancel, 		ie_administracao,
			ie_checado, 			ds_observacao, 			ie_se_necessario,
			ie_urgencia, 			ie_aplic_bolus, 			ie_aplic_lenta,
			qt_auc, 				ds_tempo_infusao, 			nr_seq_via_acesso,
			ie_item_superior, 			nr_seq_int_prot_medic,	IE_USO_CONTINUO,
			ie_pre_medicacao,		ie_local_adm,			ie_aplica_reducao,
			ie_acm,					ie_medicacao_paciente)
		values (nr_seq_atendimento_w,		nr_seq_material_w, 			c01_w.cd_material,
			clock_timestamp(),				nm_usuario_p,			nr_agrupamento_w,
			c01_w.qt_dose, 			c01_w.cd_unid_med_dose, 		c01_w.qt_dose_prescricao,
			c01_w.cd_unid_med_prescr, 		c01_w.ds_recomendacao, 		c01_w.ie_via_aplicacao,
			nr_seq_material_diluido_w, 		c01_w.qt_min_aplicacao, 		c01_w.ie_bomba_infusao,
			c01_w.cd_intervalo, 		c01_w.qt_hora_aplicacao, 		c01_w.qt_dias_util,
			nextval('paciente_atend_medic_seq'),	c01_w.nr_seq_prot_medic, 		c01_w.ie_cancelada,
			c01_w.dt_cancelamento, 		c01_w.nm_usuario_cancel, 		c01_w.ie_administracao,
			c01_w.ie_checado, 		c01_w.ds_observacao, 		c01_w.ie_se_necessario,
			c01_w.ie_urgencia, 		c01_w.ie_aplic_bolus, 		c01_w.ie_aplic_lenta,
			c01_w.qt_auc, 			c01_w.ds_tempo_infusao, 		c01_w.nr_seq_via_acesso,
			c01_w.ie_item_superior, 		c01_w.nr_seq_int_prot_medic, c01_w.IE_USO_CONTINUO,
			c01_w.IE_PRE_MEDICACAO,		c01_w.IE_LOCAL_ADM,			c01_w.IE_APLICA_REDUCAO,
			c01_w.IE_ACM,			coalesce(c01_w.ie_medicacao_paciente,'N'));
		RAISE NOTICE 'C02 Fim';
		end;
	end loop;
	close c02;
	RAISE NOTICE 'C01 Fim';
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_medic_atend_ciclo_onc ( nr_seq_atendimento_p bigint, nr_seq_material_p bigint, nm_usuario_p text) FROM PUBLIC;

