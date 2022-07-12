-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_dose_extra_disp as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_dose_extra_disp ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_unidade_medida_dose_p text, cd_material_p text, qt_dose_p bigint) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_dose_extra_disp_atx ( ' || quote_nullable(nr_sequencia_p) || ',' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(cd_unidade_medida_dose_p) || ',' || quote_nullable(cd_material_p) || ',' || quote_nullable(qt_dose_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_dose_extra_disp_atx ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_unidade_medida_dose_p text, cd_material_p text, qt_dose_p bigint) RETURNS bigint AS $body$
DECLARE
	
	
	qt_total_w			double precision;
	qt_dose_ml_w		double precision;
	ie_fator_correcao_w	varchar(3);
	qt_dose_aux_w		double precision;
	qt_dose_extra_w 	double precision;
	qt_volume_equipo_w	double precision;
BEGIN	

--Descricao do calculo pode ser consultado na pasta "Description" do dicionario de dados.
	select	max(a.ie_fator_correcao),
		max(Obter_vol_Dispositivo_solucao(a.ie_bomba_infusao))
	into STRICT	ie_fator_Correcao_w,
		qt_volume_equipo_w
	from	prescr_material a
	where	a.nr_prescricao	= nr_prescricao_p
	and	a.nr_sequencia	= nr_sequencia_p;

	if (ie_fator_Correcao_w = 'S') then
	
		SELECT 	coalesce(SUM(dose),0)
		INTO STRICT 	qt_total_w 
		FROM (	SELECT 	obter_conversao_ml(cd_material,qt_dose,cd_unidade_medida_dose) dose
				FROM 	prescr_material a, 
					prescr_medica x
				WHERE 	a.ie_agrupador IN (3,7,9)
				AND 	(a.cd_material IS NOT NULL AND a.cd_material::text <> '')
				AND 	a.nr_sequencia_diluicao = nr_sequencia_p
				AND	x.nr_prescricao = a.nr_prescricao
				AND 	x.nr_prescricao = nr_prescricao_p
				
UNION ALL
 
				SELECT  obter_conversao_ml(cd_material,qt_dose,cd_unidade_medida_dose) dose
				FROM 	prescr_material
				WHERE 	nr_prescricao = nr_prescricao_p
				AND 	nr_sequencia = nr_sequencia_p) alias7;

		qt_dose_ml_w := obter_conversao_ml(cd_material_p,qt_dose_p,cd_unidade_medida_dose_p);
		
	end if;
			
	if (coalesce(ie_fator_Correcao_w,'N') = 'S') and (coalesce(qt_volume_equipo_w,0) > 0)  then					
		qt_dose_aux_w		:= dividir((qt_dose_ml_w * 100), qt_total_w);	
		qt_dose_ml_w		:= dividir((qt_dose_aux_w * qt_volume_equipo_w), 100);	
		qt_dose_extra_w  	:= obter_dose_convertida(cd_material_p, ceil(qt_dose_ml_w),lower(obter_unid_med_usua('ml')),cd_unidade_medida_dose_p);
	else
		qt_dose_extra_w  := 0;
	end if;
	
return	qt_dose_extra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_extra_disp ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_unidade_medida_dose_p text, cd_material_p text, qt_dose_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_dose_extra_disp_atx ( nr_sequencia_p bigint, nr_prescricao_p bigint, cd_unidade_medida_dose_p text, cd_material_p text, qt_dose_p bigint) FROM PUBLIC;
