-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- Português 'Sim' ; Inglês 'Yes'
CREATE OR REPLACE FUNCTION pkg_const_clinical_records.value_s () RETURNS varchar AS $body$
BEGIN
return 'S';
end;

-- Português 'Não' ; Inglês 'No'
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_const_clinical_records.value_s () FROM PUBLIC;