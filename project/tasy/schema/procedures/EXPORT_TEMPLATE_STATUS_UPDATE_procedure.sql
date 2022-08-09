-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE export_template_status_update ( nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_nrec_p text, nm_user_approval_p text, ie_status_p text) AS $body$
BEGIN
  if (ie_status_p = 'P') then
        update  dm_export_templates
        set nm_usuario_nrec = nm_usuario_nrec_p,
            ie_status = ie_status_p,
            dt_atualizacao_nrec = clock_timestamp()
        where nr_sequencia = nr_sequencia_p;

  elsif (ie_status_p = 'A') then
        update  dm_export_templates
        set nm_usuario_nrec = nm_usuario_nrec_p,
            ie_status = ie_status_p,
            dt_atualizacao_nrec = clock_timestamp(),
            dt_approval_date = clock_timestamp(),
            nm_user_approval = nm_user_approval_p
        where nr_sequencia = nr_sequencia_p;
  end if;

  commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE export_template_status_update ( nr_sequencia_p bigint, nm_usuario_p text, nm_usuario_nrec_p text, nm_user_approval_p text, ie_status_p text) FROM PUBLIC;
