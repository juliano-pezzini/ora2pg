-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_area_imagem_item ( nr_seq_area_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_retorno_w	bigint;

BEGIN

if (ie_tipo_item_p	= 'F') then
	select	max(NR_SEQ_LOCALIZACAO)
	into STRICT	nr_seq_retorno_w
	from	AREA_IMAGEM_ITEM
	where	nr_seq_area	= nr_seq_area_p
	and	ie_tipo_item	= ie_tipo_item_p;
end if;


return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_area_imagem_item ( nr_seq_area_p bigint, ie_tipo_item_p text) FROM PUBLIC;

