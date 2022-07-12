-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_comp_gas_rel (qt_dose_p bigint, cd_unidade_medida_p text, ie_respiracao_p text, ie_modo_adm_p text, ie_disp_resp_esp_p text default null, ie_unidade_medida_p text default null, cd_intervalo_p text default null, ie_administracao_p text default null, ie_urgente_p text default null) RETURNS varchar AS $body$
DECLARE



	function get_dose_unidade_medida return text is
			qt_dose_w           varchar(30);
	
BEGIN
		--Colocar '0' antes da vírgula
		qt_dose_w := qt_dose_p;
		if (substr(qt_dose_w,1,1) = ',') then
			qt_dose_w	:= '0' || qt_dose_w;

			qt_dose_w	:= replace(qt_dose_w,'.',',');
		end if;

		return ' ' || qt_dose_w || ' ' || obter_dados_unid_medida(cd_unidade_medida_p, 'DS') || ' ';
	end;


	function get_tipo_respiracao return varchar2 is
	begin
		return ' ' || obter_desc_expressao(628903, '') ||':'||' '||obter_valor_dominio(1299, ie_respiracao_p) || ' ';
	end;

	function get_modo_adm return varchar2 is
	begin
		if (ie_modo_adm_p = 'C') then
			return ' ' || obter_desc_expressao(290188, '') ||' '|| obter_desc_expressao(286121, '') || ' ';

		elsif (ie_modo_adm_p = 'I') then
			return ' ' || obter_desc_expressao(290188, '') ||' '|| obter_desc_expressao(292175, '') || ' ';
		end if;

		return ' ';
	end;

	function disp_respiracao return varchar2 is
	begin
		if (ie_disp_resp_esp_p IS NOT NULL AND ie_disp_resp_esp_p::text <> '') then
			return ' ' || obter_desc_expressao(288012, '') ||' '|| obter_valor_dominio(1612, ie_disp_resp_esp_p) || ' ';
		end if;

		return '';
	end;

	function get_unidade_medida return varchar2 is
	begin

		if (ie_unidade_medida_p IS NOT NULL AND ie_unidade_medida_p::text <> '') then
			return ' ' || substr(obter_valor_dominio(1580,ie_unidade_medida_p),1,255) || ' ';
		end if;

		return '';
	end;

	function desc_intervalo return varchar2 is
	begin
		if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '')  then
			return ' ' || obter_desc_expressao(292190, '') ||': '|| obter_desc_intervalo(cd_intervalo_p) || ' ';
		end if;

		return '';
	end;

	function ds_urgencia return varchar2 is
	begin
		if (ie_administracao_p = 'P') and (ie_urgente_p IS NOT NULL AND ie_urgente_p::text <> '') then
			return  ' ' || obter_valor_dominio(7069, ie_urgente_p);
		end if;

		return '';
	end;

	function ds_se_necessario return varchar2 is
	begin
		if (ie_administracao_p = 'N') then
			return  ' ' || obter_desc_expressao(298074, '');
		end if;

		return '';
	end;

begin

return	get_dose_unidade_medida() || get_unidade_medida() ||  desc_intervalo() || get_tipo_respiracao() || get_modo_adm() || disp_respiracao() || ds_urgencia() || ds_se_necessario();

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_comp_gas_rel (qt_dose_p bigint, cd_unidade_medida_p text, ie_respiracao_p text, ie_modo_adm_p text, ie_disp_resp_esp_p text default null, ie_unidade_medida_p text default null, cd_intervalo_p text default null, ie_administracao_p text default null, ie_urgente_p text default null) FROM PUBLIC;

