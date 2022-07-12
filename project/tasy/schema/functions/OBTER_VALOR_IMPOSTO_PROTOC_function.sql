-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_imposto_protoc ( NR_SEQ_PROTOCOLO_P bigint) RETURNS bigint AS $body$
DECLARE



vl_procedimento_w 	double precision;
vl_material_w  		double precision;
vl_base_sem_imposto_w 	double precision;
vl_base_com_imposto_w 	double precision;
vl_imposto_w  		double precision := 0;


BEGIN

if (philips_param_pck.get_cd_pais = 2) then


 select 	sum(coalesce(a.vl_imposto_proc,0)) + sum(coalesce(a.vl_imposto_mat,0))
 into STRICT 	vl_imposto_w
 from (	SELECT 	sum(coalesce(y.vl_imposto,0)) vl_imposto_proc,
		0 vl_imposto_mat
	from 	procedimento_paciente x,
		propaci_imposto y,
		conta_paciente w
	where 	x.nr_interno_conta  = w.nr_interno_conta
	and 	w.nr_seq_protocolo = nr_seq_protocolo_p
	and 	y.nr_seq_propaci  = x.nr_sequencia
	
union all

	SELECT 	0 vl_imposto_proc,
		sum(coalesce(y.vl_imposto,0)) vl_imposto_mat
	from 	material_atend_paciente x,
		matpaci_imposto y,
		conta_paciente w
	where 	x.nr_interno_conta  	= w.nr_interno_conta
	and	 w.nr_seq_protocolo	= nr_seq_protocolo_p
	and 	y.nr_seq_matpaci  	= x.nr_sequencia) a;


end if;

return coalesce(vl_imposto_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_imposto_protoc ( NR_SEQ_PROTOCOLO_P bigint) FROM PUBLIC;

