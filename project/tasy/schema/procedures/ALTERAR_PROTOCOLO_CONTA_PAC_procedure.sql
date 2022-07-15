-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_protocolo_conta_pac ( nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then 
 
update	conta_paciente 
set	dt_atualizacao = clock_timestamp(), 
	nm_usuario   = nm_usuario_p, 
	nr_seq_protocolo = nr_seq_protocolo_p 
where   nr_interno_conta = nr_interno_conta_p;
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_protocolo_conta_pac ( nr_seq_protocolo_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

