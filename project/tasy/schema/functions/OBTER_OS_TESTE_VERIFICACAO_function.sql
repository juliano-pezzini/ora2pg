-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_os_teste_verificacao ( nr_seq_caso_teste_p bigint, ds_version_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(4000);
nr_seq_ordem_w  bigint;

  item RECORD;

BEGIN

	ds_retorno_w := '';
	nr_seq_ordem_w := 0;

	for item in (
		SELECT	distinct p.nr_seq_tc,
			o.nr_seq_service_order
		from	reg_tc_pendencies p,
			reg_tc_evidence_item i,
			reg_tc_so_pendencies o
		where	p.nr_sequencia = i.nr_seq_ect
		and	i.nr_sequencia = o.nr_seq_ev_item
		and	p.nr_seq_tc = nr_seq_caso_teste_p
		and	p.ds_version = ds_version_p
		order by	o.nr_seq_service_order
	) loop

		if (nr_seq_ordem_w <> item.nr_seq_service_order) then
			ds_retorno_w := ds_retorno_w || ', ' || item.nr_seq_service_order;
			nr_seq_ordem_w := item.nr_seq_service_order;
		end if;
	end loop;

	ds_retorno_w := substr(ds_retorno_w, 2, length(ds_retorno_w));

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_os_teste_verificacao ( nr_seq_caso_teste_p bigint, ds_version_p text ) FROM PUBLIC;

