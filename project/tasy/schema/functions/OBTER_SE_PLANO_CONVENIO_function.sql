-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_plano_convenio (cd_convenio_p bigint, cd_plano_p text) RETURNS varchar AS $body$
DECLARE


ds_convenio_plano_w	varchar(255)	:= 'N';
qt_convenio_w		integer 	:= 0;


BEGIN

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then
	begin
		select	count(*) qt_convenio
		into STRICT	qt_convenio_w
		from	convenio_plano
		where 	cd_convenio = cd_convenio_p
		and	cd_plano = cd_plano_p;

		if (qt_convenio_w = 0) then
			ds_convenio_plano_w := substr(obter_texto_tasy(26120, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		end if;
	end;
end if;


return	ds_convenio_plano_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_plano_convenio (cd_convenio_p bigint, cd_plano_p text) FROM PUBLIC;

