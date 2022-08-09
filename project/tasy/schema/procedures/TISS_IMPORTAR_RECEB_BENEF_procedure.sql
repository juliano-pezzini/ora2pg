-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_importar_receb_benef (nm_usuario_p text, nr_seq_comunic_p bigint, ie_status_p text, cd_motivo_glosa_p text, ds_erro_p text) AS $body$
DECLARE


nr_seq_motivo_glosa_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_motivo_glosa_w
from	tiss_motivo_glosa
where	cd_motivo_tiss	= cd_motivo_glosa_p;

insert into TISS_COMUNIC_BENIF_RECIBO(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_comunic,
	dt_recebimento,
	ie_recebido,
	nr_seq_motivo_glosa,
	ds_erro)
values (nextval('tiss_comunic_benif_recibo_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_comunic_p,
	clock_timestamp(),
	ie_status_p,
	nr_seq_motivo_glosa_w,
	ds_erro_p);

if (ie_status_p = 'S') then
	update	tiss_comunic_benif
	set	ie_status	= 'R'
	where	nr_sequencia	= nr_seq_comunic_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_importar_receb_benef (nm_usuario_p text, nr_seq_comunic_p bigint, ie_status_p text, cd_motivo_glosa_p text, ds_erro_p text) FROM PUBLIC;
