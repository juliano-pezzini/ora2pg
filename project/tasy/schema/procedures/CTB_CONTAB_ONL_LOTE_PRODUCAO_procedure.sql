-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_contab_onl_lote_producao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
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
cd_empresa_w                    empresa.cd_empresa%type;
cd_estabelecimento_w            estabelecimento.cd_estabelecimento%type := cd_estabelecimento_p;
nr_lote_contabil_w              lote_contabil.nr_lote_contabil%type;
nm_agrupador_w                  agrupador_contabil.nm_atributo%type;
nr_seq_agrupamento_w            ctb_movimento.nr_seq_agrupamento%type;
ctb_param_lote_producao_w       ctb_param_lote_producao%rowtype;
cd_tipo_lote_contabil_w         lote_contabil.cd_tipo_lote_contabil%type := 25;
ds_material_w                   material.ds_material%type;
dt_mesano_fm_w                  timestamp;
dt_mesano_referencia_w          timestamp;
ie_data_contab_lote_prod_w      parametro_estoque.ie_data_contab_lote_prod%type;
nm_atributo_w                   w_movimento_contabil.nm_atributo%type;
nm_tabela_w                     w_movimento_contabil.nm_tabela%type;
ds_compl_historico_w            varchar(255);
ds_conteudo_w                   varchar(4000);
qt_conv_estoque_consumo_w       double precision;
cd_oper_baixa_producao_w        bigint;
cd_conta_debito_w               varchar(20);
cd_centro_custo_w               integer;
dt_atualizacao_saldo_w          timestamp;
ds_erro_w                       varchar(255) := null;
qt_registro_w                   bigint;
sequencia_w                     dbms_sql.number_table;
ctb_movimento_doc_w             ctb_online_pck.ctb_movimento_doc;
cd_conta_contabil               conta_contabil.cd_conta_contabil%type;
nr_documento_ww                 movimento_contabil.nr_documento%type;
ie_centro_custo_w               conta_contabil.ie_centro_custo%type;
cd_conta_credito_w              varchar(20);
cd_conta_oper_baixa_prod_w      varchar(20);
ie_origem_documento_w           movimento_contabil.ie_origem_documento%type;
ie_debito_credito_w             varchar(1);
cd_historico_w                  bigint;
nr_documento_w                  movimento_contabil.nr_documento%type;
cd_sequencia_parametro_es_w     bigint;
cd_sequencia_parametro_pd_w     bigint;
cd_operacao_w                   bigint;

c_lote_producao CURSOR FOR
    SELECT  a.nr_lote_producao,
            a.dt_confirmacao,
            obter_custo_medio_material(a.cd_estabelecimento, trunc(a.dt_mesano_referencia, 'mm'), b.cd_material_estoque) vl_movimento,
            a.qt_real,
            a.cd_local_estoque,
            a.cd_material
    from    material        b,
            lote_producao   a
    where   a.cd_material           = b.cd_material
    and     ctb_param_lote_producao_w.ie_valor_lote_prod    = 'CM'
    and     a.nr_lote_contabil      = nr_lote_contabil_w

union all

    SELECT  a.nr_lote_producao,
            a.dt_confirmacao,
            a.vl_custo_material vl_movimento,
            a.qt_real,
            a.cd_local_estoque,
            a.cd_material
    from    material        b,
            lote_producao   a
    where   a.cd_material           = b.cd_material
    and     ctb_param_lote_producao_w.ie_valor_lote_prod    = 'VC'
    and     a.nr_lote_contabil      = nr_lote_contabil_w
    
union all

    select  b.nr_lote_producao,
            b.dt_confirmacao,
            a.vl_estoque vl_movimento,
            b.qt_real,
            b.cd_local_estoque,
            b.cd_material
    from    movto_estoque_prod_v    a,
            lote_producao           b
    where   b.nr_lote_producao      = a.nr_documento
    and     ctb_param_lote_producao_w.ie_valor_lote_prod    = 'MV'
    and     b.nr_lote_contabil      = nr_lote_contabil_w;

lote_producao_w c_lote_producao%rowtype;

procedure get_sequence is
  vet RECORD;

BEGIN
ctb_movimento_doc_w.nr_sequencia        := null;
if (sequencia_w.count > 0) then
        ctb_movimento_doc_w.nr_sequencia        := sequencia_w(sequencia_w.count);
        sequencia_w.delete(sequencia_w.count);
end if;
exception when others then
        ctb_movimento_doc_w.nr_sequencia        := null;
end;

begin

cd_empresa_w    := obter_empresa_estab(cd_estabelecimento_w);

select  a.*
into STRICT    ctb_param_lote_producao_w
from    ctb_param_lote_producao a
where   a.cd_empresa    = cd_empresa_w
and     coalesce(a.cd_estab_exclusivo, cd_estabelecimento_w) = cd_estabelecimento_w;

ctb_param_lote_producao_w.ie_valor_lote_prod            := coalesce(ctb_param_lote_producao_w.ie_valor_lote_prod, 'CM');

nr_lote_contabil_w := CTB_ONLINE_PCK.get_lote_contabil(cd_tipo_lote_contabil_w, cd_estabelecimento_w, dt_referencia_p, nm_usuario_p);

select  count(nr_sequencia)
into STRICT    qt_registro_w
from    ctb_movimento
where   nr_lote_contabil        = nr_lote_contabil_w;

select  dt_atualizacao_saldo
into STRICT    dt_atualizacao_saldo_w
from    lote_contabil
where   nr_lote_contabil        = nr_lote_contabil_w;

if (dt_atualizacao_saldo_w IS NOT NULL AND dt_atualizacao_saldo_w::text <> '') then
        ds_erro_w := ctb_desatualizar_lote(nr_lote_contabil_w, nm_usuario_p, ds_erro_w);
end if;

if (qt_registro_w > 0) then
    begin
    qt_registro_w   := sequencia_w.count;

    for vet in (SELECT a.nr_sequencia
                from    ctb_movimento a
                where   a.nr_lote_contabil      = nr_lote_contabil_w
                order by 1 desc) loop
            begin
            qt_registro_w   := qt_registro_w + 1;
            sequencia_w(qt_registro_w)      := vet.nr_sequencia;
            end;
    end loop;

    delete  FROM ctb_movimento
    where   nr_lote_contabil        = nr_lote_contabil_w;
    commit;
    end;
end if;

dt_mesano_referencia_w  := Trunc(dt_referencia_p,'mm');
dt_mesano_fm_w  := fim_dia(fim_mes(dt_mesano_referencia_w));

update  lote_producao
set     nr_lote_contabil                = nr_lote_contabil_w
where   cd_estabelecimento              = cd_estabelecimento_w
and     coalesce(nr_lote_contabil, 0)        = 0
and     CASE WHEN ctb_param_lote_producao_w.ie_data_contab_lote_prod='R' THEN dt_mesano_referencia WHEN ctb_param_lote_producao_w.ie_data_contab_lote_prod='C' THEN dt_confirmacao END  between dt_mesano_referencia_w and dt_mesano_fm_w
and     (dt_confirmacao IS NOT NULL AND dt_confirmacao::text <> '');
commit;

if (ctb_param_lote_producao_w.ie_valor_lote_prod = 'CM') then
        nm_tabela_w     := 'LOTE_PRODUCAO';
        nm_atributo_w   := 'VL_CUSTO_MEDIO';
elsif (ctb_param_lote_producao_w.ie_valor_lote_prod = 'VC') then
        nm_tabela_w     := 'LOTE_PRODUCAO';
        nm_atributo_w   := 'VL_CUSTO_MATERIAL';
elsif (ctb_param_lote_producao_w.ie_valor_lote_prod = 'MV') then
        nm_tabela_w     := 'MOVTO_ESTOQUE_PROD_V';
        nm_atributo_w   := 'VL_ESTOQUE';
end if;

nm_agrupador_w  := coalesce(trim(both obter_agrupador_contabil(cd_tipo_lote_contabil_w)),'NR_LOTE_PRODUCAO');

open c_lote_producao;
loop
fetch c_lote_producao into
        lote_producao_w;
EXIT WHEN NOT FOUND; /* apply on c_lote_producao */
    begin
    if (lote_producao_w.vl_movimento <> 0) then
        begin
        ds_compl_historico_w    := '';
        ds_conteudo_w           := '';
        lote_producao_w.dt_confirmacao          := trunc(lote_producao_w.dt_confirmacao,'dd');
        ds_material_w           := substr(obter_desc_material(lote_producao_w.cd_material),1,255);
        cd_conta_debito_w       := '';
        cd_conta_credito_w      := '';
        cd_sequencia_parametro_es_w     := null;
        cd_sequencia_parametro_pd_w     := null;

        select  qt_conv_estoque_consumo
        into STRICT    qt_conv_estoque_consumo_w
        from    material
        where   cd_material     = lote_producao_w.cd_material;

        if (ctb_param_lote_producao_w.ie_valor_lote_prod = 'CM')    then
                lote_producao_w.qt_real := lote_producao_w.qt_real * qt_conv_estoque_consumo_w;
                lote_producao_w.vl_movimento    := lote_producao_w.vl_movimento * lote_producao_w.qt_real;
        end if;

        if (coalesce(cd_oper_baixa_producao_w,0) <> 0) then
                cd_operacao_w := cd_oper_baixa_producao_w;
                begin
                cd_conta_oper_baixa_prod_w      := substr(obter_conta_hist_oper_estoque(cd_empresa_w,cd_oper_baixa_producao_w,'C'),1,20);
                exception when others then
                        cd_conta_oper_baixa_prod_w      := '';
                end;
        else
                cd_operacao_w := null;
        end if;

        if (nm_agrupador_w = 'NR_LOTE_PRODUCAO')then
                nr_seq_agrupamento_w := lote_producao_w.nr_lote_producao;
        end if;

        if (coalesce(nr_seq_agrupamento_w,0) = 0)then
                nr_seq_agrupamento_w := lote_producao_w.nr_lote_producao;
        end if;

        SELECT * FROM define_conta_material(  cd_estabelecimento_w, lote_producao_w.cd_material, 2, null, 0, '0', 0, null, null, null, lote_producao_w.cd_local_estoque, cd_operacao_w, lote_producao_w.dt_confirmacao, cd_conta_debito_w, cd_centro_custo_w, null) INTO STRICT cd_conta_debito_w, cd_centro_custo_w;
        cd_sequencia_parametro_es_w := philips_contabil_pck.get_parametro_conta_contabil();

        SELECT * FROM define_conta_material(  cd_estabelecimento_w, lote_producao_w.cd_material, 3, null, 0, '0', 0, null, null, null, lote_producao_w.cd_local_estoque, cd_operacao_w, lote_producao_w.dt_confirmacao, cd_conta_credito_w, cd_centro_custo_w, null) INTO STRICT cd_conta_credito_w, cd_centro_custo_w;

        cd_sequencia_parametro_pd_w := philips_contabil_pck.get_parametro_conta_contabil();
        cd_conta_credito_w      := coalesce(cd_conta_oper_baixa_prod_w, cd_conta_credito_w);

        select  coalesce(max(cd_centro_custo), 0)
        into STRICT    cd_centro_custo_w
        from    local_estoque
        where   cd_local_estoque        = lote_producao_w.cd_local_estoque;

        CALL ctb_online_pck.definir_atrib_compl(cd_tipo_lote_contabil_w);
        CALL ctb_online_pck.set_value_compl_hist('NR_LOTE_PRODUCAO', lote_producao_w.nr_lote_producao);
        CALL ctb_online_pck.set_value_compl_hist('DS_MATERIAL', ds_material_w);
        CALL ctb_online_pck.set_value_compl_hist('CD_MATERIAL', lote_producao_w.cd_material);
        ds_compl_historico_w := ctb_online_pck.ctb_obter_compl_historico(cd_tipo_lote_contabil_w, ctb_param_lote_producao_w.cd_historico);

        nr_documento_ww         := lote_producao_w.nr_lote_producao;
        ie_origem_documento_w   := 9;

        if (coalesce(cd_conta_debito_w,'0') != '0') then
            begin
            ctb_movimento_doc_w.nr_sequencia        := null;
            get_sequence;
            ctb_movimento_doc_w.nr_lote_contabil    := nr_lote_contabil_w;
            ctb_movimento_doc_w.cd_conta_debito     := cd_conta_debito_w;
            ctb_movimento_doc_w.cd_conta_credito    := null;
            ctb_movimento_doc_w.cd_historico        := ctb_param_lote_producao_w.cd_historico;
            ctb_movimento_doc_w.dt_movimento        := lote_producao_w.dt_confirmacao;
            ctb_movimento_doc_w.vl_movimento        := lote_producao_w.vl_movimento;
            ctb_movimento_doc_w.ds_compl_historico  := ds_compl_historico_w;
            ctb_movimento_doc_w.nr_seq_agrupamento  := nr_seq_agrupamento_w;
            ctb_movimento_doc_w.nr_documento        := nr_documento_w;
            ctb_movimento_doc_w.ie_transitorio      := 'N';
            ctb_movimento_doc_w.ie_origem_documento := ie_origem_documento_w;
            ctb_movimento_doc_w.nr_seq_tab_orig     := lote_producao_w.nr_lote_producao;
            ctb_movimento_doc_w.nm_tabela           := nm_tabela_w;
            ctb_movimento_doc_w.nm_atributo         := nm_atributo_w;
            ctb_movimento_doc_w.nr_seq_info         := 9;
            ctb_movimento_doc_w.cd_sequencia_parametro      := cd_sequencia_parametro_es_w;

            ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto(ctb_movimento_doc_w, nm_usuario_p);
            end;
        end if;

        ie_centro_custo_w       := '';

        if (coalesce(cd_centro_custo_w,0) != 0) and (coalesce(cd_conta_credito_w,'0') != '0')then
            begin
            select  coalesce(a.ie_centro_custo,'N')
            into STRICT    ie_centro_custo_w
            from    conta_contabil a
            where   a.cd_conta_contabil     = cd_conta_credito_w;
            exception when others then
                            ie_centro_custo_w       := 'N';
            end;
        end if;

        if (coalesce(cd_conta_credito_w,'0') != '0') then
            begin
            ctb_movimento_doc_w.nr_sequencia        := null;
            get_sequence;
            ctb_movimento_doc_w.nr_lote_contabil    := nr_lote_contabil_w;
            ctb_movimento_doc_w.cd_conta_credito    := cd_conta_credito_w;
            ctb_movimento_doc_w.cd_conta_debito     := null;
            ctb_movimento_doc_w.cd_historico        := ctb_param_lote_producao_w.cd_historico;
            ctb_movimento_doc_w.dt_movimento        := lote_producao_w.dt_confirmacao;
            ctb_movimento_doc_w.vl_movimento        := lote_producao_w.vl_movimento;
            ctb_movimento_doc_w.ds_compl_historico  := ds_compl_historico_w;
            ctb_movimento_doc_w.nr_seq_agrupamento  := nr_seq_agrupamento_w;
            ctb_movimento_doc_w.nr_documento        := nr_documento_w;
            ctb_movimento_doc_w.ie_transitorio      := 'N';
            ctb_movimento_doc_w.ie_origem_documento := ie_origem_documento_w;
            ctb_movimento_doc_w.nr_seq_tab_orig     := lote_producao_w.nr_lote_producao;
            ctb_movimento_doc_w.nm_tabela           := nm_tabela_w;
            ctb_movimento_doc_w.nm_atributo         := nm_atributo_w;
            ctb_movimento_doc_w.nr_seq_info         := 9;
            ctb_movimento_doc_w.cd_sequencia_parametro      := cd_sequencia_parametro_pd_w;

            if (ie_centro_custo_w = 'S') then
                    ctb_movimento_doc_w.cd_centro_custo     := cd_centro_custo_w;
            end if;

            ctb_movimento_doc_w := ctb_online_pck.ctb_gravar_movto(ctb_movimento_doc_w, nm_usuario_p);
            end;
        end if;
        end;
    end if;
end;
end loop;
close c_lote_producao;

update          lote_contabil
set             dt_integracao           = clock_timestamp(),
                dt_geracao_lote         = clock_timestamp()
where           nr_lote_contabil        = nr_lote_contabil_w;

ds_erro_w := ctb_atualizar_saldo(    nr_lote_contabil_w, 'S', nm_usuario_p, 'N', ds_erro_w, 'S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_contab_onl_lote_producao ( dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
