-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_imposto_tit_rec ( nr_titulo_p titulo_receber_trib.nr_titulo%type, nr_seq_tit_liq_p titulo_receber_liq.nr_sequencia%type, vl_baixa_p titulo_receber_trib_baixa.vl_baixa%type, nm_usuario_p titulo_receber_trib_baixa.nm_usuario%type, nr_seq_liq_origem_p titulo_receber_trib.nr_sequencia%type, ie_gerar_baixa_trib_p titulo_receber_liq.ie_acao%type default 'S', dt_receb_baixa_p titulo_receber_liq.dt_recebimento%type default null, cd_estab_baixa_p titulo_receber.cd_estabelecimento%type default null) AS $body$
DECLARE


/*
C = Calculado pelo sistema
D = Digitado pelo usuario
CD = Calculado e diminui saldo
*/
vl_titulo_w             titulo_receber.vl_titulo%type;
nr_sequencia_w          titulo_receber_trib.nr_sequencia%type;
nr_seq_trans_tit_rec_w  tributo.nr_seq_trans_tit_rec%type;
vl_tributo_w            titulo_receber_trib.vl_tributo%type;
vl_baixa_w              titulo_receber_trib_baixa.vl_baixa%type;
vl_tit_baixa_w          titulo_receber_trib_baixa.vl_baixa%type;
ie_origem_tributo_w     titulo_receber_trib.ie_origem_tributo%type;
ie_baixa_trib_prop_w    parametro_contas_receber.ie_baixa_trib_prop%type;
cd_estabelecimento_w    titulo_receber.cd_estabelecimento%type;
nr_seq_trans_financ_w   titulo_receber_trib.nr_seq_trans_financ%type;
vl_total_tributo_w      titulo_receber_trib.vl_tributo%type;
vl_saldo_tributo_w      titulo_receber_trib.vl_saldo%type;
vl_trib_controle_w      titulo_receber_trib.vl_tributo%type := 0;
qt_tributo_w            bigint := 0;
qt_contador_w           bigint := 0;
vl_ajuste_trib_w        titulo_receber_trib.vl_tributo%type := 0;
vl_recebido_w           titulo_receber_liq.vl_recebido%type;
vl_baixa_percent_w      double precision;
ie_gerar_w              varchar(1) := 'S';
qt_reg_w                bigint;
vl_baixa_1_w            double precision;
nr_seq_trib_baixa_w     titulo_receber_trib_baixa.nr_sequencia%type;
ie_concil_contab_w      pls_visible_false.ie_concil_contab%type;

C01 CURSOR FOR
    SELECT  a.nr_sequencia,
            a.vl_tributo,
            b.nr_seq_trans_tit_rec,
            coalesce(a.ie_origem_tributo,'C'),
            a.nr_seq_trans_financ
    from    tributo         b,
            titulo_receber_trib a
    where   a.nr_titulo = nr_titulo_p
    and     a.cd_tributo    = b.cd_tributo
    and     a.vl_tributo    > 0
    and (a.vl_saldo > 0 or (nr_seq_liq_origem_p IS NOT NULL AND nr_seq_liq_origem_p::text <> ''))
    and     (a.vl_saldo IS NOT NULL AND a.vl_saldo::text <> '')
    and     coalesce(ie_gerar_baixa_trib_p,'S') = 'S' --Usado para o MX.
    order by a.vl_tributo asc;


BEGIN
    vl_baixa_w      := 0;
    vl_baixa_1_w    := 0;

    select  max(obter_dados_titulo_receber(t.nr_titulo,'V')) vl_titulo,
            max(t.cd_estabelecimento)
    into STRICT    vl_titulo_w,
            cd_estabelecimento_w
    from    titulo_receber t
    where   t.nr_titulo   = nr_titulo_p;

    select  coalesce(sum(a.vl_tributo),0)
    into STRICT    vl_total_tributo_w
    from    titulo_receber_trib a
    where   a.nr_titulo = nr_titulo_p
    and     coalesce(a.ie_origem_tributo, 'C') in ('D','CD');

    select  coalesce(max(a.ie_baixa_trib_prop), 'N')
    into STRICT    ie_baixa_trib_prop_w
    from    parametro_contas_receber a
    where   a.cd_estabelecimento    = cd_estabelecimento_w;

    /*select  count(a.nr_sequencia)
    into    qt_tributo_w
    from    tributo         b,
            titulo_receber_trib a
    where   a.nr_titulo = nr_titulo_p
    and     a.cd_tributo    = b.cd_tributo
    and     a.vl_tributo    > 0
    and     (a.vl_saldo > 0 or nr_seq_liq_origem_p is not null)
    and     a.vl_saldo is not null;*/
    select  coalesce(max(ie_concil_contab), 'N')
    into STRICT    ie_concil_contab_w
    from    pls_visible_false;

    open c01;
    loop
    fetch c01 into
        nr_sequencia_w,
        vl_tributo_w,
        nr_seq_trans_tit_rec_w,
        ie_origem_tributo_w,
        nr_seq_trans_financ_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */

        -- Edgar 07/03/2008, OS 82461, incluido tratamento ie_origem_tributo_w
        if (coalesce(ie_origem_tributo_w,'C') <> 'D') or (coalesce(ie_baixa_trib_prop_w, 'N') = 'S') then
            vl_baixa_1_w    := dividir_sem_round((vl_baixa_p * 100), coalesce(vl_titulo_w,0) - coalesce(vl_total_tributo_w,0));
            vl_baixa_1_w    := dividir_sem_round((vl_baixa_1_w * vl_tributo_w)::numeric, 100);

            vl_baixa_w := vl_baixa_1_w;
            if (coalesce(nr_seq_liq_origem_p::text, '') = '') then

                select  max(a.vl_saldo)
                into STRICT    vl_saldo_tributo_w
                from    titulo_receber_trib a
                where   a.nr_sequencia  = nr_sequencia_w
                and     a.nr_titulo     = nr_titulo_p;

                if (coalesce(vl_baixa_w,0)  > coalesce(vl_saldo_tributo_w,0)) then
                    vl_baixa_w  := coalesce(vl_saldo_tributo_w,0);
                end if;

            end if;

        vl_trib_controle_w  := coalesce(vl_trib_controle_w,0) + coalesce(vl_baixa_w,0); /*variavel que recebe as baixas do tributo e vai somando*/
        qt_contador_w       := coalesce(qt_contador_w,0) + 1; /*variavel que veriifca em qual tributo e a baixa, um controle para identificar quando sera o ultimo tibuto a ser baixado*/


        /*if (qt_contador_w = qt_tributo_w) then --se for o ultimo tributo a ser baixado, verifica se sera realizado arredondadmento

            if ( nvl(vl_titulo_w,0) <> 0 ) or ( nvl(vl_total_tributo_w,0) <> 0 ) then --O divisor nao pode ser zero nas contas abaixo, por isso esse if

                vl_baixa_percent_w  := ( (vl_baixa_p * 100) / (vl_titulo_w - vl_total_tributo_w) ); --aqui busca o percentual da baixa do tributo refernte ao seu total

                vl_baixa_percent_w  := ((vl_baixa_percent_w / 100) * vl_total_tributo_w ); --aqui calcula quanto equivale esse percentual da baixa em tributos

                vl_baixa_percent_w  := trunc(vl_baixa_percent_w,2);

            end if;

            if (vl_trib_controle_w > vl_baixa_percent_w) then --se o total

                vl_ajuste_trib_w    := vl_trib_controle_w - vl_baixa_percent_w; --esse valor deve ser diminuido do vl_baixa
                vl_baixa_w          := vl_baixa_w - vl_ajuste_trib_w;

            elsif (vl_trib_controle_w < vl_baixa_percent_w) then --esse valor deve ser somado ao v_baixa

                vl_ajuste_trib_w    := vl_baixa_percent_w - vl_trib_controle_w;
                vl_baixa_w          := vl_baixa_w +  vl_ajuste_trib_w;

            end if;

        end if;*/
        else
            /* se for um estorno */

            if (nr_seq_liq_origem_p IS NOT NULL AND nr_seq_liq_origem_p::text <> '') then
                vl_baixa_w  := coalesce(vl_tributo_w,0) * -1;
            else
                vl_baixa_w  := vl_tributo_w;
            end if;
        end if;

        /*OS 1332643 - Se for estorno, verificar se existe baixa para o tributo refenrente a baixa do titulo que esta sendo estornada. Nos casos onde a baixa do imposto nao eh parcial, gera a baixa total no tributo mesmo com baixa parcial no titulo
        Se tiver outra baixa titulo, ela n vai gerar baixa no imposto, pois ja baixou total anteriormente. Mas caso essa segunda baixa parcial no titulo for estornada, gerava estorno no tributo.*/
        ie_gerar_w := 'S'; --A cada item do cursor, forcar S para gerar. Abaixo verifica se  nao deve gerar.
        if (nr_seq_liq_origem_p IS NOT NULL AND nr_seq_liq_origem_p::text <> '') then

            /*Verificar se existe baixa do tributo para o titulo, trbuto em questao, e para o liq origem da baixa. Se nao tiver (count 0), nao gera insert */

            begin
            select  1
            into STRICT    qt_reg_w

            where exists (
                SELECT  t.nr_sequencia
                from    titulo_receber_trib_baixa t
                where   t.nr_titulo           = nr_titulo_p
                and     t.nr_seq_tit_trib     = nr_sequencia_w
                and     t.nr_seq_tit_liq      = nr_seq_liq_origem_p
                );
            exception
                when no_data_found then
                    qt_reg_w    := 0;
            end;

            if (qt_reg_w = 0) then
                ie_gerar_w := 'N';
            end if;

        end if;

        if (coalesce(ie_gerar_w,'S') = 'S') then

            select  nextval('titulo_receber_trib_baixa_seq')
            into STRICT    nr_seq_trib_baixa_w
;

            insert into titulo_receber_trib_baixa(nr_sequencia,
                vl_baixa,
                dt_atualizacao,
                nm_usuario,
                nr_seq_tit_trib,
                nr_titulo,
                nr_seq_tit_liq,
                nr_seq_trans_financ)
            values (nr_seq_trib_baixa_w,
                vl_baixa_w,
                clock_timestamp(),
                nm_usuario_p,
                nr_sequencia_w,
                nr_titulo_p,
                nr_seq_tit_liq_p,
                coalesce(nr_seq_trans_tit_rec_w,nr_seq_trans_financ_w));

            select  sum(vl_baixa)
            into STRICT    vl_tit_baixa_w
            from    titulo_receber_trib_baixa t
            where   t.nr_seq_tit_trib = nr_sequencia_w;

            update  titulo_receber_trib
            set     vl_saldo        = vl_tributo_w - vl_tit_baixa_w
            where   nr_sequencia    = nr_sequencia_w;

            /* Verifica o saldo para atualizar a data contabil do tributo */

            select  max(a.vl_saldo)
            into STRICT    vl_saldo_tributo_w
            from    titulo_receber_trib a
            where   a.nr_sequencia  = nr_sequencia_w
            and     a.nr_titulo     = nr_titulo_p;

            if (coalesce(vl_saldo_tributo_w,0) <= 0) then
                update  titulo_receber_trib
                set     dt_contabil     = clock_timestamp()
                where   nr_sequencia    = nr_sequencia_w;
            else
                update  titulo_receber_trib
                set     dt_contabil      = NULL
                where   nr_sequencia    = nr_sequencia_w;
            end if;

            if (ie_concil_contab_w = 'S') then
                begin
                CALL atualiza_tit_receb_trib_baixa(
                            coalesce(dt_receb_baixa_p,clock_timestamp()),
                            cd_estab_baixa_p,
                            nr_seq_trib_baixa_w,
                            vl_baixa_w,
                            nr_titulo_p,
                            coalesce(nr_seq_trans_tit_rec_w,nr_seq_trans_financ_w),
                            null,
                            nm_usuario_p);
                end;
            end if;

        end if;

    end loop;
    close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_imposto_tit_rec ( nr_titulo_p titulo_receber_trib.nr_titulo%type, nr_seq_tit_liq_p titulo_receber_liq.nr_sequencia%type, vl_baixa_p titulo_receber_trib_baixa.vl_baixa%type, nm_usuario_p titulo_receber_trib_baixa.nm_usuario%type, nr_seq_liq_origem_p titulo_receber_trib.nr_sequencia%type, ie_gerar_baixa_trib_p titulo_receber_liq.ie_acao%type default 'S', dt_receb_baixa_p titulo_receber_liq.dt_recebimento%type default null, cd_estab_baixa_p titulo_receber.cd_estabelecimento%type default null) FROM PUBLIC;
