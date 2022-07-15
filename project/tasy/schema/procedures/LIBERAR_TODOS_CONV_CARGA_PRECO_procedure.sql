-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_todos_conv_carga_preco ( cd_convenio_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')then
		begin
			update 	convenio_carga_preco
			set 	ie_status = 'L',
				nm_usuario = nm_usuario_p
			where 	cd_convenio = cd_convenio_p;
		end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_todos_conv_carga_preco ( cd_convenio_p bigint, nm_usuario_p text) FROM PUBLIC;

