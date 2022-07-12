-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_plano_convenio_atend (nr_atendimento_p bigint, ie_cod_desc_p text) RETURNS varchar AS $body$
DECLARE



cd_plano_w		varchar(10)	:= '';
ds_plano_w		varchar(80)	:= '';
nr_seq_interno_w	bigint;


BEGIN

select	coalesce(max(nr_seq_interno),0)
into STRICT 	nr_seq_interno_w
from 	Atend_categoria_convenio a
where 	a.nr_atendimento		= nr_atendimento_p
and 	a.dt_inicio_vigencia	=
	(SELECT max(dt_inicio_vigencia)
	from 	Atend_categoria_convenio b
	where 	nr_atendimento	= nr_atendimento_p);


if (nr_seq_interno_w <> 0) then
	begin

	select	max(b.cd_plano),
		max(b.ds_plano)
	into STRICT	cd_plano_w,
		ds_plano_w
	from	convenio_plano b,
		atend_categoria_convenio a
	where	a.cd_convenio		= b.cd_convenio
	and	a.cd_plano_convenio	= b.cd_plano
	and	a.nr_seq_interno	= nr_seq_interno_w;


	end;
end if;


if (ie_cod_desc_p = 'C') then
	return	cd_plano_w;
else
	return	ds_plano_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_plano_convenio_atend (nr_atendimento_p bigint, ie_cod_desc_p text) FROM PUBLIC;

