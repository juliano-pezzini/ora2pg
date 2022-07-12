-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_repasse_item_med ( nr_sequencia_p bigint, cd_medico_p bigint, ie_proc_mat_p text) RETURNS bigint AS $body$
DECLARE


vl_lib_proc_w		double precision;
vl_lib_mat_w		double precision;
vl_rep_proc_w		double precision;
vl_rep_mat_w		double precision;

vl_repasse_w		double precision;


BEGIN

vl_repasse_w		:= 0;

if (ie_proc_mat_p = 'P') then
	select	sum(vl_repasse)
	into STRICT	vl_rep_proc_w
	from 	procedimento_repasse
	where 	nr_seq_procedimento = nr_sequencia_p
	and	cd_medico = coalesce(cd_medico_p,cd_medico);

	vl_repasse_w := vl_rep_proc_w;

elsif (ie_proc_mat_p = 'PL') then
	select	sum(CASE WHEN ie_status='L' THEN vl_liberado  ELSE CASE WHEN ie_status='S' THEN vl_liberado  ELSE CASE WHEN ie_status='R' THEN vl_liberado  ELSE CASE WHEN ie_status='E' THEN vl_repasse  ELSE 0 END  END  END  END )
	into STRICT	vl_lib_proc_w
	from 	procedimento_repasse
	where 	nr_seq_procedimento = nr_sequencia_p
	and	(nr_repasse_terceiro IS NOT NULL AND nr_repasse_terceiro::text <> '')
	and	cd_medico = coalesce(cd_medico_p,cd_medico);

	vl_repasse_w := vl_lib_proc_w;

elsif (ie_proc_mat_p = 'M') then
	select	sum(vl_repasse)
	into STRICT	vl_rep_mat_w
	from 	material_repasse
	where 	nr_seq_material	= nr_sequencia_p
	and	cd_medico = coalesce(cd_medico_p,cd_medico);

	vl_repasse_w := vl_rep_mat_w;

elsif (ie_proc_mat_p = 'ML') then
	select	sum(CASE WHEN ie_status='L' THEN vl_liberado  ELSE CASE WHEN ie_status='S' THEN vl_liberado  ELSE CASE WHEN ie_status='R' THEN vl_liberado  ELSE CASE WHEN ie_status='E' THEN vl_repasse  ELSE 0 END  END  END  END )
	into STRICT	vl_lib_mat_w
	from 	material_repasse
	where 	nr_seq_material	= nr_sequencia_p
	and	(nr_repasse_terceiro IS NOT NULL AND nr_repasse_terceiro::text <> '')
	and	cd_medico = coalesce(cd_medico_p,cd_medico);

	vl_repasse_w := vl_lib_mat_w;
end if;

RETURN coalesce(vl_repasse_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_repasse_item_med ( nr_sequencia_p bigint, cd_medico_p bigint, ie_proc_mat_p text) FROM PUBLIC;
