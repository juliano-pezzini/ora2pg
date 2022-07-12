-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_prob_ativo_linked ( dt_inicio_p text default null, dt_fim_p text default null) RETURNS varchar AS $body$
DECLARE

	dt_inicio_w		timestamp;
	dt_fim_w		timestamp;
	qt_diff_days_w	integer;
	qt_diff_month_w	integer;
	qt_diff_year_w	integer;
	ds_retorno_w varchar(255);

BEGIN
    select  dt_inicio_p,
            dt_fim_p
    into STRICT    dt_inicio_w,
            dt_fim_w
;

	if ((dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') and dt_inicio_w <= dt_fim_w) then
		select	pkg_date_utils.get_DiffDate(dt_inicio_w,coalesce(dt_fim_w,clock_timestamp()),'YEAR'),
				pkg_date_utils.get_DiffDate(dt_inicio_w,coalesce(dt_fim_w,clock_timestamp()),'MONTH%'),
				pkg_date_utils.get_DiffDate(dt_inicio_w,coalesce(dt_fim_w,clock_timestamp()),'DAY%')
		into STRICT	qt_diff_year_w,
				qt_diff_month_w,
				qt_diff_days_w
		;
		
		if ((qt_diff_year_w IS NOT NULL AND qt_diff_year_w::text <> '') and qt_diff_year_w >= 1) then
			select	qt_diff_year_w || obter_desc_expressao(770641)
			into STRICT	ds_retorno_w
			;
		end if;
		
		if ((qt_diff_month_w IS NOT NULL AND qt_diff_month_w::text <> '') and qt_diff_month_w >= 1) then
			select	CASE WHEN coalesce(ds_retorno_w::text, '') = '' THEN  ds_retorno_w  ELSE ds_retorno_w || ' ' END  || qt_diff_month_w ||  obter_desc_expressao(347200)
			into STRICT	ds_retorno_w
			;
		end if;
		
		if ((qt_diff_days_w IS NOT NULL AND qt_diff_days_w::text <> '') and qt_diff_days_w >=1 ) then
			select	CASE WHEN coalesce(ds_retorno_w::text, '') = '' THEN  ds_retorno_w  ELSE ds_retorno_w || ' ' END  || qt_diff_days_w || obter_desc_expressao(770638)
			into STRICT	ds_retorno_w
			;
		end if;
			
	end if;
	
	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_prob_ativo_linked ( dt_inicio_p text default null, dt_fim_p text default null) FROM PUBLIC;

