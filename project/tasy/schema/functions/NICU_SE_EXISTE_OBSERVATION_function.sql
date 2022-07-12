-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nicu_se_existe_observation (ID_RULE_P text) RETURNS bigint AS $body$
DECLARE

			   
QT_REGISTROS_W	double precision := 0;


BEGIN
	SELECT	count(*)
	INTO STRICT	QT_REGISTROS_W
	FROM	NICU_OBSERVATION
	WHERE ID_RULE = ID_RULE_P;

	RETURN QT_REGISTROS_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nicu_se_existe_observation (ID_RULE_P text) FROM PUBLIC;

