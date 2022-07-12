-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_verificar_vigencia_regra ( dt_ordem_p timestamp, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
dt_ordem_w		timestamp;
dt_inicio_w		timestamp;
dt_fim_w		timestamp;


BEGIN

IF (coalesce(dt_inicio_p::text, '') = '') OR (coalesce(dt_fim_p::text, '') = '') THEN
	ds_retorno_w := 'S';
ELSE
	SELECT	pkg_date_utils.get_time(HOUR, MINUTE)
	INTO STRICT	dt_ordem_w
	FROM (	SELECT	pkg_date_utils.extract_field('HOUR', coalesce(dt_ordem_p, clock_timestamp())) HOUR,
				pkg_date_utils.extract_field('MINUTE', coalesce(dt_ordem_p, clock_timestamp())) MINUTE
				) alias7;


	SELECT	pkg_date_utils.get_time(HOUR, MINUTE)
	INTO STRICT	dt_inicio_w
	FROM (	SELECT	pkg_date_utils.extract_field('HOUR', coalesce(dt_inicio_p, pkg_date_utils.get_time(00, 00))) HOUR,
				pkg_date_utils.extract_field('MINUTE', coalesce(dt_inicio_p, pkg_date_utils.get_time(00 ,00))) MINUTE
				) alias7;

	SELECT	pkg_date_utils.get_time(HOUR, MINUTE)
	INTO STRICT	dt_fim_w
	FROM (	SELECT	pkg_date_utils.extract_field('HOUR', coalesce(dt_fim_p, pkg_date_utils.get_time(23, 59))) HOUR,
				pkg_date_utils.extract_field('MINUTE', coalesce(dt_fim_p, pkg_date_utils.get_time(23, 59))) MINUTE
				) alias7;

	SELECT	coalesce(MAX('S'), 'N')
	INTO STRICT	ds_retorno_w
	
	WHERE 	dt_ordem_w BETWEEN dt_inicio_w AND dt_fim_w;
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_verificar_vigencia_regra ( dt_ordem_p timestamp, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

