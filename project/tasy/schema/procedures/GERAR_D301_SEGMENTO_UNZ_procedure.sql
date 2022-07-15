-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_unz ( nr_seq_arquivo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		d301_segmento_unz.nr_sequencia%type;
d301_segmento_unz_w	d301_segmento_unz%rowtype;
qt_dataset_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_dataset_w
from	d301_dataset_conteudo a
where	a.nr_seq_dataset in (SELECT	x.nr_sequencia
	from	d301_dataset_envio x
	where	x.nr_seq_arquivo	= nr_seq_arquivo_p);

select	nextval('d301_segmento_unz_seq')
into STRICT	nr_sequencia_w
;

d301_segmento_unz_w.nr_sequencia	:= nr_sequencia_w;
d301_segmento_unz_w.dt_atualizacao	:= clock_timestamp();
d301_segmento_unz_w.nm_usuario		:= nm_usuario_p;
d301_segmento_unz_w.dt_atualizacao_nrec	:= clock_timestamp();
d301_segmento_unz_w.nm_usuario_nrec	:= nm_usuario_p;
d301_segmento_unz_w.qt_dataset		:= qt_dataset_w;
d301_segmento_unz_w.nr_ref_arquivo	:= lpad(nr_seq_arquivo_p,5,'0');
d301_segmento_unz_w.nr_seq_arquivo	:= nr_seq_arquivo_p;

insert into d301_segmento_unz values (d301_segmento_unz_w.*);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_unz ( nr_seq_arquivo_p bigint, nm_usuario_p text) FROM PUBLIC;

