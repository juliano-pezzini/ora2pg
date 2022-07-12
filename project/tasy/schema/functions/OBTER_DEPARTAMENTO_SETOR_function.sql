-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_departamento_setor (cd_setor_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_departamento_w 	departamento_setor.cd_departamento%TYPE;


BEGIN
	select MAX(cd_departamento)
	into STRICT cd_departamento_w
	from departamento_setor
	where cd_setor_atendimento = cd_setor_atendimento_p;

RETURN	cd_departamento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_departamento_setor (cd_setor_atendimento_p bigint) FROM PUBLIC;
