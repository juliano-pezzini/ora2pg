-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_filtro_gpo_ans_monit ( cd_procedimento_p procedimento.cd_procedimento%type, nr_seq_material_p pls_material.nr_sequencia%type, ds_sql_p INOUT text) AS $body$
DECLARE


ds_sql_w		varchar(4000);
nr_seq_estrut_mat_w	pls_material.nr_seq_estrut_mat%type;
ie_tipo_despesa_w	pls_material.ie_tipo_despesa%type;


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then

	ds_sql_w :=	'	select	nr_seq_reg_gpo										' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc								' || pls_util_pck.enter_w ||
			'	where	cd_procedimento = ' || cd_procedimento_p 						  || pls_util_pck.enter_w ||
			'	union all											' || pls_util_pck.enter_w ||
			'	select	nr_seq_reg_gpo										' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc								' || pls_util_pck.enter_w ||
			'	where	ie_tipo_despesa_proc in (	SELECT	ie_classificacao				' || pls_util_pck.enter_w ||
			'						from	procedimento					' || pls_util_pck.enter_w ||
			'						where	cd_procedimento = ' || cd_procedimento_p || ')	' || pls_util_pck.enter_w ||
			'	union all											' || pls_util_pck.enter_w ||
			'	select	nr_seq_reg_gpo										' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc								' || pls_util_pck.enter_w ||
			'	where	CD_GRUPO_PROC in (	SELECT	cd_grupo_proc						' || pls_util_pck.enter_w ||
			'					from	procedimento						' || pls_util_pck.enter_w ||
			'					where	cd_procedimento = ' || cd_procedimento_p || ' )		' || pls_util_pck.enter_w ||
			'	union all											' || pls_util_pck.enter_w ||
			'	select	nr_seq_reg_gpo										' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc								' || pls_util_pck.enter_w ||
			'	where	cd_especialidade in (	SELECT	cd_especialidade					' || pls_util_pck.enter_w ||
			'					from	estrutura_procedimento_v				' || pls_util_pck.enter_w ||
			'					where	cd_procedimento = ' || cd_procedimento_p || ' )		';
elsif (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	select	nr_seq_estrut_mat,
		ie_tipo_despesa
	into STRICT	nr_seq_estrut_mat_w,
		ie_tipo_despesa_w
	from	pls_material
	where	nr_sequencia = nr_seq_material_p;

	ds_sql_w :=	'	select	nr_seq_reg_gpo				' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc		' || pls_util_pck.enter_w ||
			'	where	nr_seq_material = nr_seq_material_p	' || pls_util_pck.enter_w ||
			'	union all					' || pls_util_pck.enter_w ||
			'	select	nr_seq_reg_gpo				' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc		' || pls_util_pck.enter_w ||
			'	where	ie_tipo_despesa_mat = ie_tipo_despesa_w	' || pls_util_pck.enter_w ||
			'	union all					' || pls_util_pck.enter_w ||
			'	select	nr_seq_reg_gpo				' || pls_util_pck.enter_w ||
			'	from	pls_monitor_tiss_reg_proc		' || pls_util_pck.enter_w ||
			'	where	nr_seq_estrut_mat = nr_seq_estrut_mat_w	';
end if;

ds_sql_p := ds_sql_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_filtro_gpo_ans_monit ( cd_procedimento_p procedimento.cd_procedimento%type, nr_seq_material_p pls_material.nr_sequencia%type, ds_sql_p INOUT text) FROM PUBLIC;

