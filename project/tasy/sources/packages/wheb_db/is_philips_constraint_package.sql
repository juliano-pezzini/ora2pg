-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_db.is_philips_constraint (nm_tabela_p text, nm_integridade_referencial_p text) RETURNS boolean AS $body$
DECLARE

	count_w bigint := 1;
	
BEGIN
	/*SELECT COUNT(1) VER OS 2201624, 2199111
	  INTO count_w
	  FROM INTEGRIDADE_REFERENCIAL
	 WHERE NM_TABELA                  = UPPER(nm_tabela_p)
	   AND NM_INTEGRIDADE_REFERENCIAL = UPPER(nm_integridade_referencial_p);*/
	RETURN count_w > 0;
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_db.is_philips_constraint (nm_tabela_p text, nm_integridade_referencial_p text) FROM PUBLIC;
