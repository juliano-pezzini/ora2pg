-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_seq_neg_lic ( nr_seq_cliente_p bigint, nr_seq_contrato_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_neg_lic_w	bigint;


BEGIN
if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') and (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
	begin
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_neg_lic_w
	from	com_cli_neg_lic
	where	nr_seq_cliente	= nr_seq_cliente_p
	and	nr_seq_contrato = nr_seq_contrato_p;
	end;
end if;
return nr_seq_neg_lic_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_seq_neg_lic ( nr_seq_cliente_p bigint, nr_seq_contrato_p bigint) FROM PUBLIC;

