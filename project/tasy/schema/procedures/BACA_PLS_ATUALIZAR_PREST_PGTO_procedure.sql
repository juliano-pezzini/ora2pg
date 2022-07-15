-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_atualizar_prest_pgto ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_prestador_pgto_w		bigint;
nr_seq_prestador_medico_w	bigint;
ie_situacao_w			varchar(1);

C01 CURSOR FOR
	SELECT	nr_seq_prestador_pgto,
		nr_sequencia,
		ie_situacao
	from	pls_prestador_medico;

BEGIN

open C01;
loop
fetch C01 into
	nr_seq_prestador_pgto_w,
	nr_seq_prestador_medico_w,
	ie_situacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (coalesce(nr_seq_prestador_pgto_w,0) <> 0) then
		insert into pls_prestador_prof_pgto(nr_sequencia, nr_seq_profissional, ie_situacao,
			nr_seq_prestador_pgto, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, dt_inicio_vigencia,
			dt_fim_vigencia, dt_inicio_vigencia_ref, dt_fim_vigencia_ref)
		values (nextval('pls_prestador_prof_pgto_seq'), nr_seq_prestador_medico_w, ie_situacao_w,
			nr_seq_prestador_pgto_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, null,
			null, null, null);
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
-- REVOKE ALL ON PROCEDURE baca_pls_atualizar_prest_pgto ( nm_usuario_p text) FROM PUBLIC;

