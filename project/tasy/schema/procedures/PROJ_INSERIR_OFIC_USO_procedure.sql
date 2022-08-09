-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_ofic_uso (cd_pf_wheb_p bigint, cd_pf_cliente_p bigint, nr_seq_cliente_p bigint, nr_seq_proj_p bigint, dt_geracao_p timestamp, dt_oficializacao_p timestamp, dt_prev_ofic_p timestamp, nm_usuario_p text, nr_seq_ofic_uso_p INOUT bigint) AS $body$
BEGIN
	nr_seq_ofic_uso_p:= -1;
if (cd_pf_wheb_p IS NOT NULL AND cd_pf_wheb_p::text <> '' AND cd_pf_cliente_p IS NOT NULL AND cd_pf_cliente_p::text <> '') then

	select nextval('com_cli_ofic_uso_seq')
	into STRICT nr_seq_ofic_uso_p
	;

	insert into com_cli_ofic_uso(nr_sequencia,
								cd_pf_cliente,
								cd_pf_wheb,
								dt_atualizacao,
								dt_atualizacao_nrec,
								dt_geracao,
								dt_oficializacao,
								dt_prev_ofic,
								nm_usuario,
								nm_usuario_nrec,
								nr_seq_cliente,
								nr_seq_proj)
						values (	nr_seq_ofic_uso_p,
								cd_pf_cliente_p,
								cd_pf_wheb_p,
								clock_timestamp(),
								clock_timestamp(),
								dt_geracao_p,
								dt_oficializacao_p,
								dt_prev_ofic_p,
								nm_usuario_p,
								nm_usuario_p,
								nr_seq_cliente_p,
								nr_seq_proj_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_ofic_uso (cd_pf_wheb_p bigint, cd_pf_cliente_p bigint, nr_seq_cliente_p bigint, nr_seq_proj_p bigint, dt_geracao_p timestamp, dt_oficializacao_p timestamp, dt_prev_ofic_p timestamp, nm_usuario_p text, nr_seq_ofic_uso_p INOUT bigint) FROM PUBLIC;
