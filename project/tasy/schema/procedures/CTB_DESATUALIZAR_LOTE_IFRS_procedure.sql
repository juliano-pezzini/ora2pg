-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_desatualizar_lote_ifrs ( nr_lote_contabil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


        nr_sequencia_w          ctb_saldo_ifrs.nr_sequencia%type;
        nr_seq_conta_ifrs_w     ctb_saldo_ifrs.nr_seq_conta_ifrs%type;
        vl_debito_w		ctb_saldo_ifrs.vl_debito%type;
        vl_credito_w		ctb_saldo_ifrs.vl_credito%type;
        vl_saldo_w		ctb_saldo_ifrs.vl_saldo%type;
        nr_seq_movimento_w      ctb_movto_ifrs_cc.nr_seq_movto_ifrs%type;
        cd_centro_custo_w       ctb_movto_ifrs_cc.cd_centro_custo%type;
        vl_movimento_w          ctb_movto_ifrs.vl_movimento%type;
        vl_encerramento_w       ctb_movto_ifrs.vl_movimento%type;
        cd_estabelecimento_w    ctb_movto_ifrs.cd_estabelecimento%type;
        cd_estab_lote_w		ctb_movto_ifrs.cd_estabelecimento%type;
        ie_encerramento_w	lote_contabil.ie_encerramento%type;
        nr_seq_mes_ref_w	lote_contabil.nr_seq_mes_ref%type;
        dt_atualizacao_w	lote_contabil.dt_atualizacao_saldo%type;
        nr_seq_mes_ant_w	ctb_mes_ref.nr_sequencia%type;
        cd_empresa_w		ctb_mes_ref.cd_empresa%type;
        dt_referencia_w		ctb_mes_ref.dt_referencia%type;
        dt_abertura_w		ctb_mes_ref.dt_abertura%type;
        dt_fechamento_w		ctb_mes_ref.dt_fechamento%type;
        ie_centro_custo_w	conta_contabil.ie_centro_custo%type;
        cd_classificacao_w	conta_contabil.cd_classificacao%type;
        cd_classif_sup_w	conta_contabil_classif.cd_classif_superior%type;
        ie_deb_cred_w		varchar(1);
        qt_movto_cc_w		bigint;
        nr_nivel_conta_w	bigint;
        cd_perfil_w		integer;

        C01 CURSOR FOR
        SELECT	a.nr_sequencia,
                a.vl_movimento,
                'D' ie_deb_cred,
                d.ie_centro_custo,
                CASE WHEN ie_encerramento_w='N' THEN 0  ELSE a.vl_movimento END  vl_encerramento,
                d.cd_classificacao,
                coalesce(a.cd_estabelecimento, cd_estab_lote_w) cd_estabelecimento,
                coalesce(a.nr_seq_conta_debito,0) nr_seq_conta_ifrs
        from    lote_contabil b,
                ctb_movto_ifrs a,
                conta_contabil_ifrs c,
                conta_contabil d
        where   a.nr_lote_contabil = nr_lote_contabil_p
        and     a.nr_lote_contabil = b.nr_lote_contabil
        and     (a.nr_seq_conta_debito IS NOT NULL AND a.nr_seq_conta_debito::text <> '')
        and     a.nr_seq_conta_debito = c.nr_seq_conta_ifrs
        and     c.cd_conta_contabil = d.cd_conta_contabil

union all

        SELECT	a.nr_sequencia,
                a.vl_movimento,
                'C' ie_deb_cred,
                d.ie_centro_custo,
                CASE WHEN ie_encerramento_w='N' THEN 0  ELSE a.vl_movimento END  vl_encerramento,
                d.cd_classificacao,
                coalesce(a.cd_estabelecimento, cd_estab_lote_w) cd_estabelecimento,
                coalesce(a.nr_seq_conta_credito,0) nr_seq_conta_ifrs
        from    lote_contabil b,
                ctb_movto_ifrs a,
                conta_contabil_ifrs c,
                conta_contabil d
        where   a.nr_lote_contabil  = nr_lote_contabil_p
        and     a.nr_lote_contabil = b.nr_lote_contabil
        and     (a.nr_seq_conta_credito IS NOT NULL AND a.nr_seq_conta_credito::text <> '')
        and     a.nr_seq_conta_credito = c.nr_seq_conta_ifrs
        and     c.cd_conta_contabil = d.cd_conta_contabil;

        C02 CURSOR FOR
        SELECT	cd_centro_custo,
                vl_movimento * -1,
                CASE WHEN ie_encerramento_w='N' THEN 0  ELSE vl_movimento * -1 END  vl_encerramento
        from	ctb_movto_ifrs_cc
        where	nr_seq_movto_ifrs = nr_seq_movimento_w
        and	ie_centro_custo_w in ('S','O')

union all

        SELECT	0,
                vl_movimento_w * -1,
                vl_encerramento_w * -1
        
        where	((ie_centro_custo_w = 'N') or (qt_movto_cc_w = 0));


BEGIN
        cd_perfil_w := wheb_usuario_pck.get_cd_perfil;

        begin
                select  nr_seq_mes_ref,
                        cd_estabelecimento,
                        dt_atualizacao_saldo,
                        coalesce(ie_encerramento,'N')
                into STRICT	nr_seq_mes_ref_w,
                        cd_estab_lote_w,
                        dt_atualizacao_w,
                        ie_encerramento_w
                from	lote_contabil
                where	nr_lote_contabil = nr_lote_contabil_p;
        exception
        when no_data_found then
                nr_seq_mes_ref_w := null;
                cd_estab_lote_w := null;
                dt_atualizacao_w := null;
                ie_encerramento_w := null;
        when too_many_rows then
                nr_seq_mes_ref_w := null;
                cd_estab_lote_w := null;
                dt_atualizacao_w := null;
                ie_encerramento_w := null;
        end;

        begin
                select	cd_empresa,
                        dt_referencia,
                        dt_abertura,
                        dt_fechamento
                into STRICT	cd_empresa_w,
                        dt_referencia_w,
                        dt_abertura_w,
                        dt_fechamento_w
                from	ctb_mes_ref
                where	nr_sequencia = nr_seq_mes_ref_w;
        exception
        when no_data_found then
                cd_empresa_w := null;
                dt_referencia_w := null;
                dt_abertura_w := null;
                dt_fechamento_w := null;
        when too_many_rows then
                cd_empresa_w := null;
                dt_referencia_w := null;
                dt_abertura_w := null;
                dt_fechamento_w := null;
        end;

        select  coalesce(max(nr_sequencia),0)
        into STRICT	nr_seq_mes_ant_w
        from	ctb_mes_ref
        where	cd_empresa = cd_empresa_w
        and	dt_referencia = pkg_date_utils.start_of(pkg_date_utils.add_month(dt_referencia_w,-1,0),'month',0);

        if (coalesce(dt_atualizacao_w::text, '') = '')  then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(266436);
        end if;

        if (coalesce(dt_abertura_w::text, '') = '' or (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '')) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(266437);
        end if;

        CALL ctb_gravar_log_lote(nr_lote_contabil_p,6,null,nm_usuario_p);

        OPEN C01;
        LOOP
        FETCH C01 INTO
                nr_seq_movimento_w,
                vl_movimento_w,
                ie_deb_cred_w,
                ie_centro_custo_w,
                vl_encerramento_w,
                cd_classificacao_w,
                cd_estabelecimento_w,
                nr_seq_conta_ifrs_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */

                cd_classif_sup_w := substr(ctb_obter_classif_conta_sup(cd_classificacao_w, dt_referencia_w, cd_empresa_w),1,40);
                nr_nivel_conta_w := ctb_obter_nivel_classif_conta(cd_classificacao_w);

                begin
                        select	1
                        into STRICT    qt_movto_cc_w

                        where   exists (
                                        SELECT 1
                                        from	ctb_movto_ifrs_cc
                                        where	nr_seq_movto_ifrs = nr_seq_movimento_w
                                );
                exception
                when no_data_found then
                        qt_movto_cc_w := 0;
                end;

                if (ie_encerramento_w = 'N' and ie_centro_custo_w = 'O' and qt_movto_cc_w = 0) then
                        ie_centro_custo_w := 'N';
                end if;

                OPEN C02;
                LOOP
                FETCH C02 INTO
                        cd_centro_custo_w,
                        vl_movimento_w,
                        vl_encerramento_w;
                EXIT WHEN NOT FOUND; /* apply on C02 */
                        if (cd_centro_custo_w = 0) then
                                cd_centro_custo_w	:= null;
                        end if;

                        select	coalesce(max(nr_sequencia),0)
                        into STRICT	nr_sequencia_w
                        from	ctb_saldo_ifrs
                        where	nr_seq_mes_ref	= nr_seq_mes_ref_w
                        and	cd_estabelecimento	= cd_estabelecimento_w
                        and     nr_seq_conta_ifrs       = nr_seq_conta_ifrs_w
                        and	coalesce(cd_centro_custo,0)	= coalesce(cd_centro_custo_w,0);

                        if (nr_sequencia_w = 0) then
                                vl_saldo_w := 0;

                                select	nextval('ctb_saldo_ifrs_seq')
                                into STRICT	nr_sequencia_w
;

                                if (nr_seq_mes_ant_w > 0) then
                                        select  coalesce(max(vl_saldo),0)
                                        into STRICT	vl_saldo_w
                                        from	ctb_saldo_ifrs
                                        where	nr_seq_mes_ref = nr_seq_mes_ant_w
                                        and	cd_estabelecimento = cd_estabelecimento_w
                                        and     nr_seq_conta_ifrs = nr_seq_conta_ifrs_w
                                        and	coalesce(cd_centro_custo,0) = coalesce(cd_centro_custo_w,0);
                                end if;

                                insert into ctb_saldo_ifrs(
                                        nr_sequencia,
                                        nr_seq_mes_ref,
                                        nr_seq_conta_ifrs,
                                        dt_atualizacao,
                                        nm_usuario,
                                        cd_estabelecimento,
                                        cd_centro_custo,
                                        vl_debito,
                                        vl_debito_origem,
                                        vl_encerramento,
                                        vl_credito,
                                        vl_credito_origem,
                                        vl_movimento,
                                        vl_movimento_origem,
                                        vl_saldo,
                                        vl_saldo_origem,
                                        cd_classificacao,
                                        cd_classif_sup,
                                        nr_nivel_conta)
                                values ( nr_sequencia_w,
                                        nr_seq_mes_ref_w,
                                        nr_seq_conta_ifrs_w,
                                        clock_timestamp(),
                                        nm_usuario_p,
                                        cd_estabelecimento_w,
                                        cd_centro_custo_w,
                                        0, 0, 0, 0, 0, 0, 0,
                                        vl_saldo_w,
                                        0,
                                        cd_classificacao_w,
                                        cd_classif_sup_w,
                                        nr_nivel_conta_w);
                        end if;

                        vl_debito_w := 0;
                        vl_credito_w := 0;

                        if (ie_deb_cred_w = 'D') then
                                vl_debito_w := vl_movimento_w;
                        else
                                vl_credito_w := vl_movimento_w;
                        end if;

                        update	ctb_saldo_ifrs
                        set	dt_atualizacao	= clock_timestamp(),
                                nm_usuario = nm_usuario_p,
                                vl_debito = vl_debito + vl_debito_w,
                                vl_credito = vl_credito + vl_credito_w,
                                vl_saldo = vl_saldo + vl_movimento_w,
                                vl_movimento = vl_movimento + vl_movimento_w,
                                vl_encerramento = vl_encerramento + vl_encerramento_w,
                                cd_classificacao = cd_classificacao_w,
                                cd_classif_sup = cd_classif_sup_w,
                                nr_nivel_conta = nr_nivel_conta_w
                        where	nr_sequencia = nr_sequencia_w;
                END LOOP;
                CLOSE C02;
        END LOOP;
        CLOSE C01;

        update	lote_contabil
        set	dt_atualizacao_saldo  = NULL,
                dt_consistencia	 = NULL
        where	nr_lote_contabil = nr_lote_contabil_p;

        commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_desatualizar_lote_ifrs ( nr_lote_contabil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

