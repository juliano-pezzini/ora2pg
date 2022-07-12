-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION billing_i18n_pck.obter_se_calcula_drg () RETURNS varchar AS $body$
BEGIN
  if retorna_locale_i18n in (current_setting('billing_i18n_pck.locale_de_w')::bigint,current_setting('billing_i18n_pck.locale_au_w')::bigint,current_setting('billing_i18n_pck.locale_all_w')::bigint) then
      return 'S';
    else
      return 'N';
    end if;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION billing_i18n_pck.obter_se_calcula_drg () FROM PUBLIC;