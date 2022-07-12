-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cooperado_crm (nr_seq_cooperado_p bigint, nr_crm_p text) RETURNS varchar AS $body$
DECLARE


cd_pessoa_fisica_w 	varchar(10);
nr_crm_w		varchar(20);
nr_seq_cooperado_w	bigint;
cd_retorno_w		varchar(20)	:= null;


BEGIN

if (nr_seq_cooperado_p IS NOT NULL AND nr_seq_cooperado_p::text <> '') then
	select	max(b.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pls_lote_escrit_quota_item a,
		pls_cooperado b
	where	a.nr_seq_cooperado = nr_seq_cooperado_p
	and	a.nr_seq_cooperado = b.nr_sequencia;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select	max(a.nr_crm)
		into STRICT	cd_retorno_w
		from	medico a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
elsif (nr_crm_p IS NOT NULL AND nr_crm_p::text <> '') then
	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	medico a
	where	a.nr_crm	= nr_crm_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select	max(a.nr_sequencia)
		into STRICT	cd_retorno_w
		from	pls_cooperado a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
end if;

return	cd_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cooperado_crm (nr_seq_cooperado_p bigint, nr_crm_p text) FROM PUBLIC;

