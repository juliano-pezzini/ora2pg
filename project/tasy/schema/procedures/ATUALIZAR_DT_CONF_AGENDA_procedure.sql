-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dt_conf_agenda (nm_usuario_conf_p text, ie_alterar_status_p text, nr_seq_agenda_p bigint) AS $body$
BEGIN

  if (ie_alterar_status_p = 'S') then
    update agenda_consulta
    set ie_status_agenda = 'CN',
        dt_confirmacao = clock_timestamp(),
        nm_usuario_confirm = nm_usuario_conf_p
    where nr_sequencia = nr_seq_agenda_p;
  else
    update agenda_consulta
    set dt_confirmacao = clock_timestamp(),
        nm_usuario_confirm = nm_usuario_conf_p
    where nr_sequencia = nr_seq_agenda_p;
  end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dt_conf_agenda (nm_usuario_conf_p text, ie_alterar_status_p text, nr_seq_agenda_p bigint) FROM PUBLIC;

