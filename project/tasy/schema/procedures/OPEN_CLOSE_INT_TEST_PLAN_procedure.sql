-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE open_close_int_test_plan (nr_seq_control_p bigint, nm_user_p text, ds_action_p text) AS $body$
BEGIN

  if ds_action_p = 'C' then

    update reg_integrated_test_cont
       set dt_fim = clock_timestamp(),
           dt_atualizacao_nrec = clock_timestamp(),
           nm_usuario_nrec = nm_user_p
     where nr_sequencia = nr_seq_control_p;

  elsif ds_action_p = 'O' then
  
    update reg_integrated_test_cont
       set dt_fim  = NULL,
           dt_atualizacao_nrec = clock_timestamp(),
           nm_usuario_nrec = nm_user_p
     where nr_sequencia = nr_seq_control_p;

  end if;

   commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE open_close_int_test_plan (nr_seq_control_p bigint, nm_user_p text, ds_action_p text) FROM PUBLIC;

