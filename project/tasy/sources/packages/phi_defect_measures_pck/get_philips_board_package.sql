-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION phi_defect_measures_pck.get_philips_board ( nr_seq_gerencia_p bigint, ie_opcao_p text default 'C') RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p = 'C' returns the Philips board sequence, otherwise returns the description*/

nr_seq_diretoria_w	diretoria_philips.nr_sequencia%type;
ds_diretoria_w		diretoria_philips.ds_diretoria%type;
nr_seq_gerencia_w	gerencia_wheb.nr_sequencia%type  := nr_seq_gerencia_p;
ds_retorno_w		varchar(255);


BEGIN

if (nr_seq_gerencia_w IS NOT NULL AND nr_seq_gerencia_w::text <> '') then

	select	dp.nr_sequencia,
		dp.ds_diretoria
	into STRICT	nr_seq_diretoria_w,
		ds_diretoria_w
	from	gerencia_wheb gw,
		diretoria_philips dp
	where	gw.nr_seq_diretoria = dp.nr_sequencia
	 and	gw.nr_sequencia = nr_seq_gerencia_w;

	if (ie_opcao_p	= 'C') then
		ds_retorno_w	:= nr_seq_diretoria_w;
	else
		ds_retorno_w	:= ds_diretoria_w;
	end if;
end if;

return	ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_defect_measures_pck.get_philips_board ( nr_seq_gerencia_p bigint, ie_opcao_p text default 'C') FROM PUBLIC;