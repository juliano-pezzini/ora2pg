-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_days_hours_by_classif ( nr_atendimento_p bigint, cd_classification_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*
Get patient total days stayed in the deparment by classification

4 - ICU

*/
			
 dt_entry_w				timestamp;
 dt_exit_w				timestamp;
 qt_days_icu_w			bigint := 0;
 qt_days_icu_final_w	bigint := 0;	
 qt_hours_icu_final_w	bigint := 0;
 qt_hours_icu_w			bigint := 0;	
 ie_has_values_w		smallint;

 qt_retorno bigint :=0;		
			
			
	C01 CURSOR FOR
	SELECT	trunc(dt_entrada_unidade),
			trunc(coalesce(dt_saida_unidade, clock_timestamp())),
			trunc(dt_saida_unidade - dt_entrada_unidade),
			trunc(mod((dt_saida_unidade - dt_entrada_unidade)*24,24))
	from	atend_paciente_unidade
	where	nr_atendimento = nr_atendimento_p
	and		obter_classif_setor(cd_setor_atendimento) = cd_classification_p
	order by 1;
			
			

BEGIN

	open C01;
	loop
	fetch C01 into	
			dt_entry_w,
			dt_exit_w,
			qt_days_icu_w,
			qt_hours_icu_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	
		begin

			qt_days_icu_final_w := qt_days_icu_final_w + qt_days_icu_w;
			qt_hours_icu_final_w := qt_hours_icu_final_w + qt_hours_icu_w;
			
			ie_has_values_w	:= 1;
		end;
	end loop;
	close C01;



	if	(ie_has_values_w = 1 AND qt_hours_icu_final_w >=24) then
		qt_days_icu_final_w := qt_days_icu_final_w + floor(qt_hours_icu_final_w/24);
		qt_hours_icu_final_w := trunc(mod(qt_hours_icu_final_w,24));
	end if;
	if ( ie_opcao_p = 'D') then
		qt_retorno:= qt_days_icu_final_w;
	elsif ( ie_opcao_p = 'H') then
		qt_retorno := qt_hours_icu_final_w;
	else
		qt_retorno := 0;
	end if;

return qt_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_days_hours_by_classif ( nr_atendimento_p bigint, cd_classification_p bigint, ie_opcao_p text) FROM PUBLIC;
