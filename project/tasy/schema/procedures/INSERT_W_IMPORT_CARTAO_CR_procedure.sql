-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_w_import_cartao_cr ( nm_usuario_p text, ds_conteudo_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_sequencia_w
from	w_import_cartao_cr;

insert	into	w_import_cartao_cr(
						nr_sequencia,
						ds_conteudo,
						dt_atualizacao,
						dt_atualizacao_nrec,
						nm_usuario,
						nm_usuario_nrec)
		values (nr_sequencia_w,
						substr(ds_conteudo_p,1,4000),
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_w_import_cartao_cr ( nm_usuario_p text, ds_conteudo_p text) FROM PUBLIC;

