-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_justificativa_ctrl_cavi (nr_cirurgia_p bigint, ds_justificativa_p text default '', nr_seq_justificativa_p bigint default null, nm_usuario_p text DEFAULT NULL, nr_sequencia_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE

nr_sequencia_w	bigint;


BEGIN

If (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then

	select	nextval('cirurgia_justi_cavidade_seq')
	into STRICT	nr_sequencia_w
	;

	insert into cirurgia_justi_cavidade(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_cirurgia,
		ds_justificativa,
		nm_usuario_justificativa,
		nr_seq_justificativa,
		dt_liberacao,
		ie_situacao)
	values (nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_cirurgia_p,
		ds_justificativa_p,
		nm_usuario_p,
		nr_seq_justificativa_p,
		clock_timestamp(),
		'A');

	nr_sequencia_p	:= nr_sequencia_w;
End if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_justificativa_ctrl_cavi (nr_cirurgia_p bigint, ds_justificativa_p text default '', nr_seq_justificativa_p bigint default null, nm_usuario_p text DEFAULT NULL, nr_sequencia_p INOUT bigint DEFAULT NULL) FROM PUBLIC;
