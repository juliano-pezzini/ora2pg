-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_quant_autor_proc_mat (nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, ie_mat_proc_p text) RETURNS varchar AS $body$
DECLARE


qt_autorizada_w		double precision;
ds_retorno_w		varchar(255);


BEGIN

qt_autorizada_w	:= 0;

if (ie_mat_proc_p = 'P') and (nr_seq_guia_proc_p IS NOT NULL AND nr_seq_guia_proc_p::text <> '')  then

	select	coalesce(max(qt_autorizada),0)
	into STRICT	qt_autorizada_w
	from	pls_guia_plano_proc
	where	nr_sequencia	= nr_seq_guia_proc_p
	and	not(ie_status	in ('N','M'));


elsif (ie_mat_proc_p = 'M') and (nr_seq_guia_mat_p IS NOT NULL AND nr_seq_guia_mat_p::text <> '')  then

	select	coalesce(max(qt_autorizada),0)
	into STRICT	qt_autorizada_w
	from	pls_guia_plano_mat
	where	nr_sequencia	= nr_seq_guia_mat_p;

end if;

ds_retorno_w	:= qt_autorizada_w;
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_quant_autor_proc_mat (nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, ie_mat_proc_p text) FROM PUBLIC;

