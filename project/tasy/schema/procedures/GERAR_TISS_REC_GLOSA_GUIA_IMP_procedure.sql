-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tiss_rec_glosa_guia_imp (nr_seq_prot_imp_p bigint, nm_usuario_p text, nr_guia_prestador_p text, nr_guia_operadora_p text, cd_senha_p text, dt_realizacao_p timestamp, dt_fim_realizacao_p timestamp, cd_motivo_glosa_p text, vl_recursado_p text, vl_acatado_p text, ds_justificativa_prest_p text, ds_justificativa_oper_p text, cd_procedimento_p text, ds_procedimento_p text, ds_just_ops_n_acato_guia_p text) AS $body$
DECLARE


vl_recursado_w          double precision;
vl_acatado_w            double precision;
nr_seq_motivo_glosa_w   bigint;


BEGIN

vl_recursado_w          := vl_recursado_p;
vl_acatado_w            := vl_acatado_p;

select  max(nr_sequencia)
into STRICT    nr_seq_motivo_glosa_w
from    tiss_motivo_glosa
where   cd_motivo_tiss  = cd_motivo_glosa_p;

insert into TISS_REC_GLOSA_GUIA_IMP(nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_prot_imp,
        nr_guia_prestador,
	nr_guia_operadora,
        cd_senha,
        dt_realizacao,
        dt_fim_realizacao,
        nr_seq_motivo_glosa,
        cd_motivo_glosa,
        vl_recursado,
        vl_acatado,
        ds_justificativa_prest,
        ds_justificativa_oper,
        cd_procedimento,
        ds_procedimento,
        ds_just_ops_nao_acato_guia)
values (nextval('tiss_rec_glosa_guia_imp_seq'),
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_prot_imp_p,
        nr_guia_prestador_p,
	nr_guia_operadora_p,
        cd_senha_p,
        dt_realizacao_p,
        dt_fim_realizacao_p,
        nr_seq_motivo_glosa_w,
        cd_motivo_glosa_p,
        vl_recursado_w,
        vl_acatado_w,
        ds_justificativa_prest_p,
        ds_justificativa_oper_p,
        cd_procedimento_p,
        ds_procedimento_p,
        ds_just_ops_n_acato_guia_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tiss_rec_glosa_guia_imp (nr_seq_prot_imp_p bigint, nm_usuario_p text, nr_guia_prestador_p text, nr_guia_operadora_p text, cd_senha_p text, dt_realizacao_p timestamp, dt_fim_realizacao_p timestamp, cd_motivo_glosa_p text, vl_recursado_p text, vl_acatado_p text, ds_justificativa_prest_p text, ds_justificativa_oper_p text, cd_procedimento_p text, ds_procedimento_p text, ds_just_ops_n_acato_guia_p text) FROM PUBLIC;
