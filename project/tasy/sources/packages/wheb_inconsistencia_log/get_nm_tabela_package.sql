-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_inconsistencia_log.get_nm_tabela () RETURNS varchar AS $body$
BEGIN
    RETURN current_setting('wheb_inconsistencia_log.current_nm_tabela')::varchar(50);
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION wheb_inconsistencia_log.get_nm_tabela () FROM PUBLIC;
