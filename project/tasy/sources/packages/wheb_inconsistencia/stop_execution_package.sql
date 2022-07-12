-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_inconsistencia.stop_execution (integridade_referencial_p INTEGRIDADE_REFERENCIAL) RETURNS boolean AS $body$
BEGIN
    RETURN current_setting('wheb_inconsistencia.enforcevalidations')::boolean AND (NOT wheb_inconsistencia.is_ajusta_automaticamente(integridade_referencial_p) OR wheb_inconsistencia.is_acompanhamento_dba(integridade_referencial_p) OR WHEB_DB.HAS_DUPLICATES(integridade_referencial_p));
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_inconsistencia.stop_execution (integridade_referencial_p INTEGRIDADE_REFERENCIAL) FROM PUBLIC;