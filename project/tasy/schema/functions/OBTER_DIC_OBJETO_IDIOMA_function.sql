-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dic_objeto_idioma ( nr_seq_objeto_p bigint, nr_seq_idioma_p bigint) RETURNS varchar AS $body$
DECLARE


ds_objeto_w		varchar(2000);
ie_tipo_objeto_w	varchar(15);

BEGIN

if (coalesce(nr_seq_objeto_p::text, '') = '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(279673);
end if;

if (nr_seq_idioma_p IS NOT NULL AND nr_seq_idioma_p::text <> '') and (nr_seq_idioma_p > 0) then
	select	max(ds_traducao)
	into STRICT	ds_objeto_w
	from	dic_objeto_idioma
	where	nr_seq_objeto = nr_seq_objeto_p
	and	nr_seq_idioma = nr_seq_idioma_p;

	if (ds_objeto_w IS NOT NULL AND ds_objeto_w::text <> '') and (ds_objeto_w <> ' ') then
		return	ds_objeto_w;
	end if;
end if;

select	ie_tipo_objeto
into STRICT	ie_tipo_objeto_w
from	dic_objeto
where	nr_sequencia = nr_seq_objeto_p;

if (ie_tipo_objeto_w = 'T') then
	select	ds_informacao
	into STRICT	ds_objeto_w
	from	dic_objeto
	where	nr_sequencia = nr_seq_objeto_p;
elsif (ie_tipo_objeto_w = 'AC') then
	select	nm_campo_tela
	into STRICT	ds_objeto_w
	from	dic_objeto
	where	nr_sequencia = nr_seq_objeto_p;
else
	select	ds_texto
	into STRICT	ds_objeto_w
	from	dic_objeto
	where	nr_sequencia = nr_seq_objeto_p;
end if;

return	ds_objeto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dic_objeto_idioma ( nr_seq_objeto_p bigint, nr_seq_idioma_p bigint) FROM PUBLIC;
