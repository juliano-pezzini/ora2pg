-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_item_prescr_duplic ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cont_w			bigint;
nr_sequencia_w		bigint;
cd_material_w		bigint;
cd_intervalo_w		varchar(10);
qt_dose_w		double precision;
cd_unidade_medida_dose_w	varchar(30);
ie_via_aplicacao_w		varchar(10);
ie_agrupador_w		bigint;

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w	double precision;
ie_lado_w		varchar(10);
nr_seq_prot_glic_w	bigint;

cd_dieta_w		bigint;
qt_parametro_w		double precision;

ds_solucao_w		varchar(255);
ds_componentes_w	varchar(2000);
ie_bomba_infusao_w	varchar(10);
nr_etapas_w		bigint;
qt_hora_fase_w		double precision;
qt_tempo_aplicacao_w	double precision;
nr_seq_dialise_w	bigint;
hr_prim_horario_w	varchar(10);
ie_tipo_dosagem_w	varchar(10);
qt_dosagem_w		double precision;
nr_seq_proc_interno_w	bigint;
cd_recomendacao_w		bigint;
IE_TIPO_SOLUCAO_W		varchar(15);
ds_medic_nao_padrao_w 	varchar(255);

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	coalesce(cd_intervalo,'XPTO'),
	qt_dose,
	cd_unidade_medida_dose,
	coalesce(ie_via_aplicacao,'XPTO'),
	ie_agrupador,
	coalesce(ds_medic_nao_padrao, '')
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
and	coalesce(nr_sequencia_solucao::text, '') = ''
and	coalesce(nr_sequencia_proc::text, '') = ''
and	coalesce(nr_seq_kit::text, '') = ''
and	ie_agrupador not in (3,7,9)
order by cd_material;

c02 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	coalesce(nr_seq_proc_interno,0),
	nr_sequencia,
	qt_procedimento,
	coalesce(cd_intervalo,'XPTO'),
	coalesce(ie_lado,'XPTO'),
	coalesce(nr_seq_prot_glic,0)
from	prescr_procedimento
where	nr_prescricao		= nr_prescricao_p
order by dt_prev_execucao desc;

c03 CURSOR FOR
SELECT	cd_dieta,
	nr_sequencia,
	coalesce(cd_intervalo,'XPTO'),
	coalesce(qt_parametro,0)
from	prescr_dieta
where	nr_prescricao		= nr_prescricao_p;

c04 CURSOR FOR
SELECT	coalesce(ds_solucao,'X'),
	nr_seq_solucao,
	coalesce(ie_bomba_infusao,'X'),
	coalesce(nr_etapas,0),
	coalesce(qt_hora_fase,0),
	coalesce(qt_tempo_aplicacao,0),
	coalesce(hr_prim_horario,'X'),
	ie_tipo_dosagem,
	ie_via_aplicacao,
	coalesce(qt_dosagem,0),
	substr(obter_componentes_sol(nr_prescricao, nr_seq_solucao, 'N', nm_usuario, 1),1,2000),
	coalesce(IE_TIPO_SOLUCAO,'XPTO')
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p;

c05 CURSOR FOR
SELECT	cd_recomendacao,
	nr_sequencia,
	coalesce(hr_prim_horario,'00:00'),
	coalesce(cd_intervalo,'XPTO')
from	prescr_recomendacao
where	nr_prescricao	= nr_prescricao_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	cd_material_w,
	cd_intervalo_w,
	qt_dose_w,
	cd_unidade_medida_dose_w,
	ie_via_aplicacao_w,
	ie_agrupador_w,
	ds_medic_nao_padrao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	count(*)
	into STRICT	cont_w
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		<> nr_sequencia_w
	and	cd_material		= cd_material_w
	and	qt_dose			= qt_dose_w
	and	cd_unidade_medida_dose	= cd_unidade_medida_dose_w
	and	ie_agrupador		= ie_agrupador_w
	and	coalesce(cd_intervalo, cd_intervalo_w)	 = cd_intervalo_w
	and	coalesce(ie_via_aplicacao,ie_via_aplicacao_w) = ie_via_aplicacao_w
	and coalesce(ds_medic_nao_padrao, 'XPTO') = coalesce(ds_medic_nao_padrao_w, 'XPTO');

	if (cont_w	> 0) then
		delete from prescr_material
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_sequencia_w;
	end if;

end loop;
close C01;

CALL reordenar_medicamento(nr_prescricao_p);

cont_w	:= 0;

open C02;
loop
fetch C02 into
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_seq_proc_interno_w,
	nr_sequencia_w,
	qt_procedimento_w,
	cd_intervalo_w,
	ie_lado_w,
	nr_seq_prot_glic_w;
EXIT WHEN NOT FOUND; /* apply on C02 */



	select	count(*)
	into STRICT	cont_w
	from	prescr_procedimento
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		<> nr_sequencia_w
	and	cd_procedimento		= cd_procedimento_w
	and	qt_procedimento		= qt_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w
	and	coalesce(nr_seq_proc_interno, nr_seq_proc_interno_w) = nr_seq_proc_interno_w
	and	coalesce(cd_intervalo, cd_intervalo_w) = cd_intervalo_w
	and	coalesce(ie_lado, ie_lado_w)	= ie_lado_w
	and	coalesce(nr_seq_prot_glic,0) = nr_seq_prot_glic_w;

	if (cont_w	> 0) then
		delete from prescr_procedimento
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_sequencia_w;
	end if;
end loop;
close C02;

CALL reordenar_procedimento(nr_prescricao_p);

open C03;
loop
fetch C03 into
	cd_dieta_w,
	nr_sequencia_w,
	cd_intervalo_w,
	qt_parametro_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	select	count(*)
	into STRICT	cont_w
	from	prescr_dieta
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		<> nr_sequencia_w
	and	cd_dieta		= cd_dieta_w
	and	coalesce(qt_parametro,0)	= qt_parametro_w
	and	coalesce(cd_intervalo, cd_intervalo_w) = cd_intervalo_w;

	if (cont_w	> 0) then
		delete from prescr_dieta
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_sequencia_w;
	end if;
end loop;
close C03;

open C04;
loop
fetch C04 into
	ds_solucao_w,
	nr_sequencia_w,
	ie_bomba_infusao_w,
	nr_etapas_w,
	qt_hora_fase_w,
	qt_tempo_aplicacao_w,
	hr_prim_horario_w,
	ie_tipo_dosagem_w,
	ie_via_aplicacao_w,
	qt_dosagem_w,
	ds_componentes_w,
	IE_TIPO_SOLUCAO_w;
EXIT WHEN NOT FOUND; /* apply on C04 */

	select	count(*)
	into STRICT	cont_w
	from	prescr_solucao
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_solucao		<> nr_sequencia_w
	and	coalesce(ds_solucao, ds_solucao_w)			= ds_solucao_w
	and	coalesce(ie_bomba_infusao, ie_bomba_infusao_w) 	= ie_bomba_infusao_w
	and	coalesce(nr_etapas, nr_etapas_w)			= nr_etapas_w
	and	coalesce(qt_hora_fase, qt_hora_fase_w) 		= qt_hora_fase_w
	and	coalesce(qt_tempo_aplicacao, qt_tempo_aplicacao_w)	= qt_tempo_aplicacao_w
	and	coalesce(hr_prim_horario, hr_prim_horario_w)		= hr_prim_horario_w
	and	coalesce(ie_tipo_dosagem, ie_tipo_dosagem_w)		= ie_tipo_dosagem_w
	and	coalesce(ie_via_aplicacao, ie_via_aplicacao_w)	= ie_via_aplicacao_w
	and	coalesce(qt_dosagem, qt_dosagem_w)			= qt_dosagem_w
	and	coalesce(IE_TIPO_SOLUCAO, IE_TIPO_SOLUCAO_w) = IE_TIPO_SOLUCAO_w
	and	coalesce(substr(obter_componentes_sol(nr_prescricao, nr_seq_solucao, 'N', nm_usuario, 1),1,2000), ds_componentes_w)	= ds_componentes_w;

	if (cont_w	> 0) then
		delete from prescr_solucao
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_sequencia_w;
	end if;
end loop;
close C04;

CALL reordenar_solucoes(nr_prescricao_p);

open C05;
loop
fetch C05 into
	cd_recomendacao_w,
	nr_sequencia_w,
	hr_prim_horario_w,
	cd_intervalo_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	cont_w	:= 0;
	select	count(*)
	into STRICT	cont_w
	from	prescr_recomendacao
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia		<> nr_sequencia_w
	and	cd_recomendacao		= cd_recomendacao_w
	and	coalesce(hr_prim_horario, hr_prim_horario_w)	= hr_prim_horario_w
	and	coalesce(cd_intervalo, cd_intervalo_w)	= cd_intervalo_w;

	if (cont_w	> 0) then
		delete from prescr_recomendacao
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_sequencia_w;
	end if;
end loop;
close C05;


CALL reordenar_recomendacao(nr_prescricao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_item_prescr_duplic ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
