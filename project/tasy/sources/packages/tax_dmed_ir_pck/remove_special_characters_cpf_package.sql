-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.remove_special_characters_cpf (str1_p text) RETURNS varchar AS $body$
BEGIN
      return regexp_replace(fis_remove_special_characters(str1_p), '\s', '');
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.remove_special_characters_cpf (str1_p text) FROM PUBLIC;