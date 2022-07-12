-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_telefone_contato (nr_seq_contato_p bigint, ie_tipo_telefone_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(100);
nr_seq_complemento_w		bigint;



BEGIN

if (ie_tipo_telefone_p	= 0) then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_complemento_w
	from	usuario_contato_end
	where	nr_seq_contato		= nr_seq_contato_p
	and	ie_tipo_complemento 	= ie_tipo_telefone_p
	and	(nr_telefone IS NOT NULL AND nr_telefone::text <> '');

	select	nr_telefone
	into STRICT	ds_retorno_w
	from	usuario_contato_end
	where	nr_sequencia	= nr_seq_complemento_w;

	end;
elsif (ie_tipo_telefone_p	= 1) then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_complemento_w
	from	usuario_contato_end
	where	nr_seq_contato		= nr_seq_contato_p
	and	ie_tipo_complemento 	= ie_tipo_telefone_p
	and	(nr_telefone IS NOT NULL AND nr_telefone::text <> '');

	select	nr_telefone
	into STRICT	ds_retorno_w
	from	usuario_contato_end
	where	nr_sequencia	= nr_seq_complemento_w;

	end;
end if;

return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_telefone_contato (nr_seq_contato_p bigint, ie_tipo_telefone_p bigint) FROM PUBLIC;

