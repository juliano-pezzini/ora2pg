-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_arq_utl_file_cobr ( nr_seq_cobranca_p bigint, ds_arq_rede_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_cobranca_p IS NOT NULL AND nr_seq_cobranca_p::text <> '') and (ds_arq_rede_p IS NOT NULL AND ds_arq_rede_p::text <> '') then

	insert into cobranca_escrit_arq(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_cobranca,
		ds_arquivo)
	values (	nextval('cobranca_escrit_arq_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cobranca_p,
		ds_arq_rede_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_arq_utl_file_cobr ( nr_seq_cobranca_p bigint, ds_arq_rede_p text, nm_usuario_p text) FROM PUBLIC;
