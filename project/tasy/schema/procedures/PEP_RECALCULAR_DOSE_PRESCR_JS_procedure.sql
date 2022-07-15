-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_recalcular_dose_prescr_js ( ie_tipo_perc_p bigint, qt_percentual_p bigint, nr_seq_atendimento_p bigint, nr_seq_material_p bigint ) AS $body$
BEGIN

if (ie_tipo_perc_p IS NOT NULL AND ie_tipo_perc_p::text <> '') then
	begin

	if (ie_tipo_perc_p = 1) then
		begin

		update    paciente_atend_medic
		set       	qt_dose_prescricao = (qt_dose_prescricao + ((qt_percentual_p * coalesce(qt_dose_prescricao,0)) / 100)),
			ie_tipo_percentual = ie_tipo_perc_p
		where	nr_seq_atendimento = nr_seq_atendimento_p
		and	nr_seq_material    = nr_seq_material_p;
		end;
	elsif (ie_tipo_perc_p = 2) then
		begin

		update   	paciente_atend_medic
		set	qt_dose_prescricao = (qt_dose_prescricao - ((qt_percentual_p * coalesce(qt_dose_prescricao,0)) / 100)),
			ie_tipo_percentual = ie_tipo_perc_p
		where     	nr_seq_atendimento = nr_seq_atendimento_p
		and      	nr_seq_material    = nr_seq_material_p;

		end;
	end if;
	end;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_recalcular_dose_prescr_js ( ie_tipo_perc_p bigint, qt_percentual_p bigint, nr_seq_atendimento_p bigint, nr_seq_material_p bigint ) FROM PUBLIC;

