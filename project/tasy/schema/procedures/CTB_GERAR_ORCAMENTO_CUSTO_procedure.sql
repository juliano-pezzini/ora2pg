-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_orcamento_custo ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_convenio_p bigint, qt_dias_prazo_p bigint, ie_orc_real_p bigint, ie_protocolo_p bigint, ie_sobrepor_p text, ie_valor_eis_p bigint, nr_seq_tabela_p bigint, ie_data_eis_p bigint, nm_usuario_p text) AS $body$
DECLARE

/*
===============================================================================
Purpose: Indentacao

Remarks: n/a

Who         When            What
----------  -----------     --------------------------------------------------

dmsluniere  18/mar/2022     OS 2871719 - Indentacao

===============================================================================
*/
cd_centro_custo_w               centro_custo.cd_centro_custo%type;
cd_centros_w                    varchar(2000) := ' ';
cd_contas_w                     varchar(2000) := ' ';
ds_erro_w                       varchar(2000);
ds_erro_ww                      varchar(2000);
cd_conta_contabil_w             conta_contabil.cd_conta_contabil%type;
cd_empresa_w                    tabela_custo.cd_empresa%type;
cd_estabelecimento_w            tabela_custo.cd_estabelecimento%type;
cd_grupo_nat_gasto_w            natureza_gasto.cd_grupo_natureza_gasto%type;
cd_nat_gasto_w                  ctb_saldo.cd_conta_contabil%type;
cd_natureza_gasto_w             natureza_gasto.cd_natureza_gasto%type;
ds_centro_custo_w               centro_custo.ds_centro_custo%type;
ds_convenio_w                   convenio.ds_convenio%type;
dt_ano_refer_w                  tabela_custo.dt_mes_referencia%type;
dt_mes_refer_w                  tabela_custo.dt_mes_referencia%type;
ie_importar_w                   cus_regra_imp_contab.ie_importar%type;
ie_tipo_gasto_w                 grupo_natureza_gasto.ie_tipo_gasto%type;
nr_seq_mes_ref_w                ctb_mes_ref.nr_sequencia%type;
qt_regra_w                      bigint;
vl_saldo_w                      ctb_saldo.vl_movimento%type;
ds_importacao_w                 varchar(255);
nr_seq_gng_natureza_w           natureza_gasto.cd_grupo_natureza_gasto%type;
nr_seq_ng_w                     natureza_gasto.nr_sequencia%type;
ie_valor_eis_w                  integer(5);
ie_data_eis_w                   integer(5);
ie_estab_atend_w                funcao_param_Usuario.vl_parametro%type := 'N';
ie_rest_fec_contab_w            funcao_param_Usuario.vl_parametro%type := 'S';
dt_fechamento_w                 ctb_mes_ref.dt_fechamento%type;
ie_valor_absoluto_orc_w         funcao_param_Usuario.vl_parametro%type;
ie_considerar_encer_saldo_w     parametro_custo.ie_considerar_encer_saldo%type;
ie_not_const                    constant      varchar(01) := 'N';
ie_yes_const                    constant      varchar(01) := 'S';
ie_tipo_r_const                 constant      varchar(01) := 'R';
ie_tipo_d_const                 constant      varchar(01) := 'D';
ie_tipo_c_const                 constant      varchar(01) := 'C';
ie_tipo_v_const                 constant      varchar(01) := 'V';
ie_tipo_f_const                 constant      varchar(01) := 'F';
ie_tipo_m_const                 constant      varchar(01) := 'M';
ie_month_const                  constant      varchar(05) := 'month';
ie_year_const                   constant      varchar(05) := 'year';
ie_ds_empresa_const             constant      varchar(15) := 'DS_EMPRESA=';
ie_ds_mes_const                 constant      varchar(10) := ';DS_MES=';
ie_na_const                     constant      varchar(05) := 'N/A';
ie_cd_centros_const             constant      varchar(15) := 'CD_CENTROS_W=';
ie_cd_contas_const              constant      varchar(15) := 'CD_CONTAS_W=';
ie_ds_erro_const                constant      varchar(15) := 'ds_erro_w=';
ie_ds_erro_ww_const             constant      varchar(15) := 'DS_ERRO_WW=';
tam_subst_const                 constant      integer(04)  := 1000;
ie_cd_funcao_const              constant      integer(04)  := 927;
msg_202866                      constant      integer(06)  := 202866;
msg_236890                      constant      integer(06)  := 236890;
msg_248386                      constant      integer(06)  := 248386;
msg_192987                      constant      integer(06)  := 192987;
msg_192989                      constant      integer(06)  := 192989;
msg_333514                      constant      integer(06)  := 333514;
msg_798489                      constant      integer(06)  := 798489;
msg_798491                      constant      integer(06)  := 798491;
msg_798492                      constant      integer(06)  := 798492;
msg_798493                      constant      integer(06)  := 798493;
msg_798494                      constant      integer(06)  := 798494;
msg_798495                      constant      integer(06)  := 798495;
msg_798497                      constant      integer(06)  := 798497;

c01 CURSOR FOR
SELECT  distinct
        a.cd_centro_custo
from    ctb_grupo_conta c,
        conta_contabil b,
        ctb_saldo a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     a.nr_seq_mes_ref      in (   SELECT  y.nr_sequencia
                                    from    ctb_mes_ref y
                                    where   trunc(y.dt_referencia,ie_month_const) = dt_mes_refer_w )
and     a.cd_conta_contabil   = b.cd_conta_contabil
and     b.cd_grupo            = c.cd_grupo
and     c.ie_tipo             in (ie_tipo_r_const,ie_tipo_d_const,ie_tipo_c_const)
and     (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> '')
and     a.vl_movimento        <> 0
and     ie_orc_real_p         = 2
and     not exists (    select  1
                                     from    centro_controle x
                                     where   a.cd_centro_custo      = x.cd_centro_controle
                                     and     a.cd_estabelecimento   = x.cd_estabelecimento)
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_centro_custo
from    estabelecimento d,
        ctb_orcamento a
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         in (12,22)
and     a.vl_orcado           <> 0
and     a.nr_seq_mes_ref      in (    select  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_year_const) = dt_ano_refer_w)
and     not exists (    select  1
                                     from    centro_controle x
                                     where   a.cd_centro_custo      = x.cd_centro_controle
                                     and     a.cd_estabelecimento   = x.cd_estabelecimento)
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_centro_custo
from    estabelecimento d,
        eis_receita_custo_v a
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN  a.dt_referencia  ELSE a.dt_receita END      = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_not_const
and     not exists (    select  1
                                     from    centro_controle x
                                     where   a.cd_centro_custo      = x.cd_centro_controle
                                     and     a.cd_estabelecimento   = x.cd_estabelecimento)
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_centro_custo
from    eis_receita_custo_v a,
        estabelecimento d
where   a.cd_estab_atend      = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN  a.dt_referencia  ELSE a.dt_receita END      = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_yes_const
and     not exists (    select  1
                                     from    centro_controle x
                                     where   a.cd_centro_custo      = x.cd_centro_controle
                                     and     a.cd_estab_atend       = x.cd_estabelecimento)
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estab_atend);

c02 CURSOR FOR
SELECT  distinct
        a.cd_conta_contabil
from    ctb_grupo_conta c,
        conta_contabil b,
        ctb_saldo a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     a.nr_seq_mes_ref      in (    SELECT  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_month_const) = dt_mes_refer_w )
and     a.cd_conta_contabil   = b.cd_conta_contabil
and     b.cd_grupo            = c.cd_grupo
and     c.ie_tipo             in (ie_tipo_r_const,ie_tipo_d_const,ie_tipo_c_const)
and     (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> '')
and     a.vl_movimento        <> 0
and     ie_orc_real_p         = 2
and     coalesce(cus_obter_natureza_gasto(a.cd_estabelecimento, a.cd_conta_contabil)::text, '') = ''
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_conta_contabil
from    ctb_orcamento a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         in (12,22)
and     a.vl_orcado           <> 0
and     a.nr_seq_mes_ref      in (    select  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_year_const) = dt_ano_refer_w)
and     coalesce(cus_obter_natureza_gasto(a.cd_estabelecimento, a.cd_conta_contabil)::text, '') = ''
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_conta_contabil
from    ctb_orcamento a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         in (12,22)
and     a.vl_orcado           <> 0
and     a.nr_seq_mes_ref      in (    select  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_year_const) = dt_ano_refer_w)
and     coalesce(cus_obter_natureza_gasto(a.cd_estabelecimento, a.cd_conta_contabil)::text, '') = ''
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_conta_contabil
from    eis_receita_custo_v a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN a.dt_referencia  ELSE a.dt_receita END       = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_not_const
and     coalesce(cus_obter_natureza_gasto(a.cd_estabelecimento, a.cd_conta_contabil)::text, '') = ''
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  distinct
        a.cd_conta_contabil
from    eis_receita_custo_v a,
        estabelecimento d
where   a.cd_estab_atend      = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN  a.dt_referencia  ELSE a.dt_receita END      = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_yes_const
and     coalesce(cus_obter_natureza_gasto(a.cd_estab_atend, a.cd_conta_contabil)::text, '') = ''
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento);

c03 CURSOR FOR
SELECT  a.cd_estabelecimento,
        a.cd_centro_custo,
        a.cd_conta_contabil,
        CASE WHEN ie_considerar_encer_saldo_w=ie_not_const THEN  CASE WHEN ie_valor_absoluto_orc_w=ie_yes_const THEN abs(a.vl_movimento)  ELSE a.vl_movimento END   ELSE CASE WHEN ie_valor_absoluto_orc_w=ie_yes_const THEN abs(a.vl_movimento - a.vl_encerramento)  ELSE a.vl_movimento - a.vl_encerramento END  END
from    ctb_grupo_conta c,
        conta_contabil b,
        ctb_saldo a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     a.nr_seq_mes_ref      in (    SELECT  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_month_const) = dt_mes_refer_w )
and     a.cd_conta_contabil   = b.cd_conta_contabil
and     b.cd_grupo            = c.cd_grupo
and     c.ie_tipo             in (ie_tipo_r_const,ie_tipo_d_const,ie_tipo_c_const)
and     ie_orc_real_p         = 2
and     (a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> '')
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)

union all

select  a.cd_estabelecimento,
        a.cd_centro_custo,
        a.cd_conta_contabil,
        sum(a.vl_orcado) / avg(12)
from    ctb_orcamento a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     a.nr_seq_mes_ref      in (    select  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_year_const) = dt_ano_refer_w)
and     ie_orc_real_p         = 12
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)
group by a.cd_estabelecimento,
         a.cd_centro_custo,
         a.cd_conta_contabil

union all

select  a.cd_estabelecimento,
        a.cd_centro_custo,
        a.cd_conta_contabil,
        sum(a.vl_orcado)
from    ctb_orcamento a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     a.nr_seq_mes_ref      in (    select  y.nr_sequencia
                                     from    ctb_mes_ref y
                                     where   trunc(y.dt_referencia,ie_month_const) = dt_mes_refer_w)
and     ie_orc_real_p         = 22
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)
group by a.cd_estabelecimento,
         a.cd_centro_custo,
         a.cd_conta_contabil

union all

select  a.cd_estabelecimento,
        a.cd_centro_custo,
        a.cd_conta_contabil,
        CASE WHEN ie_valor_eis_w=0 THEN sum(a.vl_receita) WHEN ie_valor_eis_w=1 THEN sum(a.vl_total) END  vl_orcado
from    eis_receita_custo_v a,
        estabelecimento d
where   a.cd_estabelecimento  = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN  a.dt_referencia  ELSE a.dt_receita END      = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_not_const
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estabelecimento)
group by a.cd_estabelecimento,
         a.cd_centro_custo,
         a.cd_conta_contabil

union all

select  a.cd_estab_atend,
        a.cd_centro_custo,
        a.cd_conta_contabil,
        CASE WHEN ie_valor_eis_w=0 THEN sum(a.vl_receita) WHEN ie_valor_eis_w=1 THEN sum(a.vl_total) END  vl_orcado
from    eis_receita_custo_v a,
        estabelecimento d
where   a.cd_estab_atend      = d.cd_estabelecimento
and     ie_orc_real_p         = 32
and     CASE WHEN ie_data_eis_w=1 THEN  a.dt_referencia  ELSE a.dt_receita END      = dt_mes_refer_w
and     ((coalesce(cd_convenio_p::text, '') = '')       or (a.cd_convenio  = cd_convenio_p))
and     ((ie_protocolo_p      = 0)           or (a.ie_protocolo = ie_protocolo_p))
and     ie_estab_atend_w      = ie_yes_const
and     exists (    select  1
                                     from    tabela_custo_acesso_v tca
                                     where   tca.nr_sequencia       = nr_seq_tabela_p
                                     and     tca.cd_empresa         = d.cd_empresa
                                     and     tca.cd_estabelecimento = a.cd_estab_atend)
group by a.cd_estab_atend,
         a.cd_centro_custo,
         a.cd_conta_contabil;


BEGIN

/* 0 = Liquido (Padrao)   1 = Faturado*/

ie_valor_eis_w  := ie_valor_eis_p;

/* 0 = Producao (Padrao)  1 = Faturado*/

ie_data_eis_w   := coalesce(ie_data_eis_p,0);

vl_parametro_p        => ie_estab_atend_w := obter_param_usuario(cd_funcao_p           => ie_cd_funcao_const, nr_sequencia_p        => 63, cd_perfil_p           => obter_perfil_ativo, nm_usuario_p          => nm_usuario_p, cd_estabelecimento_p  => cd_estabelecimento_p, vl_parametro_p        => ie_estab_atend_w);

vl_parametro_p        => ie_rest_fec_contab_w := obter_param_usuario(cd_funcao_p           => ie_cd_funcao_const, nr_sequencia_p        => 66, cd_perfil_p           => obter_perfil_ativo, nm_usuario_p          => nm_usuario_p, cd_estabelecimento_p  => cd_estabelecimento_p, vl_parametro_p        => ie_rest_fec_contab_w);

vl_parametro_p        => ie_valor_absoluto_orc_w := obter_param_usuario(cd_funcao_p           => ie_cd_funcao_const, nr_sequencia_p        => 79, cd_perfil_p           => obter_perfil_ativo, nm_usuario_p          => nm_usuario_p, cd_estabelecimento_p  => cd_estabelecimento_p, vl_parametro_p        => ie_valor_absoluto_orc_w);

if (ie_orc_real_p = 32) then
    select  substr(CASE WHEN coalesce(cd_convenio_p,0)=0 THEN wheb_mensagem_pck.get_texto(msg_798495) || ' ' ||wheb_mensagem_pck.get_texto(msg_798497)  ELSE obter_nome_convenio(cd_convenio_p) END ,1,100)
    into STRICT    ds_convenio_w
;
end if;

begin
    select  trunc(dt_mes_referencia,ie_month_const),
            trunc(dt_mes_referencia,ie_year_const),
            cd_estabelecimento,
            cd_empresa
    into STRICT    dt_mes_refer_w,
            dt_ano_refer_w,
            cd_estabelecimento_w,
            cd_empresa_w
    from    tabela_custo
    where   nr_sequencia                 = nr_seq_tabela_p;
exception
when no_data_found then
     ds_erro_w   := SUBSTR(sqlerrm, 1, tam_subst_const);
     CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_mensagem_erro_p => ds_erro_w);
when too_many_rows then
     ds_erro_w   := SUBSTR(sqlerrm, 1, tam_subst_const);
     CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_mensagem_erro_p => ds_erro_w);
end;

select  coalesce(max(ie_considerar_encer_saldo),ie_yes_const)
into STRICT    ie_considerar_encer_saldo_w
from    parametro_custo
where   cd_estabelecimento           = cd_estabelecimento_w;

select  coalesce(max(nr_sequencia),0)
into STRICT    nr_seq_mes_ref_w
from    ctb_mes_ref
where   trunc(dt_referencia,ie_month_const) = dt_mes_refer_w
and     cd_empresa                   = cd_empresa_w;

if (nr_seq_mes_ref_w = 0) then

    CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p     => msg_248386,
                    vl_macros_p           => ie_ds_empresa_const || substr(coalesce(obter_nome_empresa(cd_empresa_w),ie_na_const),1,80) || ie_ds_mes_const || initcap(to_char(clock_timestamp(),ie_month_const))
                    );
end if;

if (ie_rest_fec_contab_w = ie_not_const) then

    begin
        select  dt_fechamento
        into STRICT    dt_fechamento_w
        from    ctb_mes_ref
        where   nr_sequencia = nr_seq_mes_ref_w;
    exception
    when no_data_found then
         CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => msg_236890);
    when too_many_rows then
         CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => msg_236890);
    end;

    if (coalesce(dt_fechamento_w::text, '') = '') then

        CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => msg_202866);

    end if;

end if;

select  count(*)
into STRICT    qt_regra_w
from    cus_regra_imp_contab
where   cd_estabelecimento      = cd_estabelecimento_w;

open c01;
loop
fetch c01 into
      cd_centro_custo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

    select  substr(max(ds_centro_custo),1,80)
    into STRICT    ds_centro_custo_w
    from    centro_custo
    where   cd_centro_custo     = cd_centro_custo_w;

    if (length(cd_centros_w) < 1900) then

        cd_centros_w    := cd_centros_w || cd_centro_custo_w || ' ' || ds_centro_custo_w || chr(10);

    end if;

end loop;
close c01;

if (cd_centros_w <> ' ') then

    CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p     => msg_192987,
                    vl_macros_p           => substr(ie_cd_centros_const||cd_centros_w,1,tam_subst_const)
                    );

end if;

open c02;
loop
fetch c02 into
      cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

    select  coalesce(cus_obter_natureza_gasto(cd_estabelecimento_w, cd_conta_contabil_w),0)
    into STRICT    cd_natureza_gasto_w
;

    if (length(cd_contas_w) < 1900) and (cd_natureza_gasto_w = 0) then

        cd_contas_w := cd_contas_w || cd_conta_contabil_w || ' ';

    end if;

end loop;
close c02;

if (cd_contas_w <> ' ') then

    CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p     => msg_333514,
                    vl_macros_p           => ie_cd_contas_const||cd_contas_w
                    );

end if;

open c03;
loop
fetch c03 into
    cd_estabelecimento_w,
    cd_centro_custo_w,
    cd_conta_contabil_w,
    vl_saldo_w;
EXIT WHEN NOT FOUND; /* apply on c03 */

    nr_seq_ng_w := cus_obter_natureza_gasto(
                    cd_estabelecimento_p  => cd_estabelecimento_w,
                    cd_conta_contabil_p   => cd_conta_contabil_w
                    );
    if (coalesce(nr_seq_ng_w,0) <> 0) then

        select  max(cd_natureza_gasto)
        into STRICT    cd_natureza_gasto_w
        from    natureza_gasto
        where   nr_sequencia    = nr_seq_ng_w;

    end if;

    cd_conta_contabil_w         := cd_natureza_gasto_w;
    ie_importar_w               := ie_yes_const;

    select  count(*)
    into STRICT    qt_regra_w
    from    cus_regra_imp_contab
    where   cd_estabelecimento  = cd_estabelecimento_w;

    if (qt_regra_w > 0) then
        
        cd_nat_gasto_w          := cd_conta_contabil_w;

        select  max(cd_grupo_natureza_gasto),
                max(nr_seq_gng)
        into STRICT    cd_grupo_nat_gasto_w,
                nr_seq_gng_natureza_w
        from    natureza_gasto
        where   nr_sequencia    = nr_seq_ng_w;

        select  coalesce(max(cus_obter_se_importar_orc(cd_estabelecimento_w, nr_seq_gng_natureza_w, nr_seq_ng_w, ie_orc_real_p, cd_centro_custo_w )),ie_yes_const)
        into STRICT    ie_importar_w
;

    end if;

    
    if (ie_importar_w = ie_yes_const) and (ie_sobrepor_p = ie_not_const) then

        delete FROM orcamento_custo
        where  nr_seq_tabela       = nr_seq_tabela_p
        and    cd_centro_controle  = cd_centro_custo_w
        and    nr_seq_ng           = nr_seq_ng_w
        and    cd_estabelecimento  = cd_estabelecimento_w
        and    nr_seq_ng           = nr_seq_ng_w;

    end if;

    if (ie_sobrepor_p = ie_yes_const) and (vl_saldo_w    <> 0) then

        update  orcamento_custo
        set     vl_orcado          = vl_saldo_w,
                dt_atualizacao     = clock_timestamp(),
                nm_usuario         = nm_usuario_p
        where   nr_seq_tabela      = nr_seq_tabela_p
        and     cd_centro_controle = cd_centro_custo_w
        and     nr_seq_ng          = nr_seq_ng_w;

        if (NOT FOUND) then
            ie_importar_w   := ie_yes_const;
        else
            ie_importar_w   := ie_not_const;
        end if;

    end if;

    if (vl_saldo_w     <> 0) and (ie_importar_w  = ie_yes_const) then

        ie_tipo_gasto_w := substr(cus_obter_tipo_gasto_centro(
                    cd_estabelecimento_p  => cd_estabelecimento_w,
                    cd_centro_controle_p  => cd_centro_custo_w,
                    nr_seq_gng_p          => null,
                    cd_natureza_gasto_p   => cd_conta_contabil_w,
                    nr_seq_ng_p           => nr_seq_ng_w),1,1);

        if (ie_tipo_gasto_w in (ie_tipo_v_const,ie_tipo_f_const,ie_tipo_r_const)) then

            begin
            insert into orcamento_custo(
                nr_sequencia,
                cd_estabelecimento,
                cd_tabela_custo,
                cd_centro_controle,
                cd_natureza_gasto,
                nr_seq_ng,
                dt_atualizacao,
                nm_usuario,
                vl_orcado,
                vl_avista,
                vl_distribuido,
                vl_receb_distrib,
                qt_dias_prazo,
                vl_a_distribuir,
                ie_tipo_gasto,
                nr_seq_tabela)
            values ( nextval('orcamento_custo_seq'),
                cd_estabelecimento_w,
                cd_tabela_custo_p,
                cd_centro_custo_w,
                cd_conta_contabil_w,
                nr_seq_ng_w,
                clock_timestamp(),
                nm_usuario_p,
                vl_saldo_w,
                0,
                0,
                0,
                qt_dias_prazo_p,
                0,
                ie_tipo_gasto_w,
                nr_seq_tabela_p);

            exception 
            when access_into_null then
                 ds_erro_ww  := wheb_mensagem_pck.get_texto(msg_798489) || ' ' || nr_seq_ng_w     || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798491) || ' ' || cd_centro_custo_w   || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798492) || ' ' || cd_conta_contabil_w || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798493) || ' ' || ie_tipo_gasto_w     || chr(13) || chr(10);
                 ds_erro_w   := sqlerrm(SQLSTATE);
                 CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p => msg_192989,
                    vl_macros_p       => ie_ds_erro_ww_const||ds_erro_ww||';'|| ie_ds_erro_const||ds_erro_w
                    );
            when unique_violation then
                 ds_erro_ww  := wheb_mensagem_pck.get_texto(msg_798489) || ' ' || nr_seq_ng_w     || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798491) || ' ' || cd_centro_custo_w   || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798492) || ' ' || cd_conta_contabil_w || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798493) || ' ' || ie_tipo_gasto_w     || chr(13) || chr(10);
                 ds_erro_w   := sqlerrm(SQLSTATE);
                 CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p => msg_192989,
                    vl_macros_p       => ie_ds_erro_ww_const||ds_erro_ww||';'|| ie_ds_erro_const||ds_erro_w
                    );
            when others then
                 /*
                 Identificado na OS325775, que caso haja no mes (Saldo contabil)  contas com movimento sendo 
                 importadas, e que nao possuem naturezas  vinculadas a estas,  o sistema acaba tentando inserir um
                 valor nulo no campo NR_SEQ_NG ocasionando erro de UK.
                 Caso ocorra uma consistencia semelhante a acima mencionada, verificar anteriormente o cadastro da
                 base do cliente e orienta-lo sobre esta situacao(Cadastros custos\Natureza gasto)).
                 */
                 ds_erro_ww  := wheb_mensagem_pck.get_texto(msg_798489) || ' ' || nr_seq_ng_w     || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798491) || ' ' || cd_centro_custo_w   || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798492) || ' ' || cd_conta_contabil_w || chr(13) || chr(10) ||
                            wheb_mensagem_pck.get_texto(msg_798493) || ' ' || ie_tipo_gasto_w     || chr(13) || chr(10);

                 ds_erro_w   := sqlerrm(SQLSTATE);
                 /*'Erro Inclusao ' || chr(10) || ds_erro_ww || chr(13) || chr(10) || ds_erro_w || '#@#@');*/

                 CALL wheb_mensagem_pck.exibir_mensagem_abort(
                    nr_seq_mensagem_p => msg_192989,
                    vl_macros_p       => ie_ds_erro_ww_const||ds_erro_ww||';'|| ie_ds_erro_const||ds_erro_w
                    );
            end;

            select  substr(wheb_mensagem_pck.get_texto(msg_798494) || ' ' || ie_protocolo_p || chr(32) || CASE WHEN ie_orc_real_p=32 THEN wheb_mensagem_pck.get_texto(msg_798495) || ' ' || ds_convenio_w  ELSE null END ,1,254)
            into STRICT    ds_importacao_w
;

            CALL cus_gravar_log_importacao(
                    cd_estabelecimento_p  => cd_estabelecimento_w,
                    cd_tabela_custo_p     => cd_tabela_custo_p,
                    cd_centro_controle_p  => cd_centro_custo_w,
                    cd_natureza_gasto_p   => cd_conta_contabil_w,
                    ie_tipo_importacao_p  => ie_orc_real_p,
                    ds_importacao_p       => ds_importacao_w,
                    vl_orcado_p           => vl_saldo_w,
                    nm_usuario_p          => nm_usuario_p,
                    nr_seq_mes_ref_p      => nr_seq_mes_ref_w
                    );

        elsif (ie_tipo_gasto_w = ie_tipo_m_const) then

            cus_ratear_orcamento_tipo(
                    cd_estabelecimento_p  => cd_estabelecimento_w,
                    cd_tabela_custo_p     => cd_tabela_custo_p,
                    cd_centro_controle_p  => cd_centro_custo_w,
                    cd_natureza_gasto_p   => cd_conta_contabil_w,
                    vl_orcado_p           => vl_saldo_w,
                    qt_dias_prazo_p       => qt_dias_prazo_p,
                    ie_orc_real_p         => ie_orc_real_p,
                    nm_usuario_p          => nm_usuario_p,
                    nr_seq_tabela_p       => nr_seq_tabela_p
                    );

        end if;

    end if;
end loop;
close c03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_orcamento_custo ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_convenio_p bigint, qt_dias_prazo_p bigint, ie_orc_real_p bigint, ie_protocolo_p bigint, ie_sobrepor_p text, ie_valor_eis_p bigint, nr_seq_tabela_p bigint, ie_data_eis_p bigint, nm_usuario_p text) FROM PUBLIC;

