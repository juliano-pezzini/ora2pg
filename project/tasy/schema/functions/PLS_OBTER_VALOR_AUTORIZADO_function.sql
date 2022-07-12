-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_autorizado ( nr_seq_guia_p pls_conta.nr_seq_guia%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type) RETURNS PLS_GUIA_PLANO_MAT.VL_MATERIAL%TYPE AS $body$
DECLARE


vl_autorizado_w		pls_guia_plano_mat.vl_material%type;
qt_autorizada_w		integer;


BEGIN

select	max(b.vl_material),
	max(b.qt_autorizada)
into STRICT	vl_autorizado_w,
	qt_autorizada_w
from	pls_guia_plano_mat b
where	b.nr_seq_guia = nr_seq_guia_p
and	b.nr_seq_material = nr_seq_material_p
and	b.ie_status in ('S','L','P')
and	b.vl_material > 0
and	exists (SELECT 	1
		from	pls_guia_plano a
		where	a.nr_sequencia = nr_seq_guia_p
		and	(a.dt_autorizacao IS NOT NULL AND a.dt_autorizacao::text <> ''));

if (coalesce(qt_autorizada_w::text, '') = '' or qt_autorizada_w = 0) then

	select	max(vl_material)
	into STRICT	vl_autorizado_w
	from	pls_guia_plano a,
		pls_guia_plano_mat b
	where	a.nr_seq_guia_principal = nr_seq_guia_p
	and	(a.dt_autorizacao IS NOT NULL AND a.dt_autorizacao::text <> '')
	and	b.nr_seq_guia = a.nr_sequencia
	and	b.nr_seq_material = nr_seq_material_p
	and	b.ie_status in ('S','L','P')
	and	b.vl_material > 0;
end if;

return	coalesce(vl_autorizado_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_autorizado ( nr_seq_guia_p pls_conta.nr_seq_guia%type, nr_seq_material_p pls_conta_mat.nr_seq_material%type) FROM PUBLIC;

