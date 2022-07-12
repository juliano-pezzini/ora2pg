-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsjb_obter_prestador ( cd_pessoa_fisica_p text, ie_tipo_atendimento_p bigint, cd_cgc_prestador_p text, cd_convenio_p bigint, cd_interno_p text) RETURNS varchar AS $body$
DECLARE


cd_interno_w		varchar(15);
ds_retorno_w		varchar(15);
ie_conveniado_w		varchar(1):= 'N';
cd_medico_exec_conv_w	varchar(15):= '0';
cd_estab_usuario_w	smallint := coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);

c01 CURSOR FOR
SELECT	coalesce(cd_interno, cd_interno_p)
from	param_interface
where	cd_convenio	= cd_convenio_p
and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_p)	= ie_tipo_atendimento_p
and	coalesce(cd_cgc,cd_cgc_prestador_p) = cd_cgc_prestador_p
and	coalesce(cd_estabelecimento,cd_estab_usuario_w) = cd_estab_usuario_w
order by	coalesce(cd_cgc,0),
	coalesce(ie_tipo_atendimento,0);


BEGIN

begin
select 	ie_conveniado,
	cd_medico_convenio
into STRICT	ie_conveniado_w,
	cd_medico_exec_conv_w
from 	medico_convenio
where 	cd_convenio = cd_convenio_p
and 	cd_pessoa_fisica = cd_pessoa_fisica_p;
exception
	when others then
	ie_conveniado_w:= 'N';
	cd_medico_exec_conv_w:= '0';
end;


if (coalesce(cd_medico_exec_conv_w,'0') <> '0') and (coalesce(ie_conveniado_w,'N') = 'S') then
	ds_retorno_w:= cd_medico_exec_conv_w;
else
	open c01;
	loop
	fetch c01 into
		cd_interno_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_retorno_w	:= cd_interno_w;
		end;
	end loop;
	close c01;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsjb_obter_prestador ( cd_pessoa_fisica_p text, ie_tipo_atendimento_p bigint, cd_cgc_prestador_p text, cd_convenio_p bigint, cd_interno_p text) FROM PUBLIC;
