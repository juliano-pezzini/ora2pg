-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE medicare_update_proc ( cd_pessoa_fisica_p text, cd_usuario_convenio_p text, nm_usuario_p text, cd_convenio_p bigint ) AS $body$
DECLARE


medicare_count_w  	varchar(10);


BEGIN
	select 	count(*)
	into STRICT 	medicare_count_w
	from 	convenio
	where 	cd_convenio    = cd_convenio_p
	and 	ie_tipo_convenio = 12;

	if (cd_usuario_convenio_p IS NOT NULL AND cd_usuario_convenio_p::text <> '') and (medicare_count_w > 0) then
		update 	pessoa_fisica
		set 	cd_rfc             = ''
		where 	cd_pessoa_fisica = cd_pessoa_fisica_p
		and 	cd_rfc = cd_usuario_convenio_p;

		commit;
		
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE medicare_update_proc ( cd_pessoa_fisica_p text, cd_usuario_convenio_p text, nm_usuario_p text, cd_convenio_p bigint ) FROM PUBLIC;

