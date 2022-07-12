-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prox_data_ref (ie_forma_solic_p text, nr_dia_p bigint, nr_mes_p bigint, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE


-- ATENCAO: Ao alterar esta function tem que verificar se nao e necessario alterar tambem a HD_OBTER_PROX_EXEC_PROTOCOLO
					
dt_base_w		timestamp;
vl_mes_w		smallint;
nr_mes_w		smallint;
nr_dia_w		smallint;
nr_dia_referencia_w	smallint;
vl_ultimo_dia_mes_w	smallint;
vl_ano_w		smallint;
dt_param_w		timestamp;


BEGIN
if (ie_forma_solic_p IS NOT NULL AND ie_forma_solic_p::text <> '') and (nr_dia_p IS NOT NULL AND nr_dia_p::text <> '') and (nr_mes_p IS NOT NULL AND nr_mes_p::text <> '') then

	nr_dia_referencia_w	:= nr_dia_p;
	vl_mes_w		:= nr_mes_p;
	vl_ano_w		:= (pkg_date_utils.extract_field('YEAR', clock_timestamp(),0))::numeric;

	nr_mes_w		:= 0;
	nr_dia_w		:= 0;

	if (ie_forma_solic_p = 'SE') then
		nr_dia_w	:= 7;
		vl_mes_w	:= (pkg_date_utils.extract_field('MONTH', PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0),0))::numeric;
		
		if (vl_mes_w = 12) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR',clock_timestamp(),0))::numeric  - 1;
		end if;
	
	elsif (ie_forma_solic_p = 'Z') then
		
		nr_dia_w	:= 14;
		vl_mes_w	:= (pkg_date_utils.extract_field('MONTH',PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0),0))::numeric;
		
		if (vl_mes_w = 12) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR', clock_timestamp(), 0))::numeric  - 1;
		end if;		
	
	elsif (ie_forma_solic_p = 'M') then

		nr_mes_w	:= 1;
		vl_mes_w	:= (pkg_date_utils.extract_field('MONTH',PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0),0))::numeric;
		
		if (vl_mes_w = 12) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR',clock_timestamp(),0))::numeric  - 1;
		end if;
		
	elsif (ie_forma_solic_p = 'B') then
		
		nr_mes_w	:= 2;
		vl_mes_w	:= (pkg_date_utils.extract_field('MONTH',PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0),0))::numeric;
		
		if (vl_mes_w > 10) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR',clock_timestamp(),0))::numeric  - 1;
		end if;		

	elsif (ie_forma_solic_p = 'T') then

		nr_mes_w	:= 3;
		vl_ano_w	:= (pkg_date_utils.extract_field('YEAR', clock_timestamp(), 0))::numeric  - 1;
	
	elsif (ie_forma_solic_p = 'Q') then

		nr_mes_w	:= 4;

		if (vl_mes_w > 8) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR',clock_timestamp(),0))::numeric  - 1;
		end if;

	elsif (ie_forma_solic_p = 'S') then

		nr_mes_w 	:= 6;
		
		if (vl_mes_w > 6) then
			vl_ano_w	:= (pkg_date_utils.extract_field('YEAR',clock_timestamp(),0))::numeric  - 1;
		end if;

	else

		nr_mes_w 	:= 12;

	end if;

	select 	(pkg_date_utils.extract_field('DAY', pkg_date_utils.end_of(pkg_date_utils.get_date(vl_ano_w, vl_mes_w, 1, 0),'MONTH',0),0))::numeric
	into STRICT	vl_ultimo_dia_mes_w
	;

	if (nr_dia_referencia_w > vl_ultimo_dia_mes_w) then
		nr_dia_referencia_w := vl_ultimo_dia_mes_w;
	end if;
	
	dt_param_w := pkg_date_utils.get_date(vl_ano_w, vl_mes_w, nr_dia_referencia_w, 0);
	
	/*SO-2225714*/

	if (nr_dia_w > 0) then	
		while(dt_param_w < pkg_date_utils.start_of(PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0), 'DD', 0)) loop
		 begin
		 dt_param_w 	:= dt_param_w + nr_dia_w;
		 end;
		end loop;
	end if;

	if (nr_mes_w > 0) then	
		while(dt_param_w < pkg_date_utils.start_of(PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),0, 0), 'DD', 0)) loop
		begin
		
		begin
		dt_param_w 	:= pkg_date_utils.get_date(nr_dia_referencia_w, PKG_DATE_UTILS.ADD_MONTH(dt_param_w,nr_mes_w, 0), 0);
		
		exception when others then
			dt_param_w 	:= PKG_DATE_UTILS.ADD_MONTH(dt_param_w,nr_mes_w, 0);
		end;
		
		end;
		end loop;
	end if;
	
	dt_base_w	:= dt_param_w;

end if;

return dt_base_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prox_data_ref (ie_forma_solic_p text, nr_dia_p bigint, nr_mes_p bigint, ie_opcao_p text) FROM PUBLIC;

