-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_convenio_categoria (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_convenio_categ_w	varchar(83);
nr_seq_interno_w	bigint;
cd_convenio_w		integer;
cd_categoria_w		bigint;


BEGIN

SELECT	coalesce(Min(nr_seq_interno),0)
into STRICT	nr_seq_interno_w
FROM    atend_categoria_convenio
WHERE   nr_atendimento = nr_atendimento_p;

if (nr_seq_interno_w > 0) then

	select  cd_convenio,
		cd_categoria
	into STRICT	cd_convenio_w,
		cd_categoria_w
	from    atend_categoria_convenio
	where   nr_seq_interno = nr_seq_interno_w;
	
	ds_convenio_categ_w := substr(obter_nome_convenio(cd_convenio_w),1,40) || '/' || (substr(obter_categoria_convenio(cd_convenio_w,cd_categoria_w),1,40));
	
end if;

return	ds_convenio_categ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_convenio_categoria (nr_atendimento_p bigint) FROM PUBLIC;

