-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_virada_saldo_projeto ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_proj_rec_p bigint) AS $body$
DECLARE


cd_conta_contabil_w	    ctb_saldo_projeto.cd_conta_contabil%type;
cd_estabelecimento_w	ctb_saldo_projeto.cd_estabelecimento%type;
cd_centro_custo_w	    ctb_saldo_projeto.cd_centro_custo%type;
vl_movimento_w          ctb_saldo_projeto.vl_movimento%type;
vl_saldo_w              ctb_saldo_projeto.vl_saldo%type;
nr_sequencia_w          ctb_saldo_projeto.nr_sequencia%type;
nr_seq_mes_dest_w       ctb_mes_ref.nr_sequencia%type;
cd_empresa_w            empresa.cd_empresa%type;
dt_referencia_w         ctb_mes_ref.dt_referencia%type;
qt_mes_fim_exerc_w      empresa.qt_mes_fim_exercicio%type;
ie_tipo_w               ctb_grupo_conta.ie_tipo%type;
dt_referencia_dest_w    ctb_mes_ref.dt_referencia%type;
cd_classificacao_w      ctb_saldo_projeto.cd_classificacao%type;
cd_classif_sup_w        ctb_saldo_projeto.cd_classificacao%type;
nr_nivel_conta_w        ctb_saldo_projeto.nr_nivel_conta%type;
cd_conta_troca_w        ctb_troca_plano_conta.cd_conta_destino%type;
ie_zerar_saldos_w       varchar(1);
ds_erro_w   		    varchar(2000);
ie_conta_vigente_w      varchar(1);

C01 CURSOR FOR
SELECT  a.cd_estabelecimento,
        a.cd_conta_contabil,
        a.cd_centro_custo,
        a.vl_saldo,
        c.ie_tipo
from ctb_grupo_conta c,
     conta_contabil b,
     ctb_saldo_projeto a
where a.nr_seq_mes_ref = nr_seq_mes_ref_p
and	a.cd_conta_contabil = b.cd_conta_contabil
and	b.cd_grupo = c.cd_grupo
and	((b.ie_situacao = 'A') or (a.vl_saldo <> 0))
and	((a.cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento_p,0) = 0))
and a.nr_seq_proj_rec = nr_seq_proj_rec_p;


BEGIN
    begin
        select	cd_empresa, dt_referencia
        into STRICT	cd_empresa_w, dt_referencia_w
        from	ctb_mes_ref
        where	nr_sequencia= nr_seq_mes_ref_p;
            exception
                when no_data_found then
                    cd_empresa_w    := null;
                    dt_referencia_w := null;
                when too_many_rows then
                    cd_empresa_w    := null;
                    dt_referencia_w := null;
    end;

    begin
        select	qt_mes_fim_exercicio
        into STRICT	qt_mes_fim_exerc_w
        from	empresa
        where	cd_empresa = cd_empresa_w;
        exception
            when no_data_found then
                qt_mes_fim_exerc_w := null;
            when too_many_rows then
                qt_mes_fim_exerc_w := null;
    end;

    begin
        select	coalesce(max(nr_sequencia),0)
        into STRICT	nr_seq_mes_dest_w
        from	ctb_mes_ref
        where	cd_empresa	= cd_empresa_w
        and	pkg_date_utils.start_of(dt_referencia,'MONTH',0) = pkg_date_utils.start_of(pkg_date_utils.add_month(dt_referencia_w, 1,0), 'MONTH',0)
        and	(dt_abertura IS NOT NULL AND dt_abertura::text <> '')
        and	coalesce(dt_fechamento::text, '') = '';
            exception
                when no_data_found then
                    nr_seq_mes_dest_w := null;
                when too_many_rows then
                    nr_seq_mes_dest_w := null;
    end;

    if (nr_seq_mes_dest_w = 0) then
        CALL Wheb_mensagem_pck.exibir_mensagem_abort(203781);
    end if;

    begin
        select	dt_referencia
        into STRICT	dt_referencia_dest_w
        from	ctb_mes_ref
        where	nr_sequencia = nr_seq_mes_dest_w;
            exception
                when no_data_found then
                    dt_referencia_dest_w := null;
                when too_many_rows then
                    dt_referencia_dest_w := null;
    end;

    open C01;
    loop
        fetch C01 into
            cd_estabelecimento_w,
            cd_conta_contabil_w,
            cd_centro_custo_w,
            vl_saldo_w,
            ie_tipo_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
            /*Inicializar variavel da conta de troca */

            /*Inicializar variavel de contagem quantas contas origem diferente mesmo destino */

            ie_zerar_saldos_w := coalesce(obter_valor_param_usuario(923, 124, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'S');
            if (ie_zerar_saldos_w = 'S') then
                begin
                    if (qt_mes_fim_exerc_w > 0) then
                        if (campo_numerico(pkg_date_utils.extract_field('MONTH',dt_referencia_w)) = qt_mes_fim_exerc_w) and (ie_tipo_w in ('R','D','C')) then
                            vl_saldo_w := 0;
                        end if;
                    elsif (mod((to_char(dt_referencia_w, 'mm'))::numeric ,abs(qt_mes_fim_exerc_w)) = 0) and (ie_tipo_w in ('R','D','C')) then
                        vl_saldo_w := 0;
                    end if;
                end;
            end if;

        begin
            select substr(obter_se_conta_vigente(cd_conta_contabil_w, dt_referencia_dest_w),1,1)
            into STRICT ie_conta_vigente_w
;
                exception
                    when no_data_found then
                        ie_conta_vigente_w := null;
                    when too_many_rows then
                        ie_conta_vigente_w := null;
        end;

        if (ie_conta_vigente_w = 'N') then
            begin
                select	coalesce(max(a.cd_conta_destino), 'X')
                into STRICT	cd_conta_troca_w
                from	ctb_troca_plano b,
                    ctb_troca_plano_conta a
                where	a.cd_conta_origem = cd_conta_contabil_w
                and	a.nr_seq_troca = b.nr_sequencia
                and	pkg_date_utils.start_of(b.dt_troca_prevista, 'MONTH',0) = pkg_date_utils.start_of(dt_referencia_dest_w, 'MONTH',0);
                    exception
                        when no_data_found then
                            cd_conta_troca_w := null;
                        when too_many_rows then
                            cd_conta_troca_w := null;
            end;
            if (cd_conta_troca_w <> 'X') then
                begin
                /*Verifica Quantas contas origem tem o mesmo destino que CD_CONTA_TROCA*/

                /* SE maior do que 1 obter a soma do SALDO */

                    select sum(c.vl_saldo)
                    into STRICT vl_saldo_w
                    from ctb_saldo_projeto c,
                        ctb_troca_plano b,
                        ctb_troca_plano_conta a
                    where	a.cd_conta_origem 	= c.cd_conta_contabil
                    and	c.nr_seq_mes_ref	= nr_seq_mes_ref_p
                    and	a.cd_conta_destino	= cd_conta_troca_w
                    and	a.nr_seq_troca 		= b.nr_sequencia
                    and	pkg_date_utils.start_of(b.dt_troca_prevista, 'MONTH',0) = pkg_date_utils.start_of(dt_referencia_dest_w, 'MONTH',0)
                    and c.nr_seq_proj_rec = nr_seq_proj_rec_p;
                        exception
                            when no_data_found then
                                vl_saldo_w := null;
                            when too_many_rows then
                                vl_saldo_w := null;
                end;
                cd_conta_contabil_w	:= cd_conta_troca_w;
            end if;
        end if;

        cd_classificacao_w	:= substr(ctb_obter_classif_conta(cd_conta_contabil_w, null, dt_referencia_dest_w),1,40);
        cd_classif_sup_w	:= substr(ctb_obter_classif_conta_sup(cd_classificacao_w, dt_referencia_dest_w, cd_empresa_w),1,40);
        nr_nivel_conta_w	:= ctb_obter_nivel_classif_conta(cd_classificacao_w);
        begin
            select coalesce(max(vl_movimento),0), coalesce(max(nr_sequencia),0)
            into STRICT vl_movimento_w, nr_sequencia_w
            from ctb_saldo_projeto
            where nr_seq_mes_ref = nr_seq_mes_dest_w
            and	cd_estabelecimento = cd_estabelecimento_w
            and	cd_conta_contabil = cd_conta_contabil_w
            and	coalesce(cd_centro_custo,0) = coalesce(cd_centro_custo_w,0)
            and nr_seq_proj_rec = nr_seq_proj_rec_p;
                exception
                    when no_data_found then
                        vl_movimento_w := null;
                        nr_sequencia_w := null;
                    when too_many_rows then
                        vl_movimento_w := null;
                        nr_sequencia_w := null;
        end;
        if (nr_sequencia_w > 0) then
            update	ctb_saldo_projeto
            set	vl_saldo = vl_saldo_w + vl_movimento_w
            where nr_sequencia = nr_sequencia_w;
        else
            begin
                select nextval('ctb_saldo_projeto_seq')
                into STRICT nr_sequencia_w
;
                    exception
                        when no_data_found then
                            nr_sequencia_w := null;
                        when too_many_rows then
                            nr_sequencia_w := null;
            end;

            begin
                insert into ctb_saldo_projeto(
                    nr_sequencia,
                    nr_seq_mes_ref,
                    dt_atualizacao,
                    nm_usuario,
                    cd_estabelecimento,
                    cd_conta_contabil,
                    vl_debito,
                    vl_credito,
                    vl_saldo,
                    vl_movimento,
                    cd_centro_custo,
                    vl_encerramento,
                    vl_enc_debito,
                    vl_enc_credito,
                    cd_classificacao,
                    cd_classif_sup,
                    nr_nivel_conta,
                    nr_seq_proj_rec)
                values ( nr_sequencia_w,
                    nr_seq_mes_dest_w,
                    clock_timestamp(),
                    nm_usuario_p,
                    cd_estabelecimento_w,
                    cd_conta_contabil_w,
                    0,
                    0,
                    vl_saldo_w,
                    0,
                    cd_centro_custo_w,
                    0,
                    0,
                    0,
                    cd_classificacao_w,
                    cd_classif_sup_w,
                    nr_nivel_conta_w,
                    nr_seq_proj_rec_p);
                exception
                    when others then
                        insert into ctb_log(cd_log,ds_log,nm_usuario,dt_atualizacao)
                        values (301,cd_conta_contabil_w,nm_usuario_p,clock_timestamp());
            end;
        end if;
	end;
end loop;
close C01;
commit;

ds_erro_w := CTB_Acumular_Saldo_projeto(nr_seq_mes_dest_w, cd_estabelecimento_p, nm_usuario_p, ds_erro_w, nr_seq_proj_rec_p);

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_virada_saldo_projeto ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_proj_rec_p bigint) FROM PUBLIC;
