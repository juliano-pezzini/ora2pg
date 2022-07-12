-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_inco_ativa (cd_inconsistencia_p bigint) RETURNS boolean AS $body$
DECLARE


ie_consiste_w		varchar(1)	:= 'N';
ie_aih_w			varchar(1)	:= 'S';
ie_apac_w		varchar(1)	:= 'S';
ie_bpa_con_w		varchar(1)	:= 'S';
ie_bpa_ind_w		varchar(1)	:= 'S';
cd_funcao_w		integer;
ie_retorno_w		boolean		:= false;


BEGIN

CALL sus_obter_inco_ativa_pck.set_sus_obter_inco_ativa(cd_inconsistencia_p);
ie_consiste_w	:= sus_obter_inco_ativa_pck.get_ie_consiste;
ie_aih_w	:= sus_obter_inco_ativa_pck.get_ie_aih;
ie_apac_w	:= sus_obter_inco_ativa_pck.get_ie_apac;
ie_bpa_con_w	:= sus_obter_inco_ativa_pck.get_ie_bpa_con;
ie_bpa_ind_w	:= sus_obter_inco_ativa_pck.get_ie_bpa_ind;

if (ie_consiste_w	= 'N') then
	ie_retorno_w	:= false;
elsif (ie_consiste_w	= 'S') then
	cd_funcao_w	:= coalesce(obter_funcao_ativa,0);
	if (cd_funcao_w	= 1123) or (sus_tipo_atendimento_pck.get_ie_tipo_atend_sus = 'A') then		
		ie_retorno_w	:= ie_aih_w = 'S';
	elsif (cd_funcao_w	= 1124) or (sus_tipo_atendimento_pck.get_ie_tipo_atend_sus = 'P')  then		
		ie_retorno_w	:= ie_apac_w = 'S';
	elsif (cd_funcao_w	= 1125) or (sus_tipo_atendimento_pck.get_ie_tipo_atend_sus = 'B')  then		
		ie_retorno_w	:= ((ie_bpa_con_w = 'S') or (ie_bpa_ind_w = 'S')); /* Para os testes iniciais nao tera diferenca de BPA-C ou BPA-I*/
	elsif (cd_funcao_w	in (1121,3111)) then
		ie_retorno_w	:= ((ie_aih_w = 'S') or (ie_apac_w = 'S') or (ie_bpa_con_w = 'S') or (ie_bpa_ind_w = 'S'));
	elsif (cd_funcao_w	= 916) then
		ie_retorno_w	:= ((ie_aih_w = 'S') or (ie_apac_w = 'S'));
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_inco_ativa (cd_inconsistencia_p bigint) FROM PUBLIC;

