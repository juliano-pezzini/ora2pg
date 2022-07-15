-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_inf_ordem_servico ( nr_seq_wheb_p bigint, nr_seq_estagio_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_wheb_p IS NOT NULL AND nr_seq_wheb_p::text <> '') and (nr_seq_estagio_p IS NOT NULL AND nr_seq_estagio_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update 	man_ordem_servico
	set 	nr_seq_wheb 	= nr_seq_wheb_p,
		dt_envio_wheb 	= clock_timestamp(),
		nr_seq_estagio 	= CASE WHEN nr_seq_estagio_p=0 THEN  nr_seq_estagio  ELSE nr_seq_estagio_p END ,
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where  	nr_sequencia  	= nr_sequencia_p;
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_inf_ordem_servico ( nr_seq_wheb_p bigint, nr_seq_estagio_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

