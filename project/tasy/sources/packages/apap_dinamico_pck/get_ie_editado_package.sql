-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.get_ie_editado (nr_seq_linha_p bigint, dt_registro_p timestamp, vl_resultado_p bigint, ds_resultado_p text, dt_resultado_p timestamp) RETURNS varchar AS $body$
DECLARE

ie_editado_w	varchar(1) := 'N';
	c_valores CURSOR FOR
		SELECT	coalesce(vl_resultado,0) vl_resultado,
				coalesce(ds_resultado,'XPTO') ds_resultado,
				dt_resultado
		from	w_apap_pac_registro
		where	nr_seq_apap_inf = nr_seq_linha_p
		and		ie_situacao 	= 'I'
		and		dt_registro		= dt_registro_p;
BEGIN
<<read_valores>>
for r_valores in c_valores
	loop
	if (r_valores.vl_resultado <> coalesce(vl_resultado_p,0)) or (r_valores.ds_resultado <> coalesce(ds_resultado_p,'XPTO')) or
		((r_valores.dt_resultado <> dt_resultado_p) and ((r_valores.dt_resultado IS NOT NULL AND r_valores.dt_resultado::text <> '') or (dt_resultado_p IS NOT NULL AND dt_resultado_p::text <> ''))) then
		ie_editado_w := 'S';
	end if;	
	end loop read_valores;
return	ie_editado_w;
END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.get_ie_editado (nr_seq_linha_p bigint, dt_registro_p timestamp, vl_resultado_p bigint, ds_resultado_p text, dt_resultado_p timestamp) FROM PUBLIC;