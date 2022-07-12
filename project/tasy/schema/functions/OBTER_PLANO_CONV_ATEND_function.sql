-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_plano_conv_atend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_plano_convenio_w		varchar(10);


BEGIN

SELECT	coalesce(MAX(cd_plano_convenio),0)
INTO STRICT	cd_plano_convenio_w
FROM 	Atend_categoria_convenio a
WHERE 	a.nr_atendimento		= nr_atendimento_p
AND 	a.dt_inicio_vigencia	= (SELECT 	MAX(dt_inicio_vigencia)
			FROM 	Atend_categoria_convenio b
			WHERE 	nr_atendimento = nr_atendimento_p);

RETURN cd_plano_convenio_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_plano_conv_atend ( nr_atendimento_p bigint) FROM PUBLIC;
