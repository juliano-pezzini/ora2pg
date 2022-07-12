-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_db.is_unique_key (integridade_referencial_p INTEGRIDADE_REFERENCIAL) RETURNS boolean AS $body$
DECLARE

	indice_w INDICE%rowtype;
	
BEGIN
	indice_w := wheb_db.get_indice(integridade_referencial_p.NM_TABELA, integridade_referencial_p.NM_INTEGRIDADE_REFERENCIAL);
	RETURN wheb_db.is_unique_key(indice_w);
	END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_db.is_unique_key (integridade_referencial_p INTEGRIDADE_REFERENCIAL) FROM PUBLIC;