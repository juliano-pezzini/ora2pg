-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_motivo_cancel_agenda () AS $body$
DECLARE

cd_estabelecimento_w		smallint;
cd_convenio_w			integer;
nr_seq_motivo_cancel_agenda_w	bigint;
C01 CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	ie_situacao = 'A';

BEGIN
open C01;
loop
fetch C01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(nr_seq_motivo_cancel_agenda),
		max(cd_convenio)
	into STRICT	nr_seq_motivo_cancel_agenda_w,
		cd_convenio_w
	from	pls_parametros
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (nr_seq_motivo_cancel_agenda_w IS NOT NULL AND nr_seq_motivo_cancel_agenda_w::text <> '') then
		insert into pls_regra_cancel_agenda(	nr_sequencia,
							nr_seq_motivo_cancel_agenda,
							nr_seq_motivo_cancelamento,
							cd_convenio,
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec)
		values (	nextval('pls_regra_cancel_agenda_seq'),
							nr_seq_motivo_cancel_agenda_w,
							null,
							cd_convenio_w,
							clock_timestamp(),
							clock_timestamp(),
							'BACA',
							'BACA');
	end if;
	end;
end loop;
close C01;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_motivo_cancel_agenda () FROM PUBLIC;
