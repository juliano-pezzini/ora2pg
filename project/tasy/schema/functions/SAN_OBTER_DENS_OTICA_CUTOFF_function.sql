-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_dens_otica_cutoff (nr_densidade_otica_p bigint, ds_densidade_otica_p text, nr_cutoff_p bigint, ds_cutoff_p text, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
nr_densidade_otica_w	varchar(255);
nr_cutoff_w		varchar(255);
ds_densidade_otica_w	varchar(255);
ds_cutoff_w		varchar(255);


BEGIN

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (nr_densidade_otica_p IS NOT NULL AND nr_densidade_otica_p::text <> '') then

	select	CASE WHEN MAX(nr_seq_exame_p)='8' THEN  'ABS: '||MAX(nr_densidade_otica_p) WHEN MAX(nr_seq_exame_p)='9' THEN  'ABS: '||MAX(nr_densidade_otica_p)  ELSE '' END
	into STRICT	nr_densidade_otica_w
	;

	ds_retorno_w := nr_densidade_otica_w;

end if;

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (nr_cutoff_p IS NOT NULL AND nr_cutoff_p::text <> '') then

	select	CASE WHEN MAX(nr_seq_exame_p)='8' THEN  'CUT OFF: '||MAX(nr_cutoff_p) WHEN MAX(nr_seq_exame_p)='9' THEN  'CUT OFF: '||MAX(nr_cutoff_p)  ELSE '' END
	into STRICT	nr_cutoff_w
	;

	ds_retorno_w := nr_cutoff_w;

end if;

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (ds_densidade_otica_p IS NOT NULL AND ds_densidade_otica_p::text <> '') and (coalesce(nr_densidade_otica_p::text, '') = '') then

	select	CASE WHEN MAX(nr_seq_exame_p)='8' THEN  'ABS: '||MAX(ds_densidade_otica_p) WHEN MAX(nr_seq_exame_p)='9' THEN  'ABS: '||MAX(ds_densidade_otica_p)  ELSE '' END
	into STRICT	ds_densidade_otica_w
	;

	ds_retorno_w := ds_densidade_otica_w;

end if;

if (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') and (ds_cutoff_p IS NOT NULL AND ds_cutoff_p::text <> '') and (coalesce(nr_cutoff_p::text, '') = '') then

	select	CASE WHEN MAX(nr_seq_exame_p)='8' THEN  'CUT OFF: '||MAX(ds_cutoff_p) WHEN MAX(nr_seq_exame_p)='9' THEN  'CUT OFF: '||MAX(ds_cutoff_p)  ELSE '' END
	into STRICT	ds_cutoff_w
	;

	ds_retorno_w := ds_cutoff_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_dens_otica_cutoff (nr_densidade_otica_p bigint, ds_densidade_otica_p text, nr_cutoff_p bigint, ds_cutoff_p text, nr_seq_exame_p bigint) FROM PUBLIC;

