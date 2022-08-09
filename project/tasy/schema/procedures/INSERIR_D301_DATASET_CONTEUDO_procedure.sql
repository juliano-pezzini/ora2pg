-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_d301_dataset_conteudo (nm_usuario_p text, nr_seq_dataset_p bigint, ds_conteudo_p text) AS $body$
DECLARE


nr_ordem_w		integer;
nr_seq_arquivo_w	bigint;


BEGIN

select	coalesce(max(nr_seq_arquivo),0)
into STRICT	nr_seq_arquivo_w
from	d301_dataset_envio
where	nr_sequencia	= nr_seq_dataset_p;

select 	coalesce(max(a.nr_ordem),0)
into STRICT	nr_ordem_w
from	d301_dataset_conteudo a
where	a.nr_seq_dataset in (SELECT	b.nr_sequencia
	from	d301_dataset_envio b
	where	b.nr_seq_arquivo = nr_seq_arquivo_w);

insert into d301_dataset_conteudo(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_conteudo,
	nr_seq_dataset,
	nr_ordem)
values (nextval('d301_dataset_conteudo_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_conteudo_p,
	nr_seq_dataset_p,
	nr_ordem_w + 1);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_d301_dataset_conteudo (nm_usuario_p text, nr_seq_dataset_p bigint, ds_conteudo_p text) FROM PUBLIC;
