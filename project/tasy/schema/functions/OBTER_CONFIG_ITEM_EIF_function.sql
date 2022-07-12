-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_config_item_eif ( nr_seq_item_p bigint, ie_tipo_config_p text) RETURNS varchar AS $body$
DECLARE


/*
 N - Negrito
 C - Cor fonte
 F - Cor fundo
*/
ie_negrito_w	varchar(1);
ds_cor_fonte_w	varchar(15);
ds_cor_fundo_w	varchar(15);


BEGIN

select  coalesce(ie_negrito,'N'),
		ds_cor_fonte,
		ds_cor_fundo
into STRICT	ie_negrito_w,
		ds_cor_fonte_w,
		ds_cor_fundo_w
from	eif_escala_item
where	nr_sequencia = nr_seq_item_p
and 	coalesce(ie_titulo,'N') = 'S';

if (ie_tipo_config_p = 'N') then
	return ie_negrito_w;
elsif (ie_tipo_config_p = 'C') then
	return ds_cor_fonte_w;
elsif (ie_tipo_config_p = 'F') then
	return ds_cor_fundo_w;
end if;

return '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_config_item_eif ( nr_seq_item_p bigint, ie_tipo_config_p text) FROM PUBLIC;

