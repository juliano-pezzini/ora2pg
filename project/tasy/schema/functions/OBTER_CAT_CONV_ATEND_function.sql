-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cat_conv_atend ( nr_atendimento_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


cd_categoria_w		varchar(10);


BEGIN

select	coalesce(max(cd_categoria),0)
into STRICT	cd_categoria_w
from 	Atend_categoria_convenio a
where a.nr_atendimento		= nr_atendimento_p
and     a.cd_convenio		= cd_convenio_p
  and a.dt_inicio_vigencia	=
	(SELECT max(dt_inicio_vigencia)
	from Atend_categoria_convenio b
	where nr_atendimento	= nr_atendimento_p);

RETURN cd_categoria_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cat_conv_atend ( nr_atendimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;

