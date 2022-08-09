-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE contabiliza_perda_pre_fatur ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) AS $body$
DECLARE



cd_centro_custo_debito_w        bigint;
cd_centro_custo_w               bigint;
cd_conta_credito_w              varchar(20);
cd_conta_debito_w               varchar(20);
cd_convenio_w                   bigint;
cd_estabelecimento_w            bigint;
cd_historico_w                  bigint;
cd_tipo_lote_contabil_w         bigint;
ds_compl_historico_w            varchar(255);
ds_conteudo_w                   varchar(4000);
ds_convenio_w                   varchar(255);
ds_titulo_w                     varchar(120);
dt_inicial_w                    timestamp;
dt_final_w                      timestamp;
dt_referencia_w                 timestamp;
ie_centro_custo_w               varchar(1);
ie_debito_credito_w             varchar(1);
nr_interno_conta_w              bigint;
nm_paciente_w                   varchar(60);
nr_sequencia_w                  bigint      := 0;
nr_seq_perda_w                  bigint;
qt_dias_conta_w                 bigint;
vl_movimento_w                  double precision;
nm_agrupador_w                  varchar(255);
nr_seq_agrupamento_w            w_movimento_contabil.nr_seq_agrupamento%type;
ds_mesano_w                     varchar(10);
nr_seq_info_ctb_w               informacao_contabil.nr_sequencia%type   := 77;
cd_procedimento_w               conta_paciente_resumo.cd_procedimento%type;
ie_origem_proced_w              conta_paciente_resumo.ie_origem_proced%type;
cd_material_w                   conta_paciente_resumo.cd_material%type;
cd_setor_atendimento_w          setor_atendimento.cd_setor_atendimento%type;
nr_seq_proc_interno_w           procedimento_paciente.nr_seq_proc_interno%type;

c01 CURSOR FOR
SELECT  a.nr_sequencia,
        a.ds_titulo,
        a.cd_convenio,
        b.nr_interno_conta,
        b.qt_dias_conta,
        c.cd_conta_contabil,
        c.cd_procedimento,
        c.ie_origem_proced,
        c.cd_material,
        d.cd_centro_custo,
        d.cd_centro_custo_receita,
        d.cd_setor_atendimento,
        coalesce(sum(c.vl_procedimento) + sum(c.vl_material),0) vl_movimento,
        c.nr_seq_proc_interno
from    setor_atendimento d,
        conta_paciente_resumo c,
        pre_fatur_perda_conta b,
        pre_fatur_perda a
where   a.nr_sequencia          = b.nr_seq_perda
and     b.nr_interno_conta      = c.nr_interno_conta
and     c.cd_setor_atendimento  = d.cd_setor_atendimento
and     b.nr_lote_contabil      = nr_lote_contabil_p
group by a.nr_sequencia,
        a.ds_titulo,
        a.cd_convenio,
        b.nr_interno_conta,
        b.qt_dias_conta,
        c.cd_conta_contabil,
        c.cd_procedimento,
        c.ie_origem_proced,
        c.cd_material,
        d.cd_centro_custo,
        d.cd_centro_custo_receita,
        d.cd_setor_atendimento,
        c.nr_seq_proc_interno;


BEGIN
/*Validacao para impedir a geracao em lotes incorretos */

if (ie_exclusao_p <> 'S') then
        select b.cd_tipo_lote_contabil
        into STRICT cd_tipo_lote_contabil_w
        from lote_contabil b
        where b.nr_lote_contabil = nr_lote_contabil_p;
        if (cd_tipo_lote_contabil_w <> 31) then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(261346);
        end if;
end if;
select  dt_referencia,
        cd_estabelecimento,
        cd_tipo_lote_contabil
into STRICT    dt_referencia_w,
        cd_estabelecimento_w,
        cd_tipo_lote_contabil_w
from    lote_contabil
where   nr_lote_contabil        = nr_lote_contabil_p;

dt_inicial_w    := trunc(dt_referencia_w, 'mm');
dt_final_w      := fim_mes(dt_inicial_w);

delete  FROM w_movimento_contabil
where   nr_lote_contabil        = nr_lote_contabil_p;

if (ie_exclusao_p = 'S') then

        delete  FROM movimento_contabil
        where   nr_lote_contabil        = nr_lote_contabil_p;

        update  pre_fatur_perda_conta
        set     nr_lote_contabil         = NULL
        where   nr_lote_contabil        = nr_lote_contabil_p;

        update  lote_contabil
        set     vl_debito               = 0,
                vl_credito              = 0
        where   nr_lote_contabil        = nr_lote_contabil_p;
else
        update  pre_fatur_perda_conta a
        set     nr_lote_contabil        = nr_lote_contabil_p
        where   coalesce(a.nr_lote_contabil::text, '') = ''
        and     exists (        SELECT  1
                                from    pre_fatur_perda b
                                where   b.dt_referencia         between dt_inicial_w and dt_final_w
                                and     b.nr_sequencia          = a.nr_seq_perda
                                and     b.cd_estabelecimento    = cd_estabelecimento_w
                                and     (b.dt_baixa IS NOT NULL AND b.dt_baixa::text <> ''));
end if;

nm_agrupador_w  := coalesce(trim(both obter_agrupador_contabil(cd_tipo_lote_contabil_w)),'DS_MES_ANO');
ds_mesano_w             :=      to_char(dt_referencia_w,'mmyyyy');
open c01;
loop
fetch c01 into
        nr_seq_perda_w,
        ds_titulo_w,
        cd_convenio_w,
        nr_interno_conta_w,
        qt_dias_conta_w,
        cd_conta_credito_w,
        cd_procedimento_w,
        ie_origem_proced_w,
        cd_material_w,
        cd_centro_custo_debito_w,
        cd_centro_custo_w,
        cd_setor_atendimento_w,
        vl_movimento_w,
        nr_seq_proc_interno_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

        if (nm_agrupador_w = 'NR_INTERNO_CONTA')then
                   nr_seq_agrupamento_w :=      nr_interno_conta_w;
        elsif (nm_agrupador_w = 'DS_MES_ANO')then
                   nr_seq_agrupamento_w :=      somente_numero(ds_mesano_w);
        end if;

        if (coalesce(nr_seq_agrupamento_w,0) = 0)then
                nr_seq_agrupamento_w    :=      ds_mesano_w;
        end if;

        ie_debito_credito_w     := 'D';
        cd_conta_debito_w       := obter_conta_contabil_idade(dt_referencia_w, qt_dias_conta_w);
        cd_historico_w          := obter_hist_idade_conpaci(dt_referencia_w, qt_dias_conta_w);
        nr_sequencia_w          := nr_sequencia_w + 1;
        ds_compl_historico_w    := '';

        ds_convenio_w           := substr(obter_nome_convenio(cd_convenio_w),1,255);
        nm_paciente_w           := substr(obter_paciente_conta(nr_interno_conta_w, 'D'),1,60);

        ds_conteudo_w           := substr(      nr_interno_conta_w      || '#@' ||
                                                nr_seq_perda_w          || '#@' ||
                                                nm_paciente_w           || '#@' ||
                                                ds_convenio_w, 1, 4000);

        select  obter_compl_historico(cd_tipo_lote_contabil_w, cd_historico_w, ds_conteudo_w)
        into STRICT    ds_compl_historico_w
;

        select  coalesce(max(ie_centro_custo),'N')
        into STRICT    ie_centro_custo_w
        from    conta_contabil
        where   cd_conta_contabil = cd_conta_debito_w;

        if (ie_centro_custo_w = 'N') then
                cd_centro_custo_debito_w        := null;
        end if;

        insert into w_movimento_contabil(
                nr_lote_contabil,
                nr_sequencia,
                dt_movimento,
                cd_conta_contabil,
                ie_debito_credito,
                vl_movimento,
                cd_historico,
                cd_centro_custo,
                ds_compl_historico,
                nr_documento,
                nr_seq_agrupamento,
                ie_transitorio,
                nm_tabela,
                nm_atributo,
                nr_seq_tab_orig,
                nr_seq_tab_compl,
                nr_seq_info)
        values ( nr_lote_contabil_p,
                nr_sequencia_w,
                dt_referencia_w,
                cd_conta_debito_w,
                ie_debito_credito_w,
                vl_movimento_w,
                cd_historico_w,
                cd_centro_custo_debito_w,
                ds_compl_historico_w,
                null,
                nr_seq_agrupamento_w,
                'N',
                'CONTA_PACIENTE_RESUMO',
                'VL_PROCEDIMENTO+VL_MATERIAL',
                nr_seq_perda_w,
                nr_interno_conta_w,
                nr_seq_info_ctb_w);

        ie_debito_credito_w     := 'C';
        nr_sequencia_w          := nr_sequencia_w + 1;

        select  coalesce(max(ie_centro_custo),'N')
        into STRICT    ie_centro_custo_w
        from    conta_contabil
        where   cd_conta_contabil = cd_conta_credito_w;

        if (ie_centro_custo_w = 'N') then
                cd_centro_custo_w       := null;
        end if;

        if (coalesce(cd_conta_credito_w, '0') = '0') then

                if (coalesce(cd_procedimento_w,0) != 0) then
                        SELECT * FROM define_conta_procedimento(      cd_estabelecimento_w, cd_procedimento_w, ie_origem_proced_w, 8, null, cd_setor_atendimento_w, null, null, null, cd_convenio_w, null, dt_referencia_w, cd_conta_credito_w, cd_centro_custo_w, null, null, null, null, null, null, null, null, null, nr_seq_proc_interno_w) INTO STRICT cd_conta_credito_w, cd_centro_custo_w;
                elsif (coalesce(cd_material_w,0) != 0) then
                        SELECT * FROM define_conta_material(  cd_estabelecimento_w, cd_material_w, 8, null, cd_setor_atendimento_w, '0', 0, null, cd_convenio_w, null, 0, null, dt_referencia_w, cd_conta_credito_w, cd_centro_custo_w, null, null, null, null, null, null) INTO STRICT cd_conta_credito_w, cd_centro_custo_w;
                end if;
        end if;

        insert into w_movimento_contabil(
                nr_lote_contabil,
                nr_sequencia,
                dt_movimento,
                cd_conta_contabil,
                ie_debito_credito,
                vl_movimento,
                cd_historico,
                cd_centro_custo,
                ds_compl_historico,
                nr_documento,
                nr_seq_agrupamento,
                ie_transitorio,
                nm_tabela,
                nm_atributo,
                nr_seq_tab_orig,
                nr_seq_tab_compl,
                nr_seq_info)
        values ( nr_lote_contabil_p,
                nr_sequencia_w,
                dt_referencia_w,
                cd_conta_credito_w,
                ie_debito_credito_w,
                vl_movimento_w,
                cd_historico_w,
                cd_centro_custo_w,
                ds_compl_historico_w,
                null,
                nr_seq_agrupamento_w,
                'N',
                'CONTA_PACIENTE_RESUMO',
                'VL_PROCEDIMENTO+VL_MATERIAL',
                nr_seq_perda_w,
                nr_interno_conta_w,
                nr_seq_info_ctb_w);
end loop;
close c01;

if (nr_sequencia_w > 0) then
        CALL agrupa_movimento_contabil(nr_lote_contabil_p, nm_usuario_p);
end if;

if (coalesce(ds_retorno_p::text, '') = '') then

        update  lote_contabil
        set     ie_situacao     = 'A',
                dt_geracao_lote = clock_timestamp()
        where   nr_lote_contabil        = nr_lote_contabil_p;

        if (ie_exclusao_p = 'S') then
                ds_retorno_p            := wheb_mensagem_pck.get_texto(298780); -- Exclusao do Lote Ok
                CALL ctb_gravar_log_lote( nr_lote_contabil_p, 2, '', nm_usuario_p);
        else
                ds_retorno_p            := wheb_mensagem_pck.get_texto(298781); -- Geracao do Lote Ok
                CALL ctb_gravar_log_lote( nr_lote_contabil_p, 1, '', nm_usuario_p);
        end if;
        commit;
else
        rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE contabiliza_perda_pre_fatur ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) FROM PUBLIC;
