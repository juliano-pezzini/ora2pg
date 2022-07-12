-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.addvalorxml (ds_valor_p text) AS $body$
DECLARE

		ds_xml_aux	varchar(32000);
	
BEGIN
		begin	
			ds_xml_aux := ds_valor_p;
			
			if (current_setting('wheb_exportar_xml_pck.ds_carac_espec_conv_w')::(varchar(255) IS NOT NULL AND (varchar(255))::text <> '')) and (ds_valor_p IS NOT NULL AND ds_valor_p::text <> '') then
				ds_xml_aux	:= wheb_exportar_xml_pck.elimina_caracteres_especiais(ds_xml_aux, current_setting('wheb_exportar_xml_pck.ds_carac_espec_conv_w')::varchar(255));
			end	if;				
			if ( current_setting('wheb_exportar_xml_pck.ie_proj_carac_esp_w')::varchar(1) = 'S' ) and ( current_setting('wheb_exportar_xml_pck.ds_carac_espec_w')::(varchar(255) IS NOT NULL AND (varchar(255))::text <> '')) and (ds_valor_p IS NOT NULL AND ds_valor_p::text <> '') then
				ds_xml_aux	:= wheb_exportar_xml_pck.elimina_caracteres_especiais(ds_xml_aux, current_setting('wheb_exportar_xml_pck.ds_carac_espec_w')::varchar(255));
			end	if;
			if ( current_setting('wheb_exportar_xml_pck.ie_consist_acent')::varchar(1) = 'S' ) and (ds_valor_p IS NOT NULL AND ds_valor_p::text <> '') then
				ds_xml_aux	:= Elimina_Acentos(ds_xml_aux, 'S');
			end	if;
			
			PERFORM set_config('wheb_exportar_xml_pck.ds_xml_valor_w', current_setting('wheb_exportar_xml_pck.ds_xml_valor_w')::varchar(32000) || ds_xml_aux, false);
		exception
			when OTHERS then
			CALL wheb_exportar_xml_pck.salvarvalorxmlbanco();
			PERFORM set_config('wheb_exportar_xml_pck.ds_xml_valor_w', ds_xml_aux, false);
		end;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.addvalorxml (ds_valor_p text) FROM PUBLIC;
