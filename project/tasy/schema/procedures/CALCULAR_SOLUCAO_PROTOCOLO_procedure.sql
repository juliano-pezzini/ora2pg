-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_solucao_protocolo ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint) AS $body$
DECLARE


qt_ultrafiltracao_w		double precision;
cd_material_w			integer;
qt_dose_w			double precision;
qt_dose_aux_w			double precision;
cd_unidade_medida_dose_w	varchar(30);
qt_volume_w			double precision := 0;
qt_duracao_w			bigint;
qt_dosagem_w			double precision;
qt_dose_ataque_w		double precision;
ie_ultrafiltracao_w     varchar(60);

c01 CURSOR FOR
SELECT	cd_material,
	qt_dose,
	cd_unidade_medida_dose
from	prescr_material
where	nr_prescricao 		= nr_prescricao_p
and	nr_sequencia_solucao 	= nr_seq_solucao_p
and	ie_agrupador 		= 13;


BEGIN

select	max(qt_ultrafiltracao),
    	max(hsc_converte_horas_minutos(coalesce(qt_hora_sessao,0)) + coalesce(qt_min_sessao,0)),
		max(ie_ultrafiltracao)
into STRICT	qt_ultrafiltracao_w,
	    qt_duracao_w,
		ie_ultrafiltracao_w
from	hd_prescricao
where	nr_sequencia 	= nr_sequencia_p
and	nr_prescricao 	= nr_prescricao_p;

select	max(coalesce(qt_dosagem,0))
into STRICT	qt_dosagem_w
from	prescr_solucao
where	nr_seq_solucao 		=  nr_seq_solucao_p
and	nr_prescricao 		= nr_prescricao
and	nr_seq_dialise		= nr_sequencia_p;

open C01;
loop
fetch C01 into
	cd_material_w,
	qt_dose_w,
	cd_unidade_medida_dose_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin

	--Niumar - Philippe  OS 639001.
	if	(qt_ultrafiltracao_w > 0 AND ie_ultrafiltracao_w = 'TR') then
		qt_dose_aux_w := (qt_dose_w * qt_ultrafiltracao_w);
	end if;
	if (qt_dose_aux_w > 0) then
		qt_volume_w := qt_volume_w + obter_conversao_ml(cd_material_w,qt_dose_aux_w,cd_unidade_medida_dose_w);
	end if;

	exception
	when others then
		qt_volume_w	:= 0;
	end;

	end;
end loop;
close C01;

qt_dose_ataque_w := (qt_dosagem_w * qt_duracao_w) - qt_volume_w;

if (qt_dose_ataque_w < 0) then
	qt_dose_ataque_w := null;
end if;

if (coalesce(qt_volume_w,0) > 0) or (coalesce(qt_dose_ataque_w,0) > 0) then

	update	prescr_solucao
	set	qt_solucao_total 	= qt_volume_w,
		qt_dose_ataque		= qt_dose_ataque_w
	where	nr_seq_solucao		= nr_seq_solucao_p
	and	nr_prescricao 		= nr_prescricao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_solucao_protocolo ( nr_sequencia_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
