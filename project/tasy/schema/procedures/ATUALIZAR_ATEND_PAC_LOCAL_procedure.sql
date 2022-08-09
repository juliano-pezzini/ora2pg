-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_atend_pac_local ( nr_atend_p text, nr_seq_local_p text) AS $body$
BEGIN
  update atendimento_paciente 
    set nr_seq_local_pa = nr_seq_local_p 
   where nr_atendimento = nr_atend_p;
   
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_atend_pac_local ( nr_atend_p text, nr_seq_local_p text) FROM PUBLIC;
