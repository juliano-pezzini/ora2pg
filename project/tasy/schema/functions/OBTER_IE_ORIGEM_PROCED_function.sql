-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_origem_proced ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
ie_origem_proced_w	bigint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
ie_tipo_atendimento_w	smallint;
ie_tipo_convenio_w	smallint;

BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then	 
	begin 
	cd_convenio_w	:= obter_convenio_atendimento(nr_atendimento_p);
	cd_categoria_w	:= obter_categoria_atendimento(nr_atendimento_p);
	 
	select	ie_tipo_atendimento, 
		ie_tipo_convenio 
	into STRICT	ie_tipo_atendimento_w, 
		ie_tipo_convenio_w 
	from	atendimento_paciente 
	where	nr_atendimento	= nr_atendimento_p;
	 
	ie_origem_proced_w	:= coalesce(obter_origem_proced_cat( 
					wheb_usuario_pck.get_cd_estabelecimento, 
					ie_tipo_atendimento_w, 
					ie_tipo_convenio_w, 
					cd_convenio_w, 
					cd_categoria_w),1);
	end;
end if;
return ie_origem_proced_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_origem_proced ( nr_atendimento_p bigint) FROM PUBLIC;

