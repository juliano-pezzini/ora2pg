-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_pat_conta_contab_estab (cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w    bigint;
ds_grupo_w              varchar(255);
cd_conta_contabil_w     varchar(20);
dt_vigencia_w           timestamp;
tx_depreciacao_w        double precision;
cd_conta_deprec_acum_w  varchar(20);
cd_conta_deprec_res_w   varchar(20);
cd_historico_w          bigint;
cd_conta_baixa_w        varchar(20);
cd_hist_baixa_w         bigint;
cd_empresa_w            bigint;
cd_hist_transf_w        bigint;
pr_deprec_fiscal_w      double precision;
cd_conta_ajuste_pat_w   varchar(20);
cd_hist_ajuste_pat_w    bigint;
cd_conta_cap_social_w   varchar(20);
ds_regra_w              varchar(255);


BEGIN
        select  cd_conta_contabil,
                dt_vigencia,
                pr_depreciacao,
                cd_conta_deprec_acum,
                cd_conta_deprec_res,
                cd_historico,
                cd_conta_baixa,
                cd_hist_baixa,
                cd_empresa,
                cd_hist_transf,
                pr_deprec_fiscal,
                cd_conta_ajuste_pat,
                cd_hist_ajuste_pat,
                cd_conta_cap_social,
                ds_regra
        into STRICT
                cd_conta_contabil_w,
                dt_vigencia_w,
                tx_depreciacao_w,
                cd_conta_deprec_acum_w,
                cd_conta_deprec_res_w,
                cd_historico_w,
                cd_conta_baixa_w,
                cd_hist_baixa_w,
                cd_empresa_w,
                cd_hist_transf_w,
                pr_deprec_fiscal_w,
                cd_conta_ajuste_pat_w,
                cd_hist_ajuste_pat_w,
                cd_conta_cap_social_w,
                ds_regra_w
        from    pat_conta_contabil
        where   nr_sequencia = nr_sequencia_p;

        insert into pat_conta_contabil(
                nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                cd_conta_contabil,
                dt_vigencia,
                pr_depreciacao,
                cd_estabelecimento,
                cd_conta_deprec_acum,
                cd_conta_deprec_res,
                cd_historico,
                cd_conta_baixa,
                cd_hist_baixa,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                ie_situacao,
                cd_empresa,
                cd_hist_transf,
                pr_deprec_fiscal,
                cd_conta_ajuste_pat,
                cd_hist_ajuste_pat,
                cd_conta_cap_social,
                ds_regra)
        values ( nextval('pat_conta_contabil_seq'),
                clock_timestamp(),
                nm_usuario_p,
                cd_conta_contabil_w,
                dt_vigencia_w,
                tx_depreciacao_w,
                cd_estabelecimento_p,
                cd_conta_deprec_acum_w,
                cd_conta_deprec_res_w,
                cd_historico_w,
                cd_conta_baixa_w,
                cd_hist_baixa_w,
                clock_timestamp(),
                nm_usuario_p,
                'A',
                cd_empresa_w,
                cd_hist_transf_w,
                pr_deprec_fiscal_w,
                cd_conta_ajuste_pat_w,
                cd_hist_ajuste_pat_w,
                cd_conta_cap_social_w,
                ds_regra_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_pat_conta_contab_estab (cd_estabelecimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

