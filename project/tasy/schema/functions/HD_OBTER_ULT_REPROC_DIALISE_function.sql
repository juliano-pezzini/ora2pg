-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_ult_reproc_dialise (nr_seq_dialise_p bigint, nr_seq_dialise_dialis_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


dt_dialise_w			timestamp;
nr_seq_dialisador_rep_w		bigint;
nr_seq_reproc_w			bigint;
ds_retorno_w			varchar(255);
nr_seq_dialisador_w		bigint;
ie_manual_w			varchar(1);


BEGIN

select 	max(dt_dialise)
into STRICT	dt_dialise_w
from	hd_dialise
where	nr_sequencia = nr_seq_dialise_p;

select 	max(nr_seq_dialisador)
into STRICT	nr_seq_dialisador_w
from	hd_dialise_dialisador
where 	nr_sequencia = nr_seq_dialise_dialis_p;

if (dt_dialise_w IS NOT NULL AND dt_dialise_w::text <> '') then

	select 	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_dialisador_rep_w
	from	hd_dialisador_reproc
	where	dt_fim	<= dt_dialise_w
	and	coalesce(ie_situacao,'S') <> 'I'
	and	nr_seq_dialisador = nr_seq_dialisador_w;

	if (nr_seq_dialisador_rep_w > 0) then

		select 	nr_seq_reproc,
			ie_manual
		into STRICT	nr_seq_reproc_w,
			ie_manual_w
		from	hd_dialisador_reproc a,
			hd_reproc_dializador b
		where 	a.nr_sequencia = nr_seq_dialisador_rep_w
		and	coalesce(a.ie_situacao,'S') <> 'I'
		and	b.nr_sequencia = a.nr_seq_reproc;

	end if;

end if;

if (ie_opcao_p = 'R') then
	ds_retorno_w	:= nr_seq_reproc_w;
end if;

if (ie_opcao_p = 'I') then
	ds_retorno_w	:= ie_manual_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_ult_reproc_dialise (nr_seq_dialise_p bigint, nr_seq_dialise_dialis_p bigint, ie_opcao_p text) FROM PUBLIC;

