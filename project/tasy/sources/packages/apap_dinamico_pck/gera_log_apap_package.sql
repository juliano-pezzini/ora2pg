-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE apap_dinamico_pck.gera_log_apap (ds_log_p text) AS $body$
BEGIN
   insert into w_apap_log(  nr_sequencia,
							  dt_atualizacao,
							  nm_usuario,
							  dt_atualizacao_nrec,
							  nm_usuario_nrec,
							  nr_atendimento,
							  nr_seq_documento,
							  ds_log)
   values (  nextval('w_apap_log_seq'),
							  clock_timestamp(),
							  current_setting('apap_dinamico_pck.nm_usuario_w')::usuario.nm_usuario%type,
							  clock_timestamp(),
							  current_setting('apap_dinamico_pck.nm_usuario_w')::usuario.nm_usuario%type,
							  current_setting('apap_dinamico_pck.nr_atendimento_w')::atendimento_paciente.nr_atendimento%type,
							  current_setting('apap_dinamico_pck.nr_seq_documento_w')::documento.nr_sequencia%type,
							  ds_log_p);
   commit;
   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_dinamico_pck.gera_log_apap (ds_log_p text) FROM PUBLIC;