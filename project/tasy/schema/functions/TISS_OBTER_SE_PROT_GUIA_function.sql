-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_se_prot_guia (nr_seq_prot_guia_p bigint, nr_seq_conta_guia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_cgc_w		varchar(255);
cd_interno_w		varchar(255);
cd_cgc_compl_w		varchar(255);
cd_interno_compl_w	varchar(255);
cont_w			bigint;
cd_interno_honor_w	varchar(255);
nr_cpf_honor_w		varchar(255);


BEGIN

select	cd_cgc,
	cd_interno,
	cd_cgc_compl,
	cd_interno_compl,
	cd_interno_honor,
	nr_cpf_honor
into STRICT	cd_cgc_w,
	cd_interno_w,
	cd_cgc_compl_w,
	cd_interno_compl_w,
	cd_interno_honor_w,
	nr_cpf_honor_w
from	tiss_protocolo_guia
where	nr_sequencia	= nr_seq_prot_guia_p;

ds_retorno_w	:= 'S';
if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') or (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') or (cd_cgc_compl_w IS NOT NULL AND cd_cgc_compl_w::text <> '') or (cd_interno_compl_w IS NOT NULL AND cd_interno_compl_w::text <> '') or (cd_interno_honor_w IS NOT NULL AND cd_interno_honor_w::text <> '') or (nr_cpf_honor_w IS NOT NULL AND nr_cpf_honor_w::text <> '')  then

	select	count(*)
	into STRICT	cont_w
	from	tiss_conta_contrat_exec
	where	nr_seq_guia			= nr_seq_conta_guia_p
	and	coalesce(cd_cgc, 'X')		= coalesce(cd_cgc_w, coalesce(cd_cgc, 'X'))
	and	coalesce(cd_interno, 'X')		= coalesce(cd_interno_w, coalesce(cd_interno, 'X'))
	and	coalesce(cd_cgc_compl, 'X')		= coalesce(cd_cgc_compl_w, coalesce(cd_cgc_compl, 'X'))
	and	coalesce(cd_interno_compl, 'X')	= coalesce(cd_interno_compl_w, coalesce(cd_interno_compl, 'X'))
	and 	coalesce(cd_interno_honor, 'X')	= coalesce(cd_interno_honor_w, coalesce(cd_interno_honor, 'X'))
	and 	coalesce(nr_cpf_honor, 'X')		= coalesce(nr_cpf_honor_w, coalesce(nr_cpf_honor, 'X'));

	ds_retorno_w			:= 'N';
	if (cont_w > 0) then
		ds_retorno_w		:= 'S';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_se_prot_guia (nr_seq_prot_guia_p bigint, nr_seq_conta_guia_p bigint) FROM PUBLIC;
