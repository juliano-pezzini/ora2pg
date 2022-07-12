-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_invoice_data_pck.update_project (nr_sequence_p tax_invoice_project.nr_sequencia%type, cd_user_auth_p tax_invoice_project.cd_user_auth%type, cd_rest_project_p tax_invoice_project.cd_rest_project%type) AS $body$
BEGIN

    if (cd_user_auth_p IS NOT NULL AND cd_user_auth_p::text <> '') then
      update tax_invoice_project set cd_user_auth = cd_user_auth_p where nr_sequencia = nr_sequence_p;
    end if;

    if (cd_rest_project_p IS NOT NULL AND cd_rest_project_p::text <> '') then
      update tax_invoice_project set cd_rest_project = cd_rest_project_p where nr_sequencia = nr_sequence_p;
    end if;

    commit;

  end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_invoice_data_pck.update_project (nr_sequence_p tax_invoice_project.nr_sequencia%type, cd_user_auth_p tax_invoice_project.cd_user_auth%type, cd_rest_project_p tax_invoice_project.cd_rest_project%type) FROM PUBLIC;