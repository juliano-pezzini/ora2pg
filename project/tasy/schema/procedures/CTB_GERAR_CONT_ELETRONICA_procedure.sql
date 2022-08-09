-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_cont_eletronica ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_empresa_p ctb_regra_arquivo_mex.cd_empresa%type, nr_sequencia_p ctb_regra_arquivo_mex.nr_sequencia%type, ie_tipo_arquivo_p w_ctb_catalogo.ie_tipo_arquivo%type, dt_inicial_p ctb_regra_arquivo_mex.dt_inicial%type, dt_referencia_p ctb_regra_arquivo_mex.dt_inicial%type, dt_final_p ctb_regra_arquivo_mex.dt_inicial%type, nr_seq_regra_p w_ctb_catalogo.nr_seq_regra%type, nm_usuario_p ctb_regra_arquivo_mex.nm_usuario%type) AS $body$
DECLARE


/*
===============================================================================
Purpose: Indentacao

Remarks: n/a

Who         When            What
----------  -----------     --------------------------------------------------

mcjunior    18/jan/2022     OS 2821131 - Proyecto-LATAM- HJS: Informacion distinta en la pestana consulta

===============================================================================
*/


/* Campos para tabela de catalogo */

cd_versao_w             ctb_regra_arquivo_mex.cd_versao%type;
cd_cgc_w                estabelecimento.cd_cgc%type;
dt_inicial_w            ctb_regra_arquivo_mex.dt_inicial%type;
/* dt_ano_inicial_w     varchar2(4); */

nr_certificado_sat_w    ctb_regra_arquivo_mex.nr_certificado_sat%type;
dt_final_w              ctb_regra_arquivo_mex.dt_inicial%type;
ie_tipo_envio_w         ctb_regra_arquivo_mex.ie_tipo_envio%type;
ie_tipo_solicitacao_w   ctb_regra_arquivo_mex.ie_tipo_solicitacao%type;
nr_ordem_w              ctb_regra_arquivo_mex.nr_ordem%type;
dt_inicial_sup_w        ctb_regra_arquivo_mex.dt_inicial%type;
dt_final_sup_w          ctb_regra_arquivo_mex.dt_inicial%type;
nr_seq_catalogo_w       w_ctb_catalogo.nr_sequencia%type;
ie_tipo_periodo_w       ctb_regra_arquivo_mex.ie_tipo_periodo%type;

/* Campos para tabela de contas */

cd_classificacao_w      w_ctb_contas.cd_classificacao%type;
cd_agrupador_w          w_ctb_contas.cd_agrupador%type;
cd_classif_superior_w   w_ctb_contas.cd_classif_superior%type;
cd_conta_contabil_w     w_ctb_contas.cd_conta_contabil%type;
ds_conta_contabil_w     w_ctb_contas.ds_conta_contabil%type;
dt_inicio_vigencia_w    w_ctb_contas.dt_inicio_vigencia%type;
dt_fim_vigencia_w       w_ctb_contas.dt_fim_vigencia%type;
ie_debito_credito_w     w_ctb_contas.ie_debito_credito%type;
vl_credito_w            w_ctb_contas.vl_credito%type;
vl_debito_w             w_ctb_contas.vl_debito%type;
vl_saldo_w              w_ctb_contas.vl_saldo%type;
vl_saldo_ant_w          w_ctb_contas.vl_saldo_ant%type;
vl_saldo_final_w        w_ctb_contas.vl_saldo_final%type;
vl_saldo_inicial_w      w_ctb_contas.vl_saldo_inicial%type;

/*  Cursores do catalogo */

C01 CURSOR FOR
    SELECT  a.cd_versao,
            substr(obter_dados_pf_pj(NULL, b.cd_cgc,'RFC'),1,255) cd_cgc,
            substr(a.nr_certificado_sat, 1, 20) nr_certificado_sat,
            a.dt_final,
            a.dt_inicial
    from    ctb_regra_arquivo_mex a,
            estabelecimento b
    where   a.cd_empresa     = b.cd_empresa
    and     coalesce(b.ie_situacao,'A') = 'A'
    and     b.cd_estabelecimento = coalesce(a.cd_estabelecimento,b.cd_estabelecimento)
    and     coalesce(cd_estabelecimento_p, b.cd_estabelecimento) = b.cd_estabelecimento
    and     substr(obter_dados_pf_pj(null,b.cd_cgc,'RFC'),1,255) is not null
    and     b.cd_empresa        = cd_empresa_p
    and     a.nr_sequencia      = nr_sequencia_p
    group by a.cd_versao,
            substr(obter_dados_pf_pj(null, b.cd_cgc,'RFC'),1,255),
            substr(a.nr_certificado_sat, 1, 20),
            a.dt_final,
            a.dt_inicial;

C02 CURSOR FOR
    SELECT  a.cd_versao, /*Vercion*/
            coalesce(substr(obter_dados_pf_pj(null, b.cd_cgc,'RFC'),1,255),'X') cd_cgc, /*RFC*/
            a.ie_tipo_envio, /*TipoEnvio*/
            a.dt_final, /*FechaModBal*/
            substr(a.nr_certificado_sat, 1, 20) nr_certificado_sat, /*Certificado*/
            a.dt_inicial,
            a.dt_inicial dt_inicial_sup,
            a.dt_final dt_final_sup,
            a.ie_tipo_periodo
    from    ctb_regra_arquivo_mex a,
            estabelecimento b
    where   a.cd_empresa     = b.cd_empresa
    and     coalesce(b.ie_situacao,'A') = 'A'
    and     b.cd_estabelecimento = coalesce(a.cd_estabelecimento,b.cd_estabelecimento)
    and     a.nr_sequencia = nr_sequencia_p
    group by
            a.cd_versao
            , substr(obter_dados_pf_pj(null,b.cd_cgc,'RFC'),1,255)
            , a.ie_tipo_envio
            , a.dt_final
            , substr(a.nr_certificado_sat, 1, 20)
            , a.nr_sequencia
            , a.dt_inicial
            , to_char(a.dt_final,'dd/mm/yyyy')
            , b.cd_empresa
            , a.ie_tipo_periodo;

C03 CURSOR FOR
    SELECT  a.cd_versao, /*Vercion */
            substr(obter_dados_pf_pj(null, b.cd_cgc,'RFC'),1,255) cd_cgc, /*RFC */
            a.ie_tipo_solicitacao, /*TipoSolicitud*/
            CASE WHEN a.ie_tipo_solicitacao='AF' THEN  a.nr_ordem WHEN a.ie_tipo_solicitacao='FC' THEN  a.nr_ordem  ELSE null END  nr_ordem, /*NumOrden*/
            substr(a.nr_certificado_sat, 1, 20) nr_certificado_sat, /*nocertificado */
            a.dt_inicial,
            a.ie_tipo_periodo
    from    ctb_regra_arquivo_mex a,
            estabelecimento b
    where   b.cd_estabelecimento = coalesce(a.cd_estabelecimento,b.cd_estabelecimento)
    and     b.cd_empresa        = a.cd_empresa
    and     a.nr_sequencia      = nr_sequencia_p
    and     a.cd_empresa        = cd_empresa_p
    and exists (
        SELECT  1
        from    ctb_balancete_v x
        where   x.cd_estabelecimento = b.cd_estabelecimento
        and     x.dt_referencia between a.dt_inicial and a.dt_final
        );

/* Cursores para Contas  */

C04 CURSOR FOR
    SELECT  substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_p),1,40) cd_classificacao,
            y.cd_classif_ecd cd_agrupador,
            substr(d.ds_conta_referencial, 1, 200) ds_conta_contabil,
            coalesce(coalesce(ctb_obter_classif_conta_sup(substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_p),1,40), dt_inicial_p,  a.cd_empresa), a.cd_classif_superior),'1') cd_classif_superior,
            a.cd_conta_contabil,
            CASE WHEN b.ie_debito_credito='C' THEN  'A'  ELSE b.ie_debito_credito END  ie_debito_credito,
            a.dt_inicio_vigencia,
            a.dt_fim_vigencia
    from    conta_contabil a,
            ctb_grupo_conta b,
            conta_contabil_classif_ecd c,
            conta_contabil_referencial d,
            conta_contabil_classif_ecd y
    where   b.cd_grupo = a.cd_grupo
    and     b.cd_empresa = a.cd_empresa
    and     d.cd_classificacao = c.cd_classif_ecd
    and     c.cd_conta_contabil = a.cd_conta_contabil
    and     y.cd_conta_contabil     = a.cd_conta_contabil
    and     (y.cd_classif_ecd IS NOT NULL AND y.cd_classif_ecd::text <> '')
    and     a.cd_empresa = cd_empresa_p
    and     substr(obter_Se_conta_vigente2(a.cd_conta_contabil, a.dt_inicio_vigencia, a.dt_fim_vigencia, dt_inicial_p),1, 1) = 'S'
    and     d.cd_empresa = a.cd_empresa
    group by substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_p),1,40),
            y.cd_classif_ecd,
            substr(d.ds_conta_referencial, 1, 200),
            coalesce(coalesce(ctb_obter_classif_conta_sup(substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_p),1,40), dt_inicial_p,  a.cd_empresa), a.cd_classif_superior),'1'),
            a.cd_conta_contabil,
            CASE WHEN b.ie_debito_credito='C' THEN  'A'  ELSE b.ie_debito_credito END ,
            a.dt_inicio_vigencia,
            a.dt_fim_vigencia
    ORDER BY cd_agrupador, cd_classificacao;

C05 CURSOR FOR
    SELECT  substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_sup_w),1,40) cd_classificacao,
            sum(a.vl_saldo_ant) vl_saldo_ant,
            sum(a.vl_debito) vl_debito,
            sum(a.vl_credito) vl_credito,
            sum(a.vl_saldo) vl_saldo
    from    ctb_balancete_v a,
            conta_contabil_classif_ecd b,
            estabelecimento c
    where   1 = 1
    and     b.cd_conta_contabil = a.cd_conta_contabil
    and     a.cd_estabelecimento = c.cd_estabelecimento
    and     obter_empresa_estab(a.cd_estabelecimento) = cd_empresa_p
    and     ((coalesce(ie_tipo_periodo_w,'N') = 'S' and a.ie_normal_encerramento = 'N') or (coalesce(ie_tipo_periodo_w,'N') = 'N'
            and a.ie_normal_encerramento = 'ES'
            and philips_contabil_pck.obter_tipo_grupo_conta(a.cd_conta_contabil) <> 'O'))
    and     c.cd_estabelecimento = coalesce((SELECT  m.cd_estabelecimento
                                        from    ctb_regra_arquivo_mex m
                                        where   m.nr_sequencia = nr_sequencia_p),
                                    c.cd_estabelecimento)
    and     substr(obter_dados_pf_pj(null,c.cd_cgc,'RFC'),1,255) = coalesce(cd_cgc_w,substr(obter_dados_pf_pj(null,c.cd_cgc,'RFC'),1,255) )
    and     a.dt_referencia between to_date(dt_inicial_sup_w,'dd/mm/yy') and fim_dia(to_date(dt_final_sup_w,'dd/mm/yy'))
    group by substr(ctb_obter_classif_conta(a.cd_conta_contabil, a.cd_classificacao, dt_inicial_sup_w),1,40)
    order by cd_classificacao;

C06 CURSOR FOR
    SELECT  c.cd_conta_contabil, /*NumCta*/
            substr(ctb_obter_classif_conta(c.cd_conta_contabil, c.cd_classificacao, dt_inicial_w),1,40) cd_classificacao,
            coalesce(coalesce(ctb_obter_classif_conta_sup(substr(ctb_obter_classif_conta(c.cd_conta_contabil, c.cd_classificacao, dt_inicial_w),1,40), dt_inicial_w,  e.cd_empresa), null),'1') cd_classif_superior,
            substr(rps_substituir_caractere(c.ds_conta_contabil), 1, 100) ds_conta_contabil, /*DesCta*/
            coalesce(sum(c.vl_saldo_ant),0) vl_saldo_ini, /*SaldoIni*/
            coalesce(sum(c.vl_saldo),0) vl_saldo_fim /*SaldoFin*/
    FROM    ctb_balancete_v c,
            estabelecimento e
    WHERE   c.vl_movimento <> 0
    and     c.ie_normal_encerramento = 'N'
    and     c.ie_tipo = 'A'
    and     c.dt_referencia between dt_inicial_w and dt_final_p
    and     c.cd_empresa   = cd_empresa_p
    and     substr(obter_dados_pf_pj(null,e.cd_cgc,'RFC'),1,255) = cd_cgc_w
    and (ie_tipo_periodo_w = 'S' or (ie_tipo_periodo_w = 'N' and philips_contabil_pck.obter_tipo_grupo_conta(c.cd_conta_contabil) <> 'O'))
    and     e.cd_estabelecimento=c.cd_estabelecimento
    GROUP BY c.cd_conta_contabil,
            substr(ctb_obter_classif_conta(c.cd_conta_contabil, c.cd_classificacao, dt_inicial_w),1,40),
            coalesce(coalesce(ctb_obter_classif_conta_sup(substr(ctb_obter_classif_conta(c.cd_conta_contabil, c.cd_classificacao, dt_inicial_w),1,40), dt_inicial_w,  e.cd_empresa), null),'1'),
            c.ds_conta_contabil
    ORDER BY c.cd_conta_contabil;



BEGIN

    delete
    from    w_ctb_catalogo
    where   nr_seq_regra = nr_seq_regra_p
    and     ie_tipo_arquivo = ie_tipo_arquivo_p;

    delete
    from    w_ctb_contas
    where   nr_seq_regra = nr_seq_regra_p
    and     ie_tipo_arquivo = ie_tipo_arquivo_p;

    if (ie_tipo_arquivo_p = 'A') then

        open C01;
        loop
        fetch C01 into
            cd_versao_w,
            cd_cgc_w,
            nr_certificado_sat_w,
            dt_final_w,
            dt_inicial_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
            nr_seq_catalogo_w := gerar_w_ctb_catalogo(
                cd_versao_w, cd_cgc_w, dt_inicial_w, nr_certificado_sat_w, ie_tipo_arquivo_p, null, /* dt_final_p */
                null, /* ie_tipo_envio_p */
                null, /* ie_tipo_solicitacao_p */
                null, /* nr_ordem_p */
                nr_seq_regra_p, nm_usuario_p, nr_seq_catalogo_w);

            open C04;
            loop
            fetch C04 into
                cd_classificacao_w,
                cd_agrupador_w,
                ds_conta_contabil_w,
                cd_classif_superior_w,
                cd_conta_contabil_w,
                ie_debito_credito_w,
                dt_inicio_vigencia_w,
                dt_fim_vigencia_w;
            EXIT WHEN NOT FOUND; /* apply on C04 */
                CALL gerar_w_ctb_conta(
                    cd_classificacao_w,
                    cd_agrupador_w,
                    ds_conta_contabil_w,
                    cd_classif_superior_w,
                    cd_conta_contabil_w,
                    ie_debito_credito_w,
                    dt_inicio_vigencia_w,
                    dt_fim_vigencia_w,
                    ie_tipo_arquivo_p,
                    null, /* vl_saldo_ant_p */
                    null, /* vl_debito_p */
                    null, /* vl_credito_p */
                    null, /* vl_saldo_p*/
                    null, /* vl_saldo_inicial_p*/
                    null, /* vl_saldo_final_p*/
                    nr_seq_regra_p,
                    nm_usuario_p,
                    nr_seq_catalogo_w);
            end loop;
            close C04;

        end loop;
        close C01;

    elsif (ie_tipo_arquivo_p = 'C') then

        open C02;
        loop
        fetch C02 into
            cd_versao_w,
            cd_cgc_w,
            ie_tipo_envio_w,
            dt_final_w,
            nr_certificado_sat_w,
            dt_inicial_w,
            dt_inicial_sup_w,
            dt_final_sup_w,
            ie_tipo_periodo_w;
        EXIT WHEN NOT FOUND; /* apply on C02 */
            nr_seq_catalogo_w := gerar_w_ctb_catalogo(
                cd_versao_w, cd_cgc_w, dt_inicial_w, nr_certificado_sat_w, ie_tipo_arquivo_p, dt_final_w, ie_tipo_envio_w, null, /* ie_tipo_solicitacao_p */
                null, /*  nr_ordem_p  */
                nr_seq_regra_p, nm_usuario_p, nr_seq_catalogo_w);

            open C05;
            loop
            fetch C05 into
                cd_classificacao_w,
                vl_saldo_ant_w,
                vl_debito_w,
                vl_credito_w,
                vl_saldo_w;
            EXIT WHEN NOT FOUND; /* apply on C05 */
                CALL gerar_w_ctb_conta(
                    cd_classificacao_w,
                    null, /* cd_agrupador_p */
                    null, /* ds_conta_contabil_p */
                    null, /* cd_classif_superior_p*/
                    null, /* cd_conta_contabil_p */
                    null, /* ie_debito_credito_p */
                    null, /* dt_inicio_vigencia_p*/
                    null, /* dt_fim_vigencia_p */
                    ie_tipo_arquivo_p,
                    vl_saldo_ant_w,
                    vl_debito_w,
                    vl_credito_w,
                    vl_saldo_w,
                    null, /* vl_saldo_inicial_p*/
                    null, /* vl_saldo_final_p*/
                    nr_seq_regra_p,
                    nm_usuario_p,
                    nr_seq_catalogo_w);
            end loop;
            close C05;

        end loop;
        close C02;

    elsif (ie_tipo_arquivo_p = 'F') then

        open C03;
        loop
        fetch C03 into
            cd_versao_w,
            cd_cgc_w,
            ie_tipo_solicitacao_w,
            nr_ordem_w,
            nr_certificado_sat_w,
            dt_inicial_w,
            ie_tipo_periodo_w;
        EXIT WHEN NOT FOUND; /* apply on C03 */
            nr_seq_catalogo_w := gerar_w_ctb_catalogo(
                cd_versao_w, cd_cgc_w, dt_inicial_w, nr_certificado_sat_w, ie_tipo_arquivo_p, null, /*dt_final_p */
                null, /* ie_tipo_envio_p*/
                ie_tipo_solicitacao_w, nr_ordem_w, nr_seq_regra_p, nm_usuario_p, nr_seq_catalogo_w);

            open C06;
            loop
            fetch C06 into
                cd_conta_contabil_w,
                cd_classificacao_w,
                cd_classif_superior_w,
                ds_conta_contabil_w,
                vl_saldo_inicial_w,
                vl_saldo_final_w;
            EXIT WHEN NOT FOUND; /* apply on C06 */
                CALL gerar_w_ctb_conta(
                    cd_classificacao_w, /* cd_classificacao_p */
                    null, /* cd_agrupador_p */
                    ds_conta_contabil_w, /* ds_conta_contabil_p */
                    cd_classif_superior_w, /* cd_classif_superior_p*/
                    cd_conta_contabil_w, /* cd_conta_contabil_p */
                    null, /* ie_debito_credito_p */
                    null, /* dt_inicio_vigencia_p*/
                    null, /* dt_fim_vigencia_p */
                    ie_tipo_arquivo_p,
                    null, /* vl_saldo_ant_p*/
                    null,  /* vl_debito_p*/
                    null, /* vl_credito_p*/
                    null,   /* vl_saldo_p*/
                    vl_saldo_inicial_w, /* vl_saldo_inicial_p*/
                    vl_saldo_final_w, /* vl_saldo_final_p*/
                    nr_seq_regra_p,
                    nm_usuario_p,
                    nr_seq_catalogo_w);
            end loop;
            close C06;

        end loop;
        close C03;

    end if;
    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_cont_eletronica ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_empresa_p ctb_regra_arquivo_mex.cd_empresa%type, nr_sequencia_p ctb_regra_arquivo_mex.nr_sequencia%type, ie_tipo_arquivo_p w_ctb_catalogo.ie_tipo_arquivo%type, dt_inicial_p ctb_regra_arquivo_mex.dt_inicial%type, dt_referencia_p ctb_regra_arquivo_mex.dt_inicial%type, dt_final_p ctb_regra_arquivo_mex.dt_inicial%type, nr_seq_regra_p w_ctb_catalogo.nr_seq_regra%type, nm_usuario_p ctb_regra_arquivo_mex.nm_usuario%type) FROM PUBLIC;
