-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_total_valor_guia ( nr_seq_guia_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_tipo_p
  G - Somente será somado os valores da guia que esta sendo passada pelo parâmetro
  A - Irá somar os valroes de todas as guias que pertencem ao mesmo atendimento, sendo a guia de internação e suas guias de prorrogação quando fizer referência a guai de internação.

*/
vl_total_retorno_w		double precision := 0;
vl_total_proc_w			double precision;
vl_total_mat_w			double precision;


BEGIN

if (ie_tipo_p = 'G') then
	select	sum(vl_procedimento)
	into STRICT	vl_total_proc_w
	from	pls_guia_plano_proc
	where	nr_seq_guia = nr_seq_guia_p;

	select	sum(vl_material)
	into STRICT	vl_total_mat_w
	from	pls_guia_plano_mat
	where	nr_seq_guia = nr_seq_guia_p;

	vl_total_retorno_w := coalesce(vl_total_proc_w,0) + coalesce(vl_total_mat_w,0);

elsif (ie_tipo_p = 'A') then

	select	sum(vl_procedimento)
	into STRICT	vl_total_proc_w
	from	pls_guia_plano_proc
	where	nr_seq_guia in (SELECT	nr_sequencia
				from	pls_guia_plano
				where (nr_sequencia = nr_seq_guia_p
				or	nr_seq_guia_principal = nr_seq_guia_p)
				and	ie_estagio	in (3,6,5,10));

	select	sum(vl_material)
	into STRICT	vl_total_mat_w
	from	pls_guia_plano_mat
	where	nr_seq_guia in (SELECT	nr_sequencia
				from	pls_guia_plano
				where (nr_sequencia = nr_seq_guia_p
				or	nr_seq_guia_principal = nr_seq_guia_p)
				and	ie_estagio	in (3,6,5,10));

	vl_total_retorno_w := coalesce(vl_total_proc_w,0) + coalesce(vl_total_mat_w,0);
end if;

return	vl_total_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_total_valor_guia ( nr_seq_guia_p bigint, ie_tipo_p text) FROM PUBLIC;
