-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_envio_prot_conv ( nr_seq_protocolo_p bigint, nr_seq_envio_conv_p bigint) AS $body$
BEGIN
 
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then 
	update	protocolo_convenio 
	set	nr_seq_envio_convenio = nr_seq_envio_conv_p 
	where	nr_seq_protocolo = nr_seq_protocolo_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_envio_prot_conv ( nr_seq_protocolo_p bigint, nr_seq_envio_conv_p bigint) FROM PUBLIC;

