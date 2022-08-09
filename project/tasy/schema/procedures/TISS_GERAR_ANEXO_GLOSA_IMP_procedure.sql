-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_anexo_glosa_imp (nm_usuario_p text, nr_seq_guia_p bigint, nr_seq_item_p bigint, cd_motivo_glosa_p text, ds_motivo_glosa_p text) AS $body$
DECLARE


nr_seq_glosa_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_glosa_w
from	tiss_motivo_glosa
where	cd_motivo_tiss	= cd_motivo_glosa_p;

insert into TISS_ANEXO_GUIA_GLOSA_IMP(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_guia_imp,
	nr_seq_item_guia_imp,
	nr_seq_motivo_glosa,
	ds_motivo_glosa)
values (nextval('tiss_anexo_guia_glosa_imp_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_guia_p,
	nr_seq_item_p,
	nr_seq_glosa_w,
	ds_motivo_glosa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_anexo_glosa_imp (nm_usuario_p text, nr_seq_guia_p bigint, nr_seq_item_p bigint, cd_motivo_glosa_p text, ds_motivo_glosa_p text) FROM PUBLIC;
