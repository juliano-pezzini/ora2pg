-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_cor_estag_autorizacao ( nr_seq_estagio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_estagio_w varchar(15);

BEGIN
if (nr_seq_estagio_p IS NOT NULL AND nr_seq_estagio_p::text <> '') then
	begin
	select	ds_cor
	into STRICT	ds_cor_estagio_w
	from	estagio_autorizacao
	where	nr_sequencia = nr_seq_estagio_p;
	end;
end if;
return ds_cor_estagio_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_cor_estag_autorizacao ( nr_seq_estagio_p bigint) FROM PUBLIC;

