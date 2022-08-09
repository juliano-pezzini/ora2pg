-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adicionar_pasta_tree_query_dar ( nr_seq_pai_p tree_query_dar.nr_seq_pai%TYPE, ie_tipo_p tree_query_dar.ie_tipo%TYPE, ds_titulo_p tree_query_dar.ds_titulo%TYPE) AS $body$
DECLARE


	nr_seq_ordem_w        tree_query_dar.nr_seq_ordem_apres%TYPE;
	nr_seq_superior_w     tree_query_dar.nr_seq_ordem_apres%TYPE;


BEGIN

select coalesce(max(nr_seq_ordem_apres), 0) + 1 into STRICT nr_seq_ordem_w from tree_query_dar where nr_seq_pai = nr_seq_pai_p;
select max(nr_sequencia)+1 into STRICT nr_seq_superior_w from tree_query_dar;

insert into tree_query_dar(
	nr_sequencia,
    nm_usuario,
    dt_atualizacao,
    nr_seq_pai,
    ie_tipo,
    ds_titulo,
	nr_seq_ordem_apres)
values (
	nextval('tree_query_dar_seq'),
	wheb_usuario_pck.get_nm_usuario,
	clock_timestamp(),
	nr_seq_pai_p,
	ie_tipo_p,
	ds_titulo_p,
	nr_seq_ordem_w
	);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adicionar_pasta_tree_query_dar ( nr_seq_pai_p tree_query_dar.nr_seq_pai%TYPE, ie_tipo_p tree_query_dar.ie_tipo%TYPE, ds_titulo_p tree_query_dar.ds_titulo%TYPE) FROM PUBLIC;
