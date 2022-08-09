-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_neo_especialidade ( sn_principal_p text, cod_especialidade_p text, nome_especialidade_p text, nr_seq_profissional_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_neo_especialidade_w	bigint;


BEGIN

select	nextval('w_neo_especialidade_seq')
into STRICT	nr_seq_neo_especialidade_w
;

insert into w_neo_especialidade(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	sn_principal,
	cod_especialidade,
	nome_especialidade,
	nr_seq_profissional)
values (	nr_seq_neo_especialidade_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	sn_principal_p,
	cod_especialidade_p,
	nome_especialidade_p,
	nr_seq_profissional_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_neo_especialidade ( sn_principal_p text, cod_especialidade_p text, nome_especialidade_p text, nr_seq_profissional_p bigint, nm_usuario_p text) FROM PUBLIC;
