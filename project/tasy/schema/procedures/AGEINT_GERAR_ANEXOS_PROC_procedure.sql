-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_anexos_proc (nr_seq_ageint_p bigint, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_arquivo_w	varchar(255);
nr_seq_anexo_w	bigint;
qt_existe_w	bigint;
nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	ds_arquivo,
		nr_sequencia
	from	ageint_proc_int_arquivo
	where	nr_seq_proc_interno				= nr_seq_proc_interno_p
	and	coalesce(cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
	order by ds_arquivo;


BEGIN

open C01;
loop
fetch C01 into
	ds_arquivo_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('ageint_arq_anexo_email_seq')
	into STRICT	nr_seq_anexo_w
	;

	select	count(*)
	into STRICT	qt_existe_w
	from	ageint_arq_anexo_email
	where	nr_seq_agenda_int	= nr_seq_ageint_p
	and	ds_arquivo		= ds_arquivo_w;

	if (qt_existe_w = 0) then

		insert into ageint_arq_anexo_email( nr_sequencia,
						    dt_atualizacao,
						    nm_usuario,
						    dt_atualizacao_nrec,
						    nm_usuario_nrec,
						    nr_seq_agenda_int,
						    ds_arquivo,
						    nr_seq_anexo_regra
						    )
					values ( nr_seq_anexo_w,
						    clock_timestamp(),
						    nm_usuario_p,
						    clock_timestamp(),
						    nm_usuario_p,
						    nr_seq_ageint_p,
						    ds_arquivo_w,
						    nr_sequencia_w);
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
-- REVOKE ALL ON PROCEDURE ageint_gerar_anexos_proc (nr_seq_ageint_p bigint, nr_seq_proc_interno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

