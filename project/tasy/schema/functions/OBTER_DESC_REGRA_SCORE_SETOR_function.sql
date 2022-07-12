-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_regra_score_setor ( nr_seq_flex_p bigint, ie_complexidade_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000)	:= '';
ds_escala_flex_w		varchar(255);
ds_escala_w		varchar(255);



BEGIN


if (nr_seq_flex_p IS NOT NULL AND nr_seq_flex_p::text <> '') then

	if ( ie_complexidade_p = 'SFII') then

		select	max(ds_escala)
		into STRICT	ds_escala_flex_w
		from	eif_escala_ii
		where	nr_sequencia = nr_seq_flex_p;

	else

		select	max(ds_escala)
		into STRICT	ds_escala_flex_w
		from	eif_escala
		where	nr_sequencia = nr_seq_flex_p;

	end if;

	ds_retorno_w := ds_escala_flex_w;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_regra_score_setor ( nr_seq_flex_p bigint, ie_complexidade_p text) FROM PUBLIC;
