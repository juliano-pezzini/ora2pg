-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_solution_add_info ( nr_seq_mat_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


ds_guidance_w		cpoe_material.ds_ref_calculo%type;
ds_doctor_notes_w	cpoe_material.ds_observacao%type;
qt_dosagem_mim_w	cpoe_material.qt_dosagem_min%type;
qt_dosagem_max_w        cpoe_material.qt_dosagem_max%type;
qt_dosagem_inc_w        cpoe_material.qt_dosagem_inc%type;
ie_tipo_dosagem_inc_w   cpoe_material.ie_tipo_dosagem_inc%type;
qt_dose_terap_max_w	cpoe_material.qt_dose_terap_max%type;
qt_dose_terap_min_w	cpoe_material.qt_dose_terap_min%type;
cd_unid_medic_terap_w 	cpoe_material.cd_unid_medic_terap%type;
ie_tipo_dosagem_w       cpoe_material.ie_tipo_dosagem%type;

ds_return_w				varchar(2000);

function getDosageFormated( qt_valor_p in bigint ) return text is
    ds_retorno_w varchar(255);

BEGIN
    ds_retorno_w := to_char(qt_valor_p);

    if (substr(ds_retorno_w, 1, 1) in (',', '.')) then	
        ds_retorno_w := '0' || ds_retorno_w;	
    end if;

    return ds_retorno_w;
end;

begin

if (nr_seq_mat_cpoe_p IS NOT NULL AND nr_seq_mat_cpoe_p::text <> '') then

	select	ds_ref_calculo,
		ds_observacao,
		qt_dosagem_min,
		qt_dosagem_max,
		qt_dosagem_inc,
		ie_tipo_dosagem_inc,
		qt_dose_terap_min,
		qt_dose_terap_max,
		cd_unid_medic_terap,
	        ie_tipo_dosagem
	into STRICT	ds_guidance_w,
		ds_doctor_notes_w,
		qt_dosagem_mim_w,
		qt_dosagem_max_w,
		qt_dosagem_inc_w,
		ie_tipo_dosagem_inc_w,
		qt_dose_terap_min_w,
		qt_dose_terap_max_w,
		cd_unid_medic_terap_w,
	        ie_tipo_dosagem_w
	from	cpoe_material
	where	nr_sequencia = nr_seq_mat_cpoe_p;

	if (qt_dosagem_mim_w IS NOT NULL AND qt_dosagem_mim_w::text <> '') then
		ds_return_w := obter_desc_expressao(794865) || ': ' || getDosageFormated(qt_dosagem_mim_w) || ' ' || obter_valor_dominio(93, ie_tipo_dosagem_w) || chr(13) || chr(10);
	end if;
	if (qt_dosagem_max_w IS NOT NULL AND qt_dosagem_max_w::text <> '') then
		ds_return_w := ds_return_w || obter_desc_expressao(794867) || ': ' || getDosageFormated(qt_dosagem_max_w) || ' ' || obter_valor_dominio(93, ie_tipo_dosagem_w) ||  chr(13) || chr(10);
	end if;
	if (qt_dosagem_inc_w IS NOT NULL AND qt_dosagem_inc_w::text <> '') then
		ds_return_w := ds_return_w || obter_desc_expressao(1031490) || ': ' || getDosageFormated(qt_dosagem_inc_w) || ' ' || obter_valor_dominio(93, ie_tipo_dosagem_inc_w) || chr(13) || chr(10);
	end if;
	
	if (cd_unid_medic_terap_w IS NOT NULL AND cd_unid_medic_terap_w::text <> '') then	
		if (qt_dose_terap_min_w IS NOT NULL AND qt_dose_terap_min_w::text <> '') then
			ds_return_w := ds_return_w || obter_desc_expressao(1054503) || ': ' || getDosageFormated(qt_dose_terap_min_w) || ' ' || Obter_desc_unid_terap(cd_unid_medic_terap_w) || chr(13) || chr(10);
		end if;
		if (qt_dose_terap_max_w IS NOT NULL AND qt_dose_terap_max_w::text <> '') then
			ds_return_w := ds_return_w || obter_desc_expressao(1054505) || ': ' || getDosageFormated(qt_dose_terap_max_w) || ' ' || Obter_desc_unid_terap(cd_unid_medic_terap_w) ||  chr(13) || chr(10);
		end if;
	end if;

	ds_return_w := substr(ds_return_w || ds_guidance_w || chr(13) || chr(10), 0, 2000);

end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_solution_add_info ( nr_seq_mat_cpoe_p bigint) FROM PUBLIC;
