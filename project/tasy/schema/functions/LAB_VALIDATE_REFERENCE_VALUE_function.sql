-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_validate_reference_value ( nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ie_sexo_p text, dt_nascimento_p timestamp, ie_valor_percent_p text, qt_result_p bigint, ds_result_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_casas_decimais_dias_w	smallint;
ie_tipo_valor_w				exame_lab_padrao.ie_tipo_valor%type;
qt_dias_w					double precision;
qt_horas_w					bigint;


BEGIN
	ie_tipo_valor_w := 0;

    select	CASE WHEN coalesce(max(ie_idade_int_val_ref), 'N')='N' THEN  2  ELSE 0 END
	into STRICT 	qt_casas_decimais_dias_w
	from	lab_parametro
	where	cd_estabelecimento = cd_estabelecimento_p;

	select 	obter_dias_entre_datas_lab(dt_nascimento_p, clock_timestamp()),
			Obter_Hora_Entre_datas(dt_nascimento_p, clock_timestamp())
	into STRICT 	qt_dias_w,
			qt_horas_w
	;

    if upper(ie_valor_percent_p) in ('P','V','D') then
        begin
           select	a.ie_tipo_valor
            into STRICT	ie_tipo_valor_w   
            from
                (SELECT	ie_tipo_valor
                from	exame_lab_padrao
                where	((ie_sexo = coalesce(ie_sexo_p,'0')) or (ie_sexo = '0'))
                and		nr_seq_exame = nr_seq_exame_p
                and		coalesce(nr_seq_material,nr_seq_material_p) = nr_seq_material_p
                and		(((coalesce((trunc((qt_dias_w / 365.25),qt_casas_decimais_dias_w)),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'A')) or
                        ((coalesce(trunc(((qt_dias_w / 365.25) * 12), qt_casas_decimais_dias_w),0) between qt_idade_min and qt_idade_max) and (ie_periodo = 'M')) or
                        (((coalesce(qt_dias_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'D')) or
                        (((coalesce(qt_horas_w,0)) between qt_idade_min and qt_idade_max) and (ie_periodo = 'H')))
                        
                and	((ie_valor_percent_p = 'V' AND qt_result_p between qt_minima and qt_maxima) or
                      (ie_valor_percent_p = 'P' AND qt_result_p between qt_percent_min and qt_percent_max) or
                      ((ie_valor_percent_p = 'D') and (upper(ELIMINA_ACENTOS(ds_result_p)) like upper(ELIMINA_ACENTOS(DS_OBSERVACAO)))) )
                
                and		coalesce(ie_situacao,'A') = 'A'
                order 	by nr_seq_material, ie_sexo, ie_tipo_valor) a LIMIT 1;
        exception
            when no_data_found then
                ie_tipo_valor_w := 0;
        end;
    end if;
    
    return ie_tipo_valor_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_validate_reference_value ( nr_prescricao_p bigint, nr_seq_exame_p bigint, nr_seq_material_p bigint, ie_sexo_p text, dt_nascimento_p timestamp, ie_valor_percent_p text, qt_result_p bigint, ds_result_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
