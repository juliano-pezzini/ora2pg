-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_status_tratamentos (nr_seq_pac_reab_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);

nr_seq_tipo_tratamento_w	bigint;
nr_seq_status_w			bigint;

ds_tipo_tratamento_w	varchar(255);
ds_status_w		varchar(255);

C01 CURSOR FOR
	SELECT	nr_seq_tipo_tratamento,
		nr_seq_status
	from	rp_tratamento
	where	nr_seq_pac_reav = nr_seq_pac_reab_p
	and	coalesce(dt_fim_tratamento::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_tipo_tratamento_w,
	nr_seq_status_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_tipo_tratamento_w	:= rp_obter_tipo_tratamento(nr_seq_tipo_tratamento_w);
	ds_status_w		:= rp_obter_desc_status(nr_seq_status_w);

	ds_retorno_w := ds_retorno_w || ds_tipo_tratamento_w||' ('||ds_status_w||'); ';

	end;
end loop;
close C01;



return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_status_tratamentos (nr_seq_pac_reab_p bigint) FROM PUBLIC;

