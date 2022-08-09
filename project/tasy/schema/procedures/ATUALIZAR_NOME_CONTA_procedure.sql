-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_nome_conta ( nr_protocolo_p text, nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then 
update	conta_paciente 
set	nr_protocolo = nr_protocolo_p, 
	dt_atualizacao = clock_timestamp(), 
	nm_usuario = nm_usuario_p 
where nr_seq_protocolo = nr_seq_protocolo_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_nome_conta ( nr_protocolo_p text, nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
