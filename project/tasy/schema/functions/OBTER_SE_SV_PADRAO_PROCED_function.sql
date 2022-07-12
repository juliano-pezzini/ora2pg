-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sv_padrao_proced ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nr_seq_sinal_vital_p bigint) RETURNS varchar AS $body$
DECLARE

				
ds_retorno_w  varchar(1);
ie_existe_regra_proc_w varchar(1);


BEGIN

if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') or (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then

select	coalesce(max('S'), 'N'),
		coalesce(max(c.ie_padrao), 'S')
into STRICT	ie_existe_regra_proc_w,
		ds_retorno_w
from 	cirurgia b, pepo_sv_regra c
where	((b.nr_cirurgia = nr_cirurgia_p AND nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') or (b.nr_seq_pepo = nr_seq_pepo_p AND nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> ''))
and     b.nr_seq_proc_interno = c.nr_seq_proc_interno
and     c.nr_seq_sv = nr_seq_sinal_vital_p;
				
end if;

if (ie_existe_regra_proc_w = 'N') then
	ds_retorno_w := null;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sv_padrao_proced ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nr_seq_sinal_vital_p bigint) FROM PUBLIC;

