-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_neo_matric_prontuario ( matricula_p text, cod_con_p text, cod_plan_p text, cod_prt_wpd_p text, cod_prt_tasy_p text, matricula_titular_p text, dh_validade_matricula_p text, sn_matricula_ativa_p text, bloq_modif_emp_p text, cod_empresa_p text, co_motivo_inativa_p text, ds_motivo_inativa_p text, nm_usuario_p text, nr_seq_neo_matric_prontuario_p INOUT text) AS $body$
DECLARE


nr_seq_neo_matric_prontuario_w	bigint;


BEGIN

select	nextval('w_neo_matric_prontuario_seq')
into STRICT	nr_seq_neo_matric_prontuario_w
;

insert into w_neo_matric_prontuario(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	matricula,
	cod_con,
	cod_plan,
	cod_prt_wpd,
	cod_prt_tasy,
	matricula_titular,
	dh_validade_matricula,
	sn_matricula_ativa,
	bloq_modif_emp,
	cod_empresa,
	co_motivo_inativa,
	ds_motivo_inativa)
values (	nr_seq_neo_matric_prontuario_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	matricula_p,
	cod_con_p,
	cod_plan_p,
	cod_prt_wpd_p,
	cod_prt_tasy_p,
	matricula_titular_p,
	dh_validade_matricula_p,
	sn_matricula_ativa_p,
	bloq_modif_emp_p,
	cod_empresa_p,
	co_motivo_inativa_p,
	ds_motivo_inativa_p);

nr_seq_neo_matric_prontuario_p := nr_seq_neo_matric_prontuario_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_neo_matric_prontuario ( matricula_p text, cod_con_p text, cod_plan_p text, cod_prt_wpd_p text, cod_prt_tasy_p text, matricula_titular_p text, dh_validade_matricula_p text, sn_matricula_ativa_p text, bloq_modif_emp_p text, cod_empresa_p text, co_motivo_inativa_p text, ds_motivo_inativa_p text, nm_usuario_p text, nr_seq_neo_matric_prontuario_p INOUT text) FROM PUBLIC;
