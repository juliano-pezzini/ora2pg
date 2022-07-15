-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tasy_regedit ( ds_maquina_p text, ds_cliente_p text, qt_blob_cache_p INOUT bigint, qt_blob_size_p INOUT bigint, ds_dir_email_p INOUT text, ds_dir_padrao_p INOUT text, ds_dir_temp_p INOUT text, ds_email_logo_file_p INOUT text, ds_logo_file_p INOUT text, ds_porta_serial_p INOUT text, ie_gerar_mb_dir_temp_p INOUT text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	qt_blob_cache,
		qt_blob_size,
		ds_dir_email,
		ds_dir_padrao,
		ds_dir_temp,
		ds_email_logo_file,
		ds_logo_file,
		ds_porta_serial,
		ie_gerar_mb_dir_temp_p
	from	Tasy_Regedit
	where	coalesce(ds_maquina, ds_maquina_p) = upper(ds_maquina_p)
	  and	coalesce(ds_cliente, ds_cliente_p) = upper(ds_cliente_p)
	order by coalesce(ds_maquina, ''), coalesce(ds_cliente, '');

BEGIN

open c01;
loop
fetch c01 into 	qt_blob_cache_p,
		qt_blob_size_p,
		ds_dir_email_p,
		ds_dir_padrao_p,
		ds_dir_temp_p,
		ds_email_logo_file_p,
		ds_logo_file_p,
		ds_porta_serial_p,
		ie_gerar_mb_dir_temp_p;
	EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tasy_regedit ( ds_maquina_p text, ds_cliente_p text, qt_blob_cache_p INOUT bigint, qt_blob_size_p INOUT bigint, ds_dir_email_p INOUT text, ds_dir_padrao_p INOUT text, ds_dir_temp_p INOUT text, ds_email_logo_file_p INOUT text, ds_logo_file_p INOUT text, ds_porta_serial_p INOUT text, ie_gerar_mb_dir_temp_p INOUT text) FROM PUBLIC;

