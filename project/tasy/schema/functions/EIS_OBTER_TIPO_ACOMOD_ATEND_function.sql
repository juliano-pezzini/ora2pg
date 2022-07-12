-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION eis_obter_tipo_acomod_atend ( nr_atendimento_p bigint, cd_convenio_p bigint) RETURNS bigint AS $body$
DECLARE


cd_tipo_acomodacao_w			smallint;


BEGIN

select	max(a.CD_TIPO_ACOMODACAO)
	into STRICT	cd_tipo_acomodacao_w
	from	atend_categoria_convenio a
	where	a.nr_atendimento	= nr_atendimento_p
	and	a.CD_CONVENIO 		= cd_convenio_p
	and 	a.dt_inicio_vigencia    = (SELECT max(dt_inicio_vigencia)
					   from Atend_categoria_convenio b
					   where nr_atendimento = nr_atendimento_p);

RETURN cd_tipo_acomodacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION eis_obter_tipo_acomod_atend ( nr_atendimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;

