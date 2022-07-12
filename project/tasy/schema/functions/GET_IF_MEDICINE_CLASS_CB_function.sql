-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_medicine_class_cb ( nr_seq_intern_p bigint, cd_class_medicine_p text) RETURNS varchar AS $body$
DECLARE


nr_encounter_w			atendimento_paciente.nr_atendimento%type;
dt_entry_encounter_w	atendimento_paciente.dt_entrada%type;
cd_setor_atend_w		setor_atendimento.cd_setor_atendimento%type;
qt_count_w				bigint;


BEGIN

if (nr_seq_intern_p IS NOT NULL AND nr_seq_intern_p::text <> '') and (cd_class_medicine_p IS NOT NULL AND cd_class_medicine_p::text <> '') then

	select 	max(nr_atendimento)
	into STRICT	nr_encounter_w
	from	w_pan_paciente
	where	nr_seq_interno = nr_seq_intern_p;

	if (nr_encounter_w IS NOT NULL AND nr_encounter_w::text <> '') then

		select	count(*)
		into STRICT	qt_count_w
		from	adep_pend_prev_v
		where	nr_atendimento	= nr_encounter_w
		and 	obter_classe_material(cd_item) in (WITH RECURSIVE cte AS (
SELECT regexp_substr(cd_class_medicine_p,'[^,]+', 1, level)  (regexp_substr(cd_class_medicine_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(cd_class_medicine_p, '[^,]+', 1, level))::text <> '')  UNION ALL
SELECT regexp_substr(cd_class_medicine_p,'[^,]+', 1, level) JOIN cte c ON ()

) SELECT * FROM cte;
)
		and 	dt_horario between clock_timestamp() - interval '2 days' and clock_timestamp() + interval '3 days'
		and		ie_tipo_item in ('M', 'MAT');

	end if;

	if (qt_count_w > 0) then
		return 'S';
	else
		return 'N';
	end if;

end if;

return 'N';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_medicine_class_cb ( nr_seq_intern_p bigint, cd_class_medicine_p text) FROM PUBLIC;
