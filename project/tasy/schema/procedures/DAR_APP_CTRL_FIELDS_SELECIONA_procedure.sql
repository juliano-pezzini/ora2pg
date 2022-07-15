-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_app_ctrl_fields_seleciona (nr_sequencia_p dar_app_control_fields.nr_sequencia%type) AS $body$
BEGIN
   -- 
   update dar_app_control_fields
      set ie_selecao = 1
    where nr_sequencia = nr_sequencia_p;
   --
   commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_app_ctrl_fields_seleciona (nr_sequencia_p dar_app_control_fields.nr_sequencia%type) FROM PUBLIC;

