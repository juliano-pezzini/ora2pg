-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_desconto_terc_item (nr_repasse_terceiro_p bigint, nr_seq_terceiro_item_p bigint, vl_desconto_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_item_w     bigint;
qt_venc_w               bigint;


BEGIN

select  count(*)
into STRICT    qt_venc_w
from    repasse_terceiro_venc
where   nr_repasse_terceiro     = nr_repasse_terceiro_p;

if (qt_venc_w <> 0) then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(340065);
end if;

if (vl_desconto_p IS NOT NULL AND vl_desconto_p::text <> '') then

        select  max(nr_sequencia_item) + 1
        into STRICT    nr_sequencia_item_w
        from    repasse_terceiro_item
        where   nr_repasse_terceiro     = nr_repasse_terceiro_p;

        insert into repasse_terceiro_item(nr_repasse_terceiro,
                nr_sequencia_item,
                vl_repasse,
                dt_atualizacao,
                nm_usuario,
                nr_lote_contabil,
                ds_observacao,
                cd_conta_contabil,
                nr_seq_trans_fin,
                nr_seq_regra,
                cd_medico,
                nr_seq_regra_esp,
                dt_lancamento,
                cd_centro_custo,
                nr_seq_terceiro,
                dt_liberacao,
                nr_seq_trans_fin_prov,
                cd_conta_contabil_prov,
                cd_centro_custo_prov,
                nr_lote_contabil_prov,
                nr_sequencia,
                cd_conta_financ,
                cd_convenio,
                nr_seq_ret_glosa,
                nr_seq_terc_rep,
                ds_complemento,
                dt_contabil,
                qt_minuto,
                nr_seq_tipo,
                nr_atendimento,
                cd_procedimento,
                ie_origem_proced,
                ie_partic_tributo,
                nr_adiant_pago,
                cd_material,
                nr_seq_tipo_valor,
                nr_seq_terc_regra_esp,
                nr_seq_terc_regra_item)
        SELECT  nr_repasse_terceiro,
                nr_sequencia_item_w,
                (vl_desconto_p * -1),
                clock_timestamp(),
                nm_usuario_p,
                nr_lote_contabil,
                substr(ds_observacao_p,1,4000),
                cd_conta_contabil,
                nr_seq_trans_fin,
                nr_seq_regra,
                cd_medico,
                nr_seq_regra_esp,
                dt_lancamento,
                cd_centro_custo,
                nr_seq_terceiro,
                null,
                nr_seq_trans_fin_prov,
                cd_conta_contabil_prov,
                cd_centro_custo_prov,
                nr_lote_contabil_prov,
                nextval('repasse_terceiro_item_seq'),
                cd_conta_financ,
                cd_convenio,
                nr_seq_ret_glosa,
                nr_seq_terc_rep,
                null,
                dt_contabil,
                qt_minuto,
                nr_seq_tipo,
                nr_atendimento,
                cd_procedimento,
                ie_origem_proced,
                ie_partic_tributo,
                nr_adiant_pago,
                cd_material,
                nr_seq_tipo_valor,
                nr_seq_terc_regra_esp,
                nr_seq_terc_regra_item
        from    repasse_terceiro_item
        where   nr_repasse_terceiro     = nr_repasse_terceiro_p
        and     nr_sequencia_item       = nr_seq_terceiro_item_p;

        commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_desconto_terc_item (nr_repasse_terceiro_p bigint, nr_seq_terceiro_item_p bigint, vl_desconto_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
