-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_meta (nr_seq_estagio_p bigint, ie_tipo_meta_p text, dt_inicio_estagio_p timestamp, dt_final_estagio_p timestamp, qt_horas_estagio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_meta_w		varchar(255);


BEGIN

if (ie_tipo_meta_p IS NOT NULL AND ie_tipo_meta_p::text <> '') then
	ds_tipo_meta_w:= obter_valor_dominio(6915, ie_tipo_meta_p);
else
	ds_tipo_meta_w:= obter_valor_dominio(6915, Obter_Tipo_Meta_Estagio(nr_seq_estagio_p, 0, Obter_Qt_Horas_Estagio(dt_inicio_estagio_p, dt_final_estagio_p, qt_horas_estagio_p)));
end if;

return	ds_tipo_meta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_meta (nr_seq_estagio_p bigint, ie_tipo_meta_p text, dt_inicio_estagio_p timestamp, dt_final_estagio_p timestamp, qt_horas_estagio_p bigint) FROM PUBLIC;
