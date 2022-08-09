-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_anexo_ordem_serv_ws ( nr_seq_ordem_p bigint, ds_arquivo_p text, ie_status_anexo_p text default 'P', nr_seq_philips_p bigint DEFAULT NULL) AS $body$
BEGIN
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	insert into man_ordem_serv_arq(
                                	nr_sequencia,
	                                nr_seq_ordem,
					dt_atualizacao,
                                	nm_usuario,
	                                ds_arquivo,
	                                ie_status_anexo,
	                                ie_anexar_email,
					nr_seq_philips)
		values (
                	                nextval('man_ordem_serv_arq_seq'),
                                	nr_seq_ordem_p,
	                                clock_timestamp(),
	                                'WebService',
	                                ds_arquivo_p,
	                                ie_status_anexo_p,
	                                'N',
					nr_seq_philips_p);
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_anexo_ordem_serv_ws ( nr_seq_ordem_p bigint, ds_arquivo_p text, ie_status_anexo_p text default 'P', nr_seq_philips_p bigint DEFAULT NULL) FROM PUBLIC;
