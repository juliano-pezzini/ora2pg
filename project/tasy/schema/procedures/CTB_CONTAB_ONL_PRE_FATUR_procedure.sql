-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_contab_onl_pre_fatur ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

/*
===============================================================================
Purpose: Indentacao

Remarks: n/a

Who         When            What
----------  -----------     --------------------------------------------------

chjreinert  13/mai/2021     OS 2444975 - Indentacao

===============================================================================
*/
ctb_movimento_doc_w             ctb_online_pck.ctb_movimento_doc;
cd_centro_custo_debito_w        ctb_movto_centro_custo.cd_centro_custo%type;
cd_categoria_w                  conta_paciente.cd_categoria_parametro%type;
cd_conta_debito_w               convenio_estabelecimento.cd_conta_pre_fatur%type;
cd_conta_credito_w              convenio_estabelecimento.cd_conta_pre_fatur%type;
cd_convenio_ww                  pre_faturamento.cd_convenio%type := 99999;
cd_estab_movto_debito_w         movimento_contabil.cd_estabelecimento%type;
cd_estab_movto_receita_w        movimento_contabil.cd_estabelecimento%type;
cd_estab_movto_w                estabelecimento.cd_estabelecimento%type;
cd_plano_convenio_w             atend_categoria_convenio.cd_plano_convenio%type;
cd_tipo_lote_contabil_w         tipo_lote_contabil.cd_tipo_lote_contabil%type   := 8;
ctb_param_lote_pre_fatur_w      ctb_param_lote_pre_fatur%rowtype;
ie_centro_custo_w               conta_contabil.ie_centro_custo%type;
ie_origem_documento_w           movimento_contabil.ie_origem_documento%type := null;
nr_atendimento_w                conta_paciente.nr_atendimento%type;
nr_documento_ww                 movimento_contabil.nr_documento%type := null;
nr_lote_contabil_w              lote_contabil.nr_lote_contabil%type;
nr_seq_agrupamento_w            w_movimento_contabil.nr_seq_agrupamento%type    := 0;
vl_receita_orig_w               material_atend_paciente.vl_material%type;
ds_compl_historico_w            ctb_movimento.ds_compl_historico%type;
ds_atributos_w                  varchar(4000);
ds_erro_w                       varchar(255) := null;
ds_mesano_referencia_w          varchar(30);
ie_regra_w                      varchar(255);
dt_atualizacao_saldo_w          timestamp;
dt_estorno_w                    timestamp;
dt_movimento_w                  timestamp;
dt_referencia_mesano_w          bigint;
ie_tipo_atendimento_w           smallint;
nm_agrupador_w                  varchar(255);
nm_paciente_w                   varchar(80);
nr_seq_atecaco_w                bigint;
qt_registro_w                   bigint;
qt_regra_cta_prefatur_w         bigint;
sequencia_w                     dbms_sql.number_table;
nr_seq_classif_movto_w          ctb_movimento.nr_seq_classif_movto%type;
cd_historico_tributo_w          ctb_regra_tributo_pre_fat.cd_historico%type;
ds_tributo_w                    tributo.ds_tributo%type;
vl_desc_item_neg_w				pre_faturamento.vl_desc_item_neg%type;
cd_conta_contabil_conv_w       	conta_contabil.cd_conta_contabil%type;

c_estab CURSOR FOR
    SELECT  distinct
        e.cd_estabelecimento,
        e.cd_empresa
    from    estabelecimento e,
        pre_fatur_conta a
    where   e.cd_estabelecimento    = a.cd_estabelecimento
    and a.dt_referencia = dt_referencia_p
    and (a.cd_estabelecimento   = cd_estabelecimento_p or cd_estabelecimento_p = 0)
    and exists ( SELECT  1
            from    ctb_param_lote_pre_fatur y
            where   y.cd_empresa    = e.cd_empresa
            and coalesce(y.cd_estab_exclusivo,a.cd_estabelecimento)  = a.cd_estabelecimento
            and y.ie_ctb_online = 'S');

vetEstab    c_estab%rowtype;

c010 CURSOR FOR
    SELECT  a.cd_convenio,
        d.ie_tipo_convenio,
        d.ds_convenio,
        a.cd_conta_contabil cd_conta_receita,
        c.cd_centro_custo_receita cd_centro_receita,
        a.nr_interno_conta,
        a.cd_setor_atendimento,
        a.cd_conta_desp_pre_fatur,
        sum(coalesce(a.vl_procedimento,0) + coalesce(a.vl_material,0)) vl_receita,
        sum(coalesce(a.vl_repasse_calc,0)) vl_repasse,
		sum(coalesce(a.vl_desc_item_neg,0)) vl_desc_item_neg,
		a.cd_sequencia_parametro
    from    convenio d,
        Setor_Atendimento c,
        pre_faturamento a
    where   a.dt_referencia     = dt_referencia_p
    and a.cd_setor_atendimento  = c.cd_setor_atendimento
    and a.cd_convenio       = d.cd_convenio
    and ((ctb_param_lote_pre_fatur_w.ie_contab_sus_prefatur = 'S') or (d.ie_tipo_convenio <> 3))
    and coalesce(a.cd_conta_contabil,'0')    <> '0'
    and a.cd_estabelecimento    = vetEstab.cd_estabelecimento
    and not exists ( SELECT  1
                from    pre_fatur_perda x,
                    pre_fatur_perda_conta y
                where   x.nr_sequencia  = y.nr_seq_perda
                and y.nr_interno_conta  = a.nr_interno_conta
                and (x.dt_baixa IS NOT NULL AND x.dt_baixa::text <> ''))
    group by
        a.cd_convenio,
        d.ie_tipo_convenio,
        d.ds_convenio,
        a.cd_conta_contabil,
        c.cd_centro_custo_receita,
        a.nr_interno_conta,
        a.cd_setor_atendimento,
        a.cd_conta_desp_pre_fatur,
        a.cd_sequencia_parametro
    order by 1;

vet010  c010%RowType;

c015 CURSOR FOR
    SELECT  c.cd_tributo,
        c.pr_tributo,
        a.nr_interno_conta,
        a.cd_convenio,
            d.ds_convenio,
            c.cd_conta_debito,
            c.cd_conta_credito,
            c.vl_tributo,
            e.cd_centro_custo_receita cd_centro_receita
    from    setor_atendimento e,
        pre_fatur_conta a,
            pre_faturamento b,
            pre_fatur_tributo c,
            convenio d
    where   a.nr_interno_conta = b.nr_interno_conta
    and b.cd_setor_atendimento  = e.cd_setor_atendimento
    and     a.dt_referencia = b.dt_referencia
    and     a.cd_estabelecimento = b.cd_estabelecimento
    and     c.nr_seq_pre_fatur = b.nr_sequencia
    and     d.cd_convenio = a.cd_convenio
    and     a.dt_referencia = dt_referencia_p
    and     a.cd_estabelecimento = vetEstab.cd_estabelecimento
    and c.vl_tributo > 0;

c015_w      c015%rowtype;

c020 CURSOR FOR
    SELECT  a.nr_sequencia,
        a.nr_lote_contabil,
        a.nr_seq_mes_ref,
        a.dt_movimento,
        a.vl_movimento,
        a.cd_historico,
        a.cd_conta_debito,
        a.cd_conta_credito,
        a.ds_compl_historico,
        a.nr_seq_agrupamento,
        a.ie_revisado,
        a.cd_estabelecimento,
        a.ds_consistencia,
        a.cd_classif_debito,
        a.cd_classif_credito,
        a.ds_observacao,
        a.nr_seq_movto_corresp,
        a.dt_revisao,
        a.nm_usuario_revisao,
        a.nr_seq_apres,
        a.nr_seq_conta_ans_deb,
        a.nr_seq_conta_ans_cred,
        a.nr_agrup_sequencial,
        a.nr_documento,
        a.ie_origem_documento,
        a.ie_status_concil,
        a.ie_status_origem,
        a.nr_seq_mutacao_pl,
        a.ds_justificativa,
        a.ie_transitorio,
        a.nr_seq_classif_movto
    from    ctb_movimento a
    where   a.nr_lote_contabil  = nr_lote_contabil_w
    order by 1;

c020_w          c020%rowtype;

procedure get_sequence is

  vet RECORD;

BEGIN

if (sequencia_w.count > 0) then
    ctb_movimento_doc_w.nr_sequencia    := sequencia_w(sequencia_w.count);
    sequencia_w.delete(sequencia_w.count);
end if;
exception when others then
    ctb_movimento_doc_w.nr_sequencia    := null;
end;

begin

dt_movimento_w := pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_referencia_p, 'MONTH'), coalesce(dt_referencia_p, PKG_DATE_UTILS.GET_TIME('00:00:00')));
nm_agrupador_w := coalesce(trim(both obter_agrupador_contabil(8)),'NR_INTERNO_CONTA');

dt_referencia_mesano_w  := somente_numero(to_char(dt_referencia_p, 'MMYYYY'));
ds_mesano_referencia_w  := substr(obter_desc_mes_ano(dt_referencia_p, 'ABM2'),1,30);

begin
	select 	max(cd_conta_desconto_pre_fatur)
	into STRICT	cd_conta_contabil_conv_w
	from	parametro_faturamento a
	where	a.cd_estabelecimento = obter_estabelecimento_ativo();
exception
	when no_data_found then
			cd_conta_contabil_conv_w := null;
end;

open c_estab;
loop
fetch c_estab into
    vetEstab;
EXIT WHEN NOT FOUND; /* apply on c_estab */
    begin

    nr_lote_contabil_w  := ctb_online_pck.get_lote_contabil(    cd_tipo_lote_contabil_w , vetEstab.cd_estabelecimento, dt_referencia_p, nm_usuario_p);

    select  count(nr_sequencia)
    into STRICT    qt_registro_w
    from    ctb_movimento
    where   nr_lote_contabil    = nr_lote_contabil_w;

    begin
    select  dt_atualizacao_saldo
    into STRICT    dt_atualizacao_saldo_w
    from    lote_contabil
    where   nr_lote_contabil    = nr_lote_contabil_w;
    exception when others then
        dt_atualizacao_saldo_w := null;
    end;

    if (dt_atualizacao_saldo_w IS NOT NULL AND dt_atualizacao_saldo_w::text <> '') then
        ds_erro_w := ctb_desatualizar_lote(nr_lote_contabil_w, nm_usuario_p, ds_erro_w);
    end if;

    if (qt_registro_w > 0) then
        begin
        qt_registro_w   := sequencia_w.count;

        for vet in (    SELECT a.nr_sequencia
                from    ctb_movimento a
                where   a.nr_lote_contabil  = nr_lote_contabil_w
                order by 1 desc) loop
            begin
            qt_registro_w   := qt_registro_w + 1;
            sequencia_w(qt_registro_w)  := vet.nr_sequencia;
            end;
        end loop;
        end;
    end if;

    delete  FROM ctb_movimento
    where   nr_lote_contabil    = nr_lote_contabil_w;
    commit;

    select  count(nr_sequencia)
    into STRICT    qt_regra_cta_prefatur_w
    from    ctb_regra_cta_prefatur
    where   cd_empresa  = vetEstab.cd_empresa;

    cd_estab_movto_debito_w     := vetEstab.cd_estabelecimento;

    /* Parametros PRE FATURAMENTO  */

    begin
    select  x.*
    into STRICT    ctb_param_lote_pre_fatur_w
    from (   SELECT  a.*
                        from    ctb_param_lote_pre_fatur a
                        where   a.cd_empresa    = vetEstab.cd_empresa
                        and     coalesce(a.cd_estab_exclusivo, vetEstab.cd_estabelecimento)  = vetEstab.cd_estabelecimento
                        order by coalesce(a.cd_estab_exclusivo,0) desc
                ) x LIMIT 1;
    end;

    open c010;
    loop
    fetch c010 into
        vet010;
    EXIT WHEN NOT FOUND; /* apply on c010 */
        begin
        ctb_movimento_doc_w     := null;
        cd_estab_movto_receita_w:= null;
        cd_categoria_w      := '';
        vl_receita_orig_w   := vet010.vl_receita;

        nr_seq_classif_movto_w  := ctb_obter_classif_financ(vet010.cd_convenio, vet010.ie_tipo_convenio);

        if (coalesce(vet010.cd_centro_receita,0) != 0) then
            begin
            select  cd_estabelecimento
            into STRICT    cd_estab_movto_receita_w
            from    centro_custo
            where   cd_centro_custo = vet010.cd_centro_receita;
            exception when others then
                cd_estab_movto_receita_w    := null;
            end;
        end if;

        begin
        select  nr_atendimento,
            cd_categoria_parametro
        into STRICT    nr_atendimento_w,
            cd_categoria_w
        from    conta_paciente
        where   nr_interno_conta    = vet010.nr_interno_conta;
        exception when others then
            nr_atendimento_w    := null;
            cd_categoria_w      := '';
        end;

        if (nm_agrupador_w = 'NR_INTERNO_CONTA')then
            nr_seq_agrupamento_w    := vet010.nr_interno_conta;
        elsif (nm_agrupador_w = 'NR_ATENDIMENTO')then
            nr_seq_agrupamento_w    := nr_atendimento_w;
        elsif (nm_agrupador_w = 'DS_MESANO')then
            nr_seq_agrupamento_w    := dt_referencia_mesano_w;
        elsif (nm_agrupador_w = 'CD_CONVENIO')then
            nr_seq_agrupamento_w    := vet010.cd_convenio;
        end if;

        if (coalesce(nr_seq_agrupamento_w,0) = 0)then
            nr_seq_agrupamento_w    :=   vet010.nr_interno_conta;
        end if;

        if (coalesce(nr_atendimento_w,0) <> 0) then
            ie_tipo_atendimento_w   := obter_tipo_atendimento(nr_atendimento_w);
        end if;

        if (vet010.cd_convenio <> cd_convenio_ww) then
            cd_convenio_ww  := vet010.cd_convenio;
            select  max(cd_conta_pre_fatur)
            into STRICT    cd_conta_debito_w
            from    convenio_estabelecimento b
            where   cd_convenio     = vet010.cd_convenio
            and cd_estabelecimento  = vetEstab.cd_estabelecimento;
        end if;

        cd_conta_debito_w       := coalesce(cd_conta_debito_w, ctb_param_lote_pre_fatur_w.cd_conta_debito);

        select  CASE WHEN coalesce(max(ie_centro_custo),'N')='S' THEN vet010.cd_centro_receita  ELSE null END
        into STRICT    vet010.cd_centro_receita
        from    conta_contabil
        where   cd_conta_contabil   = vet010.cd_conta_receita;

        /* Se o parametro do faturamento ctb_param_lote_pre_fatur_w.ie_contab_repasse_prefatur = 'D' - Desconta o repasse da receita e do convenio */

        if (ctb_param_lote_pre_fatur_w.ie_contab_repasse_prefatur = 'D') then
            vet010.vl_receita       := vet010.vl_receita - vet010.vl_repasse;
        end if;

        if (nr_atendimento_w <> 0) and (vet010.nr_interno_conta <> 0) then
            begin
            nm_paciente_w   := substr(obter_paciente_conta(vet010.nr_interno_conta, 'D'),1,80);
            exception when others then
                nm_paciente_w := '';
            end;
        end if;

        /* Parametros HISTORICO */

        CALL ctb_online_pck.definir_atrib_compl(cd_tipo_lote_contabil_w);
        CALL ctb_online_pck.set_value_compl_hist('DS_CONVENIO', vet010.ds_convenio);
        CALL ctb_online_pck.set_value_compl_hist('DS_MESANO_REFERENCIA', ds_mesano_referencia_w);
        CALL ctb_online_pck.set_value_compl_hist('NR_INTERNO_CONTA', vet010.nr_interno_conta );
        CALL ctb_online_pck.set_value_compl_hist('NR_ATENDIMENTO', nr_atendimento_w);
        CALL ctb_online_pck.set_value_compl_hist('NM_PACIENTE', nm_paciente_w);

        /* Obtem Historico */

        ds_compl_historico_w := ctb_online_pck.ctb_obter_compl_Historico( cd_tipo_lote_contabil_w, ctb_param_lote_pre_fatur_w.cd_historico);

        select  count(nr_sequencia)
        into STRICT    qt_registro_w
        from    convenio_conta_contabil
        where   (cd_categoria IS NOT NULL AND cd_categoria::text <> '')
        and cd_convenio = vet010.cd_convenio
        and ie_tipo_conta   = 'P';

        if (qt_registro_w > 0) and (coalesce(nr_atendimento_w,0) <> 0) then
            begin
            nr_seq_atecaco_w    := coalesce(obter_atecaco_atendimento(nr_atendimento_w),0);
            exception when others then
                nr_seq_atecaco_w    := null;
            end;

            if (coalesce(nr_seq_atecaco_w,0) <> 0) then
                select  max(cd_plano_convenio)
                into STRICT    cd_plano_convenio_w
                from    atend_categoria_convenio
                where   nr_atendimento  = nr_atendimento_W
                and nr_seq_interno  = nr_seq_atecaco_w;
            end if;

            cd_conta_debito_w   := coalesce(obter_conta_convenio(vetEstab.cd_estabelecimento,
                                    vet010.cd_convenio,
                                    ie_tipo_atendimento_w,
                                    'P',
                                    dt_referencia_p,
                                    null,
                                    cd_categoria_w,
                                    cd_plano_convenio_w,
                                    vet010.cd_setor_atendimento,
                                    null,
                                    null),cd_conta_debito_w);

            if (ctb_param_lote_pre_fatur_w.ie_contab_cc_debito = 'S') then
                begin
                select  coalesce(max(ie_centro_custo),'N')
                into STRICT    ie_centro_custo_w
                from    conta_contabil
                where   cd_conta_contabil = cd_conta_debito_w;

                if (ie_centro_custo_w = 'S') then
                    begin
                    select  max(cd_centro_custo)
                    into STRICT    ctb_movimento_doc_w.cd_centro_custo
                    from    setor_atendimento
                    where   cd_setor_atendimento    = vet010.cd_setor_atendimento;
                    end;
                end if;
                end;
            end if;
        end if;
        /* Inserir o registro na conta de debito */

        ds_atributos_w  :=  'NR_INTERNO_CONTA=' || vet010.nr_interno_conta;

        ctb_obter_doc_movto(    cd_tipo_lote_contabil_w,
                    null,
                    'VR',
                    dt_movimento_w,
                    null,
                    null,
                    ds_atributos_w,
                    nm_usuario_p,
                    ie_regra_w,
                    nr_documento_ww,
                    ie_origem_documento_w);

        /* Movimento de Debito  */

        get_sequence;
        ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
        ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
        ctb_movimento_doc_w.cd_estabelecimento      := vetEstab.cd_estabelecimento;

        if (ctb_movimento_doc_w.cd_centro_custo IS NOT NULL AND ctb_movimento_doc_w.cd_centro_custo::text <> '') then
            begin
            select  cd_estabelecimento
            into STRICT    ctb_movimento_doc_w.cd_estabelecimento
            from    centro_custo
            where   cd_centro_custo = ctb_movimento_doc_w.cd_centro_custo;
            exception when others then
                ctb_movimento_doc_w.cd_estabelecimento  := vetEstab.cd_estabelecimento;
            end;
        end if;

        ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
        ctb_movimento_doc_w.vl_movimento        := vet010.vl_receita;
        ctb_movimento_doc_w.cd_conta_debito     := cd_conta_debito_w;
        ctb_movimento_doc_w.cd_historico        := ctb_param_lote_pre_fatur_w.cd_historico;
        ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
        ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
        ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
        ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
        ctb_movimento_doc_w.ie_transitorio      := 'N';
        ctb_movimento_doc_w.nm_tabela           := 'PRE_FATURAMENTO';
        ctb_movimento_doc_w.nm_atributo         := 'VL_RECEITA';
        ctb_movimento_doc_w.nr_seq_info         := 89;
        ctb_movimento_doc_w.nr_seq_classif_movto    := nr_seq_classif_movto_w;
        ctb_movimento_doc_w.cd_sequencia_parametro  := null;

         ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
								
			
		if (coalesce(cd_conta_contabil_conv_w, '0') <> '0') then
			if (ctb_param_lote_pre_fatur_w.ie_contab_cc_debito = 'S') then
                begin
					select  coalesce(max(ie_centro_custo),'N')
					into STRICT    ie_centro_custo_w
					from    conta_contabil
					where   cd_conta_contabil = cd_conta_debito_w;
                if (ie_centro_custo_w = 'S') then
                    begin
						select  max(cd_centro_custo)
						into STRICT    ctb_movimento_doc_w.cd_centro_custo
						from    setor_atendimento
						where   cd_setor_atendimento    = vet010.cd_setor_atendimento;
                    end;
                end if;
                end;
			end if;
			
			ctb_movimento_doc_w.cd_conta_debito     := cd_conta_contabil_conv_w;
			ctb_movimento_doc_w.vl_movimento		:= vet010.vl_desc_item_neg;
			
			if (ctb_movimento_doc_w.cd_centro_custo IS NOT NULL AND ctb_movimento_doc_w.cd_centro_custo::text <> '') then
				begin
					select  max(cd_estabelecimento)
					into STRICT    ctb_movimento_doc_w.cd_estabelecimento
					from    centro_custo
					where   cd_centro_custo = ctb_movimento_doc_w.cd_centro_custo;
				exception when no_data_found then
						ctb_movimento_doc_w.cd_estabelecimento  := vetEstab.cd_estabelecimento;
				end;
			end if;
			
			 ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
		end if;
        /*==FIM Movimento de debito */



        /* Inserir o registro na conta de credito - Repasse ctb_param_lote_pre_fatur_w.ie_contab_repasse_prefatur = 'S' Separa o valor do repasse em conta informa */

        if (ctb_param_lote_pre_fatur_w.ie_contab_repasse_prefatur = 'S') and (ctb_param_lote_pre_fatur_w.cd_conta_repasse IS NOT NULL AND ctb_param_lote_pre_fatur_w.cd_conta_repasse::text <> '') and (vet010.vl_repasse <> 0) then

            vet010.vl_receita       := vet010.vl_receita - vet010.vl_repasse;

            /* Credito do Repasse a pagar*/

            ctb_movimento_doc_w := null;
            get_sequence;
            ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
            ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
            ctb_movimento_doc_w.cd_estabelecimento      := vetEstab.cd_estabelecimento;
            ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
            ctb_movimento_doc_w.vl_movimento        := vet010.vl_repasse;
            ctb_movimento_doc_w.cd_conta_credito        := ctb_param_lote_pre_fatur_w.cd_conta_repasse;
            ctb_movimento_doc_w.cd_historico        := ctb_param_lote_pre_fatur_w.cd_historico;
            ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
            ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
            ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
            ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
            ctb_movimento_doc_w.ie_transitorio      := 'N';
            ctb_movimento_doc_w.nm_tabela           := 'PRE_FATURAMENTO';
            ctb_movimento_doc_w.nm_atributo         := 'VL_REPASSE_CALC';
            ctb_movimento_doc_w.nr_seq_info         := 89;
            ctb_movimento_doc_w.nr_seq_classif_movto    := nr_seq_classif_movto_w;
            ctb_movimento_doc_w.cd_sequencia_parametro  := null;

             ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'S');

            if (ctb_param_lote_pre_fatur_w.ie_despesa_pre_fatur = 'S') and (coalesce(vet010.cd_conta_desp_pre_fatur,'0') <> '0') then
                begin
                vet010.vl_receita       := vl_receita_orig_w - vet010.vl_repasse;

                /* DEBITO */

                ctb_movimento_doc_w := null;
                get_sequence;
                ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
                ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
                ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
                ctb_movimento_doc_w.vl_movimento        := vet010.vl_repasse;
                ctb_movimento_doc_w.cd_conta_debito     := vet010.cd_conta_desp_pre_fatur;
                ctb_movimento_doc_w.cd_historico        := ctb_param_lote_pre_fatur_w.cd_historico;
                ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
                ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
                ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
                ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
                ctb_movimento_doc_w.ie_transitorio      := 'N';
                ctb_movimento_doc_w.nm_tabela           := 'PRE_FATURAMENTO';
                ctb_movimento_doc_w.nm_atributo         := 'VL_REPASSE_CALC';
                ctb_movimento_doc_w.nr_seq_info         := 89;
                ctb_movimento_doc_w.nr_seq_classif_movto    := nr_seq_classif_movto_w;
                ctb_movimento_doc_w.cd_sequencia_parametro  := null;

                select  CASE WHEN ie_centro_custo='S' THEN vet010.cd_centro_receita  ELSE null END
                into STRICT    ctb_movimento_doc_w.cd_centro_custo
                from    conta_contabil
                where   cd_conta_contabil   = vet010.cd_conta_desp_pre_fatur;

                ctb_movimento_doc_w.cd_estabelecimento      := vetEstab.cd_estabelecimento;

                if (ctb_movimento_doc_w.cd_centro_custo IS NOT NULL AND ctb_movimento_doc_w.cd_centro_custo::text <> '') then
                    ctb_movimento_doc_w.cd_estabelecimento  := cd_estab_movto_receita_w;
                end if;

                 ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
                end;
            end if;
        end if;

        if (qt_regra_cta_prefatur_w > 0) then
            vet010.cd_conta_receita := ctb_obter_cta_prefatur(  vetEstab.cd_empresa,
                                        cd_estabelecimento_p,
                                        vet010.cd_conta_receita,
                                        dt_movimento_w);
			vet010.cd_sequencia_parametro := null;
        end if;

        /* Inserir o registro na conta de credito - Receita */

        if (ctb_param_lote_pre_fatur_w.ie_despesa_pre_fatur = 'S') then
            vet010.vl_receita       := vl_receita_orig_w;
        end if;

        /* CREDITO - Receita */

        ctb_movimento_doc_w := null;
        get_sequence;
        ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
        ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
        ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
        ctb_movimento_doc_w.vl_movimento        := vet010.vl_receita;
        ctb_movimento_doc_w.cd_conta_credito        := vet010.cd_conta_receita;
        ctb_movimento_doc_w.cd_historico        := ctb_param_lote_pre_fatur_w.cd_historico;
        ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
        ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
        ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
        ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
        ctb_movimento_doc_w.ie_transitorio      := 'N';
        ctb_movimento_doc_w.nm_tabela           := 'PRE_FATURAMENTO';
        ctb_movimento_doc_w.nm_atributo         := 'VL_RECEITA';
        ctb_movimento_doc_w.nr_seq_info         := 89;
        ctb_movimento_doc_w.nr_seq_classif_movto    := nr_seq_classif_movto_w;
        ctb_movimento_doc_w.cd_sequencia_parametro  := vet010.cd_sequencia_parametro;

        begin
        select  CASE WHEN ie_centro_custo='S' THEN vet010.cd_centro_receita  ELSE null END
        into STRICT    ctb_movimento_doc_w.cd_centro_custo
        from    conta_contabil
        where   cd_conta_contabil   = vet010.cd_conta_receita;
        exception when others then
            ctb_movimento_doc_w.cd_centro_custo := null;
        end;
        ctb_movimento_doc_w.cd_estabelecimento      := vetEstab.cd_estabelecimento;

        if (ctb_movimento_doc_w.cd_centro_custo IS NOT NULL AND ctb_movimento_doc_w.cd_centro_custo::text <> '') then
            ctb_movimento_doc_w.cd_estabelecimento  := cd_estab_movto_receita_w;
        end if;

         ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
        end;
		
		if (coalesce(cd_conta_contabil_conv_w, '0') <> '0') then
			ctb_movimento_doc_w.vl_movimento        := vet010.vl_desc_item_neg;
			
			 ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
		end if;

    end loop;
    close c010;

    open c015;
        loop
        fetch c015 into
            c015_w;
        EXIT WHEN NOT FOUND; /* apply on c015 */
            begin
            begin
            select  nr_atendimento,
                cd_categoria_parametro
            into STRICT    nr_atendimento_w,
                cd_categoria_w
            from    conta_paciente
            where   nr_interno_conta    = c015_w.nr_interno_conta;
            exception when others then
                nr_atendimento_w    := null;
                cd_categoria_w      := '';
            end;

            if (nm_agrupador_w = 'NR_INTERNO_CONTA')then
                nr_seq_agrupamento_w    := c015_w.nr_interno_conta;
            elsif (nm_agrupador_w = 'NR_ATENDIMENTO')then
                nr_seq_agrupamento_w    := nr_atendimento_w;
            elsif (nm_agrupador_w = 'DS_MESANO')then
                nr_seq_agrupamento_w    := dt_referencia_mesano_w;
            elsif (nm_agrupador_w = 'CD_CONVENIO')then
                nr_seq_agrupamento_w    := c015_w.cd_convenio;
            end if;

            if (nr_atendimento_w <> 0) and (c015_w.nr_interno_conta <> 0) then
                begin
                nm_paciente_w   := substr(obter_paciente_conta(c015_w.nr_interno_conta, 'D'),1,80);
                exception when others then
                    nm_paciente_w := '';
                end;
            end if;

            ds_atributos_w  :=  'NR_INTERNO_CONTA=' || c015_w.nr_interno_conta;

            ctb_obter_doc_movto(    cd_tipo_lote_contabil_w,
                null,
                'VR',
                dt_movimento_w,
                null,
                null,
                ds_atributos_w,
                nm_usuario_p,
                ie_regra_w,
                nr_documento_ww,
                ie_origem_documento_w);

            select  coalesce(max(c.cd_historico), 0),
                        max(t.ds_tributo)
            into STRICT        cd_historico_tributo_w,
                        ds_tributo_w
            from    ctb_regra_tributo_pre_fat c,
                        tributo t
            where   t.cd_tributo = c.cd_tributo
            and         c.cd_tributo = c015_w.cd_tributo;

            CALL ctb_online_pck.set_value_compl_hist('DS_CONVENIO', c015_w.ds_convenio);
            CALL ctb_online_pck.set_value_compl_hist('DS_MESANO_REFERENCIA', ds_mesano_referencia_w);
            CALL ctb_online_pck.set_value_compl_hist('NR_INTERNO_CONTA', c015_w.nr_interno_conta );
            CALL ctb_online_pck.set_value_compl_hist('NR_ATENDIMENTO', nr_atendimento_w);
            CALL ctb_online_pck.set_value_compl_hist('NM_PACIENTE', nm_paciente_w);
            CALL ctb_online_pck.set_value_compl_hist('DS_TRIBUTO', ds_tributo_w);

            /* Obtem Historico */

            ds_compl_historico_w := ctb_online_pck.ctb_obter_compl_Historico( cd_tipo_lote_contabil_w, cd_historico_tributo_w);

            ctb_movimento_doc_w :=  null;
            get_sequence;

            if (c015_w.cd_conta_debito IS NOT NULL AND c015_w.cd_conta_debito::text <> '') then
                select  CASE WHEN ie_centro_custo='S' THEN c015_w.cd_centro_receita  ELSE null END
                into STRICT    ctb_movimento_doc_w.cd_centro_custo
                from    conta_contabil
                where   cd_conta_contabil = c015_w.cd_conta_debito;
            end if;

            if (coalesce(c015_w.cd_centro_receita,0) <> 0) then
                select  cd_estabelecimento
                into STRICT    cd_estab_movto_receita_w
                from    centro_custo
                where   cd_centro_custo = c015_w.cd_centro_receita;
            else
                cd_estab_movto_receita_w := vetEstab.cd_estabelecimento;
            end if;

            ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
            ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
            ctb_movimento_doc_w.cd_estabelecimento      := cd_estab_movto_receita_w;
            ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
            ctb_movimento_doc_w.vl_movimento        := c015_w.vl_tributo;
            ctb_movimento_doc_w.cd_historico        := cd_historico_tributo_w;
            ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
            ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
            ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
            ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
            ctb_movimento_doc_w.ie_transitorio      := 'N';
            ctb_movimento_doc_w.nm_tabela           := 'PRE_FATUR_TRIBUTO';
            ctb_movimento_doc_w.nm_atributo         := 'VL_TRIBUTO';
            ctb_movimento_doc_w.nr_seq_info         := 89;
            ctb_movimento_doc_w.nr_seq_classif_movto    := null;
            ctb_movimento_doc_w.cd_conta_debito     := c015_w.cd_conta_debito;
            ctb_movimento_doc_w.cd_conta_credito        := null;
            ctb_movimento_doc_w.cd_sequencia_parametro  := null;

            ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto(ctb_movimento_doc_w, nm_usuario_p, 'N');

            ctb_movimento_doc_w := null;
            get_sequence;

            if (c015_w.cd_conta_credito IS NOT NULL AND c015_w.cd_conta_credito::text <> '') then
                select  CASE WHEN ie_centro_custo='S' THEN c015_w.cd_centro_receita  ELSE null END
                into STRICT    ctb_movimento_doc_w.cd_centro_custo
                from    conta_contabil
                where   cd_conta_contabil = c015_w.cd_conta_credito;
            end if;

            if (coalesce(c015_w.cd_centro_receita,0) <> 0) then
                select  cd_estabelecimento
                into STRICT    cd_estab_movto_receita_w
                from    centro_custo
                where   cd_centro_custo = c015_w.cd_centro_receita;
            else
                cd_estab_movto_receita_w := vetEstab.cd_estabelecimento;
            end if;

            ctb_movimento_doc_w.nr_lote_contabil        := nr_lote_contabil_w;
            ctb_movimento_doc_w.cd_tipo_lote_contabil   := cd_tipo_lote_contabil_w;
            ctb_movimento_doc_w.cd_estabelecimento      := cd_estab_movto_receita_w;
            ctb_movimento_doc_w.dt_movimento        := dt_movimento_w;
            ctb_movimento_doc_w.vl_movimento        := c015_w.vl_tributo;
            ctb_movimento_doc_w.cd_historico        := cd_historico_tributo_w;
            ctb_movimento_doc_w.nr_seq_agrupamento      := nr_seq_agrupamento_w;
            ctb_movimento_doc_w.ds_compl_historico      := ds_compl_historico_w;
            ctb_movimento_doc_w.nr_documento        := nr_documento_ww;
            ctb_movimento_doc_w.ie_origem_documento     := ie_origem_documento_w;
            ctb_movimento_doc_w.ie_transitorio      := 'N';
            ctb_movimento_doc_w.nm_tabela           := 'PRE_FATUR_TRIBUTO';
            ctb_movimento_doc_w.nm_atributo         := 'VL_TRIBUTO';
            ctb_movimento_doc_w.nr_seq_info         := 89;
            ctb_movimento_doc_w.nr_seq_classif_movto    := null;
            ctb_movimento_doc_w.cd_conta_debito     := null;
            ctb_movimento_doc_w.cd_conta_credito        := c015_w.cd_conta_credito;
            ctb_movimento_doc_w.cd_sequencia_parametro  := null;

            ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto(ctb_movimento_doc_w, nm_usuario_p, 'N');
            end;
        end loop;
    close c015;

    /*  Reverter os lancamentos no primeiro dia do mes subsequente */

    dt_estorno_w    := pkg_date_utils.start_of(pkg_date_utils.add_month(dt_referencia_p,1,0),'month',0);

    open c020;
    loop
    fetch c020 into
          c020_w;
    EXIT WHEN NOT FOUND; /* apply on c020 */
        begin
        ctb_movimento_doc_w             := null;
        get_sequence;
        ctb_movimento_doc_w.cd_centro_custo     :=  null;
        ctb_movimento_doc_w.cd_conta_credito        :=  c020_w.cd_conta_debito;
        ctb_movimento_doc_w.cd_classif_credito      :=  c020_w.cd_classif_debito;
        ctb_movimento_doc_w.cd_conta_debito     :=  c020_w.cd_conta_credito;
        ctb_movimento_doc_w.cd_classif_debito       :=  c020_w.cd_classif_credito;
        ctb_movimento_doc_w.cd_estabelecimento      :=  c020_w.cd_estabelecimento;
        ctb_movimento_doc_w.cd_historico        :=  c020_w.cd_historico;
        ctb_movimento_doc_w.cd_tipo_lote_contabil   :=      cd_tipo_lote_contabil_w;
        ctb_movimento_doc_w.ds_compl_historico      :=  substr(c020_w.ds_compl_historico || wheb_mensagem_pck.get_texto(299564),1,255);
        ctb_movimento_doc_w.dt_movimento        :=  dt_estorno_w;
        ctb_movimento_doc_w.ie_origem_documento     :=  c020_w.ie_origem_documento;
        ctb_movimento_doc_w.ie_transitorio      :=  c020_w.ie_transitorio;
        ctb_movimento_doc_w.nr_documento        :=  c020_w.nr_documento;
        ctb_movimento_doc_w.nr_lote_contabil        :=  nr_lote_contabil_w;
        ctb_movimento_doc_w.nr_seq_agrupamento      :=  c020_w.nr_seq_agrupamento;
        ctb_movimento_doc_w.vl_movimento        :=  c020_w.vl_movimento;
        ctb_movimento_doc_w.nr_seq_classif_movto    :=  c020_w.nr_seq_classif_movto;
        ctb_movimento_doc_w.cd_sequencia_parametro  := null;

        for vet in (SELECT   a.cd_centro_custo,
                    a.vl_movimento
               from     ctb_movto_centro_custo a
               where    a.nr_seq_movimento  = c020_w.nr_sequencia) loop
            begin
            ctb_movimento_doc_w.cd_centro_custo := vet.cd_centro_custo;
            ctb_movimento_doc_w.vl_movimento    := vet.vl_movimento;
             ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
            end;
        end loop;

        if (coalesce(ctb_movimento_doc_w.cd_centro_custo::text, '') = '') then
             ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto( ctb_movimento_doc_w, nm_usuario_p, 'N');
        end if;
        end;
    end loop;
    close c020;

    /* Atualiza SALDO Movimento     */

        begin
    ds_erro_w := ctb_atualizar_saldo( nr_lote_contabil_w, 'S', nm_usuario_p, 'N', ds_erro_w, 'S');
        exception
        when others then
                null;
        end;

    /* Atualizar LOTE CONTABIL      */

    update  lote_contabil
    set dt_geracao_lote  = clock_timestamp(),
        dt_integracao    = clock_timestamp()
    where   nr_lote_contabil = nr_lote_contabil_w;
    end;
end loop;
close c_estab;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_contab_onl_pre_fatur ( cd_estabelecimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
