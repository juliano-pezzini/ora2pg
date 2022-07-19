-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_glosa_eleg (cd_motivo_glosa_p text, nr_seq_elegibilidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_motivo_glosa_w		bigint;
qt_glosa_w			bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_motivo_glosa_w
from	tiss_motivo_glosa
where	cd_motivo_tiss	= cd_motivo_glosa_p;

if (nr_seq_motivo_glosa_w <> 0) then

	select	count(*)
	into STRICT	qt_glosa_w
	from	pls_eleg_glosa
	where	nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w
	and	nr_seq_elegibilidade	= nr_seq_elegibilidade_p;

	if (qt_glosa_w = 0) then

		insert into pls_eleg_glosa(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nr_seq_elegibilidade,
			nr_seq_motivo_glosa)
		values (nextval('pls_eleg_glosa_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_elegibilidade_p,
			nr_seq_motivo_glosa_w);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_glosa_eleg (cd_motivo_glosa_p text, nr_seq_elegibilidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

