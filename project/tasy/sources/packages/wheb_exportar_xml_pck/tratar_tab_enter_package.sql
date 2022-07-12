-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.tratar_tab_enter (ds_valor_p INOUT text) AS $body$
BEGIN
		PERFORM set_config('wheb_exportar_xml_pck.qt_controle_chr_w', 0, false);
		while( position(chr(13) in ds_valor_p) > 0 ) and ( current_setting('wheb_exportar_xml_pck.qt_controle_chr_w')::bigint < 100 ) loop
			ds_valor_p := replace(ds_valor_p,chr(13),'');
			PERFORM set_config('wheb_exportar_xml_pck.qt_controle_chr_w', current_setting('wheb_exportar_xml_pck.qt_controle_chr_w')::bigint + 1, false);
		end loop;

		PERFORM set_config('wheb_exportar_xml_pck.qt_controle_chr_w', 0, false);

		while( position(chr(10) in ds_valor_p) > 0 ) and ( current_setting('wheb_exportar_xml_pck.qt_controle_chr_w')::bigint < 100 ) loop
			ds_valor_p := replace(ds_valor_p,chr(10),'');
			PERFORM set_config('wheb_exportar_xml_pck.qt_controle_chr_w', current_setting('wheb_exportar_xml_pck.qt_controle_chr_w')::bigint + 1, false);
		end loop;
	end;


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.tratar_tab_enter (ds_valor_p INOUT text) FROM PUBLIC;