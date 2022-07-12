-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_cir_atend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_cirurgia_w  bigint;


BEGIN

IF (coalesce(nr_atendimento_p,0) > 0) THEN

	SELECT 	MAX(nr_cirurgia)
	INTO STRICT 	nr_cirurgia_w
	FROM  	cirurgia
	WHERE 	nr_atendimento = nr_atendimento_p
	AND   	(coalesce(dt_inicio_real,dt_inicio_prevista) IS NOT NULL AND (coalesce(dt_inicio_real,dt_inicio_prevista))::text <> '');

END IF;

RETURN nr_cirurgia_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_cir_atend ( nr_atendimento_p bigint) FROM PUBLIC;
