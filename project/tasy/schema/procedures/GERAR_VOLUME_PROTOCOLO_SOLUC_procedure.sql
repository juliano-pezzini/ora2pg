-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_volume_protocolo_soluc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_volume_medic_w	bigint;
qt_etapas_w		bigint;
qt_volume_total_w	bigint;
ie_tipo_dosagem_w	varchar(15);
qt_tempo_aplicacao_w	double precision;
qt_dosagem_w		double precision;
ie_bomba_infusao_w	varchar(15);

BEGIN

select  sum(coalesce(obter_dose_convertida(cd_material,qt_dose_prescr,cd_unid_med_prescr,obter_unid_med_usua('ml')),0))
into STRICT	qt_volume_medic_w
from	paciente_protocolo_medic
where	nr_seq_paciente = nr_seq_paciente_p
and	nr_seq_solucao = nr_seq_solucao_p;

select 	max(nr_etapas),
	max(ie_tipo_dosagem),
	max(qt_tempo_aplicacao),
	max(ie_bomba_infusao)
into STRICT 	qt_etapas_w,
	ie_tipo_dosagem_w,
	qt_tempo_aplicacao_w,
	ie_bomba_infusao_w
from	paciente_protocolo_soluc
where	nr_seq_solucao = nr_seq_solucao_p
and	nr_seq_paciente = nr_seq_paciente_p;

qt_volume_total_w := qt_volume_medic_w * qt_etapas_w;

qt_dosagem_w := Calcular_Volume_Total_Solucao(upper(ie_tipo_dosagem_w), qt_tempo_aplicacao_w, qt_volume_total_w, null, null, null, 1, qt_dosagem_w, 'N');

update 	paciente_protocolo_soluc
set 	qt_solucao_total = qt_volume_total_w,
	qt_dosagem	 = qt_dosagem_w
where	nr_seq_paciente	 = nr_seq_paciente_p
and	nr_seq_solucao   = nr_seq_solucao_p;


if (ie_bomba_infusao_w = 'B') then
	CALL Calcular_sol_Bom_elast_qt(nr_seq_paciente_p ,
				nr_seq_solucao_p,
				nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_volume_protocolo_soluc ( nr_seq_paciente_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) FROM PUBLIC;

