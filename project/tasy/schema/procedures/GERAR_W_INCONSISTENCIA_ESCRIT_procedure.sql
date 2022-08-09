-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_inconsistencia_escrit (ie_opcao_p text, nr_seq_documento_p bigint, nr_seq_inconsistencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* NÃO DAR COMMIT NESTA PROCEDURE

ie_opcao_p

C	Cobrança Escritural
P	Pagamento Escritural

*/
BEGIN

if (ie_opcao_p	= 'C') then

	insert	into w_inconsistencia_escrit(dt_atualizacao,
		nm_usuario,
		nr_seq_cobranca,
		nr_seq_inconsistencia,
		nr_sequencia)
	values (clock_timestamp(),
		nm_usuario_p,
		nr_seq_documento_p,
		nr_seq_inconsistencia_p,
		nextval('w_inconsistencia_escrit_seq'));

elsif (ie_opcao_p	= 'P') then

	insert	into w_inconsistencia_escrit(dt_atualizacao,
		nm_usuario,
		nr_seq_banco_escrit,
		nr_seq_inconsistencia,
		nr_sequencia)
	values (clock_timestamp(),
		nm_usuario_p,
		nr_seq_documento_p,
		nr_seq_inconsistencia_p,
		nextval('w_inconsistencia_escrit_seq'));

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_inconsistencia_escrit (ie_opcao_p text, nr_seq_documento_p bigint, nr_seq_inconsistencia_p bigint, nm_usuario_p text) FROM PUBLIC;
