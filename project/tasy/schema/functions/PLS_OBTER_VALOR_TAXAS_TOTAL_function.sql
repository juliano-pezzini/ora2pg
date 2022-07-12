-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_taxas_total (nr_seq_conta_proc_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

/*IE_TIPO_IMP
I = campos imp
C = campos sem imp*/
vl_total_w			double precision;
vl_taxa_servico_imp_w		double precision;
vl_taxa_co_imp_w		double precision;
vl_taxa_material_imp_w		double precision;
vl_taxa_servico_w		double precision;
vl_taxa_co_w			double precision;
vl_taxa_material_w		double precision;

BEGIN

if (ie_tipo_p = 'I')	then
	select 	coalesce(vl_taxa_servico_imp,0),
		coalesce(vl_taxa_co_imp,0),
		coalesce(vl_taxa_material_imp,0)
	into STRICT	vl_taxa_servico_imp_w,
		vl_taxa_co_imp_w,
		vl_taxa_material_imp_w
	from 	pls_conta_proc
	where 	nr_sequencia = nr_seq_conta_proc_p;

	vl_total_w	:= coalesce(vl_taxa_servico_imp_w,0) + coalesce(vl_taxa_co_imp_w,0) + coalesce(vl_taxa_material_imp_w,0);
elsif (ie_tipo_p = 'C')	then
	select 	coalesce(vl_taxa_servico,0),
		coalesce(vl_taxa_co,0),
		coalesce(vl_taxa_material,0)
	into STRICT	vl_taxa_servico_w,
		vl_taxa_co_w,
		vl_taxa_material_w
	from 	pls_conta_proc
	where 	nr_sequencia = nr_seq_conta_proc_p;

	vl_total_w	:= coalesce(vl_taxa_servico_w,0) + coalesce(vl_taxa_co_w,0) + coalesce(vl_taxa_material_w,0);
end if;

return	vl_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_taxas_total (nr_seq_conta_proc_p bigint, ie_tipo_p text) FROM PUBLIC;
