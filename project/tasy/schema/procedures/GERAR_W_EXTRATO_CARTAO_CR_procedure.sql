-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_extrato_cartao_cr ( nr_seq_extrato_p bigint, ds_conteudo_p text, nm_usuario_p text) AS $body$
BEGIN

insert into	w_extrato_cartao_cr(	nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_seq_extrato,
									ds_conteudo )
						values (   nextval('w_extrato_cartao_cr_seq'),
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									nr_seq_extrato_p,
									substr(ds_conteudo_p,1,4000) );

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_extrato_cartao_cr ( nr_seq_extrato_p bigint, ds_conteudo_p text, nm_usuario_p text) FROM PUBLIC;
