-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_type_chart_surgery ( nr_seq_anest_ocor_p bigint, nr_seq_agent_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

							
qt_dose_w				double precision;
qt_dose_ataque_w		double precision;
qt_halog_ins_w			double precision;
qt_velocidade_inf_w	double precision;
ie_aplic_bolus_w		varchar(1);
ds_tipo_dosagem_w		varchar(255);
ds_unid_medida_adm_w	varchar(255);
ie_modo_registro_w	varchar(15);
ie_modo_adm_w			varchar(15);
ds_retorno_w			varchar(2000);


BEGIN

if (coalesce(nr_seq_anest_ocor_p,0) > 0) then
	select	max(a.qt_dose),
				max(a.qt_dose_ataque),
				max(a.qt_halog_ins),
				max(a.qt_velocidade_inf),
				max(a.ie_aplic_bolus),
				substr(max(obter_valor_dominio(1580,b.ie_tipo_dosagem)),1,255),
				substr(max(obter_desc_unid_med(b.cd_unid_medida_adm)),1,255),
				max(a.ie_modo_registro),
				max(b.ie_modo_adm)
	into STRICT		qt_dose_w,
				qt_dose_ataque_w,
				qt_halog_ins_w,
				qt_velocidade_inf_w,
				ie_aplic_bolus_w,
				ds_tipo_dosagem_w,
				ds_unid_medida_adm_w,
				ie_modo_registro_w,
				ie_modo_adm_w
	from		cirurgia_agente_anest_ocor a,
				cirurgia_agente_anestesico b
	where		a.nr_seq_cirur_agente 	= b.nr_sequencia
	and		a.nr_sequencia 			= nr_seq_anest_ocor_p;	
	
	if (ie_modo_adm_w = 'IN') then
		if (coalesce(qt_dose_w,0) > 0) then
			ds_retorno_w	:= ds_unid_medida_adm_w;
		end if;	
	elsif (ie_modo_adm_w = 'CO') then
		if (coalesce(qt_dose_ataque_w,0) > 0) then
			ds_retorno_w	:= obter_desc_expressao(288245,null); -- Dose isolada (ml)
		elsif (ie_modo_registro_w = 'R') then
			ds_retorno_w	:= obter_desc_expressao(488741,null); --Mililitro
		elsif (ie_modo_registro_w = 'T') then	
			ds_retorno_w	:= obter_desc_expressao(488741,null);
		elsif (ie_modo_registro_w = 'V') then
			ds_retorno_w	:= ds_tipo_dosagem_w;
		end if;
	end if;	
else
	select	max(ie_modo_adm),
				substr(max(obter_valor_dominio(1580,ie_tipo_dosagem)),1,255),
				substr(max(obter_desc_unid_med(cd_unid_medida_adm)),1,255)
	into STRICT		ie_modo_adm_w,
				ds_tipo_dosagem_w,
				ds_unid_medida_adm_w
	from		cirurgia_agente_anestesico
	where		nr_sequencia = nr_seq_agent_p;
	
	if (ie_modo_adm_w = 'CO') then
		ds_retorno_w	:= ds_tipo_dosagem_w;
	else
		ds_retorno_w	:= ds_unid_medida_adm_w;
	end if;	
end if;

if (ie_opcao_p = 'style') then
	if (ie_modo_adm_w = 'IN' OR ie_modo_adm_w = 'AC') then
		ds_retorno_w := 'line';
	elsif (coalesce(qt_dose_ataque_w,0) > 0) then
		ds_retorno_w := 'points';
	elsif (ie_modo_adm_w = 'CO') then
		ds_retorno_w := 'line';
	end if;
end if;

if (ie_opcao_p = 'qt_size') then
	ds_retorno_w := '0';
	if (ie_modo_adm_w = 'IN' OR ie_modo_adm_w = 'AC') then
		ds_retorno_w := '3';
	elsif (coalesce(qt_dose_ataque_w,0) > 0) then
		ds_retorno_w := '10';
	elsif (ie_modo_adm_w = 'CO')	then
		ds_retorno_w := '3';
	end if;
end if;

	

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_type_chart_surgery ( nr_seq_anest_ocor_p bigint, nr_seq_agent_p bigint, ie_opcao_p text) FROM PUBLIC;
