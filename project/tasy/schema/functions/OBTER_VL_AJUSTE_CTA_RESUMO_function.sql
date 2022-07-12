-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_ajuste_cta_resumo ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_resumo_p bigint, vl_liberado_p bigint, vl_apresentado_p bigint, vl_calculado_p bigint, vl_glosa_p bigint) RETURNS bigint AS $body$
DECLARE


vl_ajuste_w		double precision;
vl_apresentado_w	double precision;
vl_base_item_w		double precision;
vl_base_conta_w		double precision;
vl_calculado_w		double precision;
vl_liberado_w		double precision;
vl_provisao_w		double precision;


BEGIN

if (coalesce(nr_seq_conta_proc_p,0) <> 0) then

	select	vl_provisao,
		vl_liberado,
		vl_procedimento_imp,
		vl_procedimento
	into STRICT	vl_provisao_w,
		vl_liberado_w,
		vl_apresentado_w,
		vl_calculado_w
	from	pls_conta_proc
	where	nr_sequencia = nr_seq_conta_proc_p;

elsif (coalesce(nr_seq_conta_mat_p,0) <> 0) then

	select	vl_provisao,
		vl_liberado,
		vl_material_imp,
		vl_material
	into STRICT	vl_provisao_w,
		vl_liberado_w,
		vl_apresentado_w,
		vl_calculado_w
	from	pls_conta_mat
	where	nr_sequencia = nr_seq_conta_mat_p;

end if;

select	CASE WHEN coalesce(vl_liberado_p,0)=0 THEN (CASE WHEN coalesce(vl_apresentado_p,0)=0 THEN coalesce(vl_calculado_p,0)  ELSE vl_apresentado_p END )  ELSE vl_liberado_p END
into STRICT	vl_base_item_w
;

select	CASE WHEN coalesce(vl_liberado_w,0)=0 THEN (CASE WHEN coalesce(vl_apresentado_w,0)=0 THEN coalesce(vl_calculado_w,0)  ELSE vl_apresentado_w END )  ELSE vl_liberado_w END
into STRICT	vl_base_conta_w
;

vl_ajuste_w := 0;

if (coalesce(vl_provisao_w,0) <> 0) and (coalesce(vl_base_conta_w,0) <> 0) then
	vl_ajuste_w := (vl_liberado_p + vl_glosa_p) - dividir(vl_provisao_w * vl_base_item_w, vl_base_conta_w);
end if;

return	vl_ajuste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_ajuste_cta_resumo ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_resumo_p bigint, vl_liberado_p bigint, vl_apresentado_p bigint, vl_calculado_p bigint, vl_glosa_p bigint) FROM PUBLIC;

