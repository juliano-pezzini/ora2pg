-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_cid_interno ( cd_doenca_cid_p text, nr_seq_diag_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(300);


BEGIN

if (nr_seq_diag_interno_p IS NOT NULL AND nr_seq_diag_interno_p::text <> '') then
	begin
	select	ds_diagnostico
	into STRICT	ds_retorno_w
	from	diagnostico_interno
	where	nr_sequencia	= nr_seq_diag_interno_p;
	end;
elsif (cd_doenca_cid_p IS NOT NULL AND cd_doenca_cid_p::text <> '') then
	begin
	select	ds_doenca_cid
	into STRICT	ds_retorno_w
	from	cid_doenca
	where	cd_doenca_cid	= cd_doenca_cid_p;
	end;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_cid_interno ( cd_doenca_cid_p text, nr_seq_diag_interno_p bigint) FROM PUBLIC;
