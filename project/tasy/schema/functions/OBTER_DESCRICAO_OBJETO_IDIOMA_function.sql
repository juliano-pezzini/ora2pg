-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_objeto_idioma ( nr_seq_objeto_p bigint, nm_atributo_p text, nr_seq_idioma_p bigint) RETURNS varchar AS $body$
DECLARE


ds_traducao_w	varchar(255);


BEGIN
if (nr_seq_objeto_p IS NOT NULL AND nr_seq_objeto_p::text <> '') and (nm_atributo_p IS NOT NULL AND nm_atributo_p::text <> '') and (nr_seq_idioma_p IS NOT NULL AND nr_seq_idioma_p::text <> '') then
	begin
	select	max(ds_traducao)
	into STRICT	ds_traducao_w
	from	dic_objeto_idioma
	where	nr_seq_objeto = nr_seq_objeto_p
	and	nm_atributo = nm_atributo_p
	and	nr_seq_idioma = nr_seq_idioma_p;
	end;
end if;
return ds_traducao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_objeto_idioma ( nr_seq_objeto_p bigint, nm_atributo_p text, nr_seq_idioma_p bigint) FROM PUBLIC;

