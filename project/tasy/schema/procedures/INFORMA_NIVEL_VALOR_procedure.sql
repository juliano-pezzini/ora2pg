-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE informa_nivel_valor ( nr_ordem_serv_p bigint ) AS $body$
DECLARE


nr_seq_classif_w		bigint;
nr_seq_nivel_valor_w		bigint;
nr_seq_nivel_valor_ord_w	bigint;


BEGIN
	select	nr_seq_classif,
		nr_seq_nivel_valor
	into STRICT	nr_seq_classif_w,
		nr_seq_nivel_valor_ord_w
	from	man_ordem_servico
	where	nr_sequencia = nr_ordem_serv_p;

	if (nr_seq_classif_w IS NOT NULL AND nr_seq_classif_w::text <> '') then
		select	nr_seq_nivel_valor
		into STRICT	nr_seq_nivel_valor_w
		from	man_classificacao
		where	nr_sequencia = nr_seq_classif_w;

		update	man_ordem_servico
		set	nr_seq_nivel_valor = nr_seq_nivel_valor_w
		where	nr_sequencia = nr_ordem_serv_p;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE informa_nivel_valor ( nr_ordem_serv_p bigint ) FROM PUBLIC;
