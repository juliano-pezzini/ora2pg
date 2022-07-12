-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_inconsistencia ( nr_seq_fornecedor_p bigint) RETURNS varchar AS $body$
DECLARE


ie_consistido_w	varchar(3);


BEGIN
if (nr_seq_fornecedor_p IS NOT NULL AND nr_seq_fornecedor_p::text <> '') then
	begin
	select	max(ie_tipo_inconsistencia)
	into STRICT	ie_consistido_w
	from	pls_fornec_mat_fed_sc_inc
	where	nr_seq_fornecedor = nr_seq_fornecedor_p;
	end;
end if;
return	ie_consistido_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_inconsistencia ( nr_seq_fornecedor_p bigint) FROM PUBLIC;

