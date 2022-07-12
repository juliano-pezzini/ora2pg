-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE custos_pck.obter_custo_mat_compra ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_tipo_parametro_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w                   material.cd_material%type;
cd_material_ww                  material.cd_material%type;
cd_material_compra_w            material.cd_material%type;
cd_material_estoque_w           material.cd_material%type;
cd_unid_med_compra_w            varchar(30);
cd_unid_med_compra_nf_w         varchar(30);
cd_unid_med_consumo_w           varchar(30);
cd_unid_med_estoque_w           varchar(30);


/* Unidades do Material que esta sendo calculado */


cd_unid_med_compra_mat_w        varchar(30);
cd_unid_med_estoque_mat_w       varchar(30);
cd_unid_med_consumo_mat_w       varchar(30);
qt_conv_compra_estoque_mat_w    double precision;
qt_conv_estoque_consumo_mat_w   double precision;

ie_somente_custo_mes_w          parametro_custo.ie_somente_custo_mes%type;
nr_sequencia_w                  nota_fiscal_item.nr_sequencia%type;
ds_observacao_w                 custo_material.ds_observacao%type;
nr_item_nf_w                    nota_fiscal_item.nr_item_nf%type;
ds_material_estoque_w           varchar(300);
qt_conv_compra_estoque_w        double precision;
qt_conv_estoque_consumo_w       double precision;
qt_dias_prazo_w                 double precision;
qt_custo_compra_w               double precision;
vl_custo_compra_w               double precision;
vl_custo_unit_w                 double precision;
vl_tributo_w                    double precision;
vl_custo_item_w                 double precision;

dt_parametro_w                  timestamp;
dt_fim_parametro_w              timestamp;
dt_referencia_w                 timestamp;
nr_indice_w                     integer;

c01 CURSOR(
       cd_estabelecimento_pc        custo_material.cd_estabelecimento%type,
       nr_seq_tabela_pc         custo_material.nr_seq_tabela%type
       ) FOR
       SELECT  x.cd_material,
               x.cd_unidade_medida_compra,
               x.cd_unidade_medida_estoque,
               x.cd_unidade_medida_consumo,
               x.qt_conv_compra_estoque,
               x.qt_conv_estoque_consumo
       from (  SELECT  a.cd_material,
                       substr(coalesce(a.cd_unidade_medida_compra,  b.cd_unidade_medida_compra),1,30) cd_unidade_medida_compra,
                       substr(coalesce(a.cd_unidade_medida_estoque, b.cd_unidade_medida_estoque),1,30) cd_unidade_medida_estoque,
                       substr(coalesce(a.cd_unidade_medida_consumo, b.cd_unidade_medida_consumo),1,30) cd_unidade_medida_consumo,
                       coalesce(a.qt_conv_compra_estoque, b.qt_conv_compra_estoque) qt_conv_compra_estoque,
                       coalesce(a.qt_conv_estoque_consumo, b.qt_conv_estoque_consumo) qt_conv_estoque_consumo
               from    material_estab a,
                       material b,
                       custo_material c
               where   a.cd_material           = b.cd_material
               and     a.cd_material           = c.cd_material
               and     a.cd_estabelecimento    = c.cd_estabelecimento
               and     c.ie_origem_custo       = 'C'
               and     c.cd_estabelecimento    = cd_estabelecimento_pc
               and     c.nr_seq_tabela         = nr_seq_tabela_pc
               and     coalesce(c.vl_cotado_compra::text, '') = ''

union

               select  d.cd_material,
                       substr(coalesce(c.cd_unidade_medida_compra,  d.cd_unidade_medida_compra) ,1,30) cd_unidade_medida_compra,
                       substr(coalesce(c.cd_unidade_medida_estoque, d.cd_unidade_medida_estoque),1,30) cd_unidade_medida_estoque,
                       substr(coalesce(c.cd_unidade_medida_consumo, d.cd_unidade_medida_consumo),1,30) cd_unidade_medida_consumo,
                       coalesce(c.qt_conv_compra_estoque, d.qt_conv_compra_estoque) qt_conv_compra_estoque,
                       coalesce(c.qt_conv_estoque_consumo, d.qt_conv_estoque_consumo) qt_conv_estoque_consumo
               from    material_estab  c,
                       material d,
                       custo_material f
               where   c.cd_material           = d.cd_material
               and     c.cd_estabelecimento    = f.cd_estabelecimento
               and     d.cd_material_generico  = f.cd_material
               and     f.ie_origem_custo       = 'C'
               and     f.cd_estabelecimento    = cd_estabelecimento_pc
               and     f.nr_seq_tabela         = nr_seq_tabela_pc
               and     coalesce(f.vl_cotado_compra::text, '') = ''
               
union

               select  a.cd_material,
                       substr(a.cd_unidade_medida_compra ,1,30) cd_unidade_medida_compra,
                       substr(a.cd_unidade_medida_estoque,1,30) cd_unidade_medida_estoque,
                       substr(a.cd_unidade_medida_consumo,1,30) cd_unidade_medida_consumo,
                       coalesce(a.qt_conv_compra_estoque,1) qt_conv_compra_estoque,
                       coalesce(a.qt_conv_estoque_consumo,1) qt_conv_estoque_consumo
               from    material a,
                       custo_material b
               where   a.cd_material           = b.cd_material
               and     b.ie_origem_custo       = 'C'
               and     b.cd_estabelecimento    = cd_estabelecimento_pc
               and     b.nr_seq_tabela         = nr_seq_tabela_pc
               and     coalesce(b.vl_cotado_compra::text, '') = '' ) 
          x;

type t_c01 is table of c01%rowtype index by integer;
l_c01 t_c01;

type vetor_vl_cotado_compra is table of custo_material.vl_cotado_compra%type index by integer;
v_vl_cotado_compra_w   vetor_vl_cotado_compra;

type vetor_qt_dias_prazo is table of custo_material.qt_dias_prazo%type index by integer;
v_qt_dias_prazo_w   vetor_qt_dias_prazo;

type vetor_ds_observacao is table of custo_material.ds_observacao%type index by integer;
v_ds_observacao_w   vetor_ds_observacao;

type vetor_cd_material is table of custo_material.cd_material%type index by integer;
v_cd_material_w   vetor_cd_material;



BEGIN
/* Inicializacao de variaveis */


cd_material_estoque_w   := null;
cd_material_w           := 0;
cd_material_ww          := 0;
cd_material_compra_w    := 0;
nr_sequencia_w          := 0;
nr_item_nf_w            := 0;
qt_dias_prazo_w         := 0;
qt_custo_compra_w       := 0;
vl_custo_compra_w       := 0;
vl_custo_unit_w         := 0;
vl_tributo_w            := 0;

/*Obter a data para buscar os valores de custo do material*/



select  coalesce(max(dt_parametro),trunc(clock_timestamp()))
into STRICT    dt_parametro_w
from    tabela_parametro
where   cd_estabelecimento  = cd_estabelecimento_p
and     nr_seq_tabela       = nr_seq_tabela_p
and     nr_seq_parametro    = 4;

select  coalesce(max(ie_somente_custo_mes),'N')
into STRICT    ie_somente_custo_mes_w
from    parametro_custo
where   cd_estabelecimento  = cd_estabelecimento_p;


if (ie_somente_custo_mes_w = 'S') then
       select  max(dt_mes_referencia)
       into STRICT    dt_fim_parametro_w
       from    tabela_custo
       where   cd_estabelecimento  = cd_estabelecimento_p
       and     cd_tabela_custo     = cd_tabela_custo_p;

       dt_fim_parametro_w  := fim_mes(dt_fim_parametro_w);
end if;

dt_fim_parametro_w  := (trunc(coalesce(dt_fim_parametro_w, clock_timestamp()),'dd') + 86399/86400);

open c01(
        cd_estabelecimento_pc   => cd_estabelecimento_p,
        nr_seq_tabela_pc        => nr_seq_tabela_p
        );
        loop fetch c01 bulk collect into l_c01 limit 1000;
        exit when l_c01.count = 0;
             for i in 1..l_c01.count loop

             vl_custo_unit_w := 0;
             vl_custo_item_w := 0;

             ds_observacao_w         := null;
             ds_material_estoque_w   := null;

             cd_material_compra_w        := l_c01[i].cd_material;
             cd_unid_med_compra_w        := l_c01[i].cd_unidade_medida_compra;
             cd_unid_med_estoque_w       := l_c01[i].cd_unidade_medida_estoque;
             cd_unid_med_consumo_w       := l_c01[i].cd_unidade_medida_consumo;
             qt_conv_compra_estoque_w    := l_c01[i].qt_conv_compra_estoque;
             qt_conv_estoque_consumo_w   := l_c01[i].qt_conv_estoque_consumo;

             if (l_c01[i].cd_material <> cd_material_ww)  then
                    cd_unid_med_compra_mat_w        := l_c01[i].cd_unidade_medida_compra;
                    cd_unid_med_estoque_mat_w       := l_c01[i].cd_unidade_medida_estoque;
                    cd_unid_med_consumo_mat_w       := l_c01[i].cd_unidade_medida_consumo;
                    qt_conv_compra_estoque_mat_w    := l_c01[i].qt_conv_compra_estoque;
                    qt_conv_estoque_consumo_mat_w   := l_c01[i].qt_conv_estoque_consumo;
             end if;

             exit when vl_custo_unit_w <> 0;

             if (ie_tipo_parametro_p = 1) then
                    begin
                    select  coalesce(max(a.nr_sequencia),0),
                            max(a.nr_item_nf),
                            max(a.qt_item_nf),
                            max(a.cd_unidade_medida_compra),
                            (coalesce(max(a.vl_total_item_nf),0) + coalesce(max(a.vl_frete),0) +
                            coalesce(max(a.vl_despesa_acessoria),0) +
                            coalesce(max(a.vl_seguro),0) -
                            coalesce(max(a.vl_desconto),0) -
                            coalesce(max(a.vl_desconto_rateio),0))
                    into STRICT    nr_sequencia_w,
                            nr_item_nf_w,
                            qt_custo_compra_w,
                            cd_unid_med_compra_nf_w,
                            vl_custo_compra_w
                    from    operacao_estoque d,
                            operacao_nota c,
                            nota_fiscal b,
                            nota_fiscal_item a
                    where   a.nr_sequencia        = b.nr_sequencia
                    and     b.cd_operacao_nf      = c.cd_operacao_nf
                    and     c.cd_operacao_estoque = d.cd_operacao_estoque
                    and     d.ie_entrada_saida    = 'E' /* Somente notas fiscais de entrada */

                    and     a.cd_material         = cd_material_compra_w
                    and     a.cd_estabelecimento  = cd_estabelecimento_p
                    and     a.dt_atualizacao      =  (   SELECT  max(x.dt_atualizacao)
                                                         from    nota_fiscal_item x
                                                         where   x.cd_material        = cd_material_compra_w
                                                         and     x.cd_estabelecimento = cd_estabelecimento_p
                                                         and     x.dt_atualizacao     >= dt_parametro_w
                                                         and     x.dt_atualizacao     <= dt_fim_parametro_w);
                    exception when others then
                              qt_custo_compra_w   := 0;
                              vl_custo_compra_w   := 0;
                    end;

                    select  coalesce(sum(vl_tributo),0)
                    into STRICT    vl_tributo_w
                    from    nota_fiscal_item_trib
                    where   nr_sequencia  = nr_sequencia_w
                    and     nr_item_nf    = nr_item_nf_w;

                    select  coalesce(max(qt_dias_prazo),0)
                    into STRICT    qt_dias_prazo_w
                    from    nota_fiscal_prazo_medio_v
                    where   nr_sequencia   = nr_sequencia_w;

                    if (qt_custo_compra_w > 0) then
                            vl_custo_unit_w     := dividir((vl_custo_compra_w + vl_tributo_w), qt_custo_compra_w);
                    end if;

                    vl_custo_item_w         := coalesce(vl_custo_unit_w,0);

                    if (cd_unid_med_compra_nf_w = cd_unid_med_estoque_w) then
                            vl_custo_unit_w     := vl_custo_unit_w * qt_conv_compra_estoque_w;
                    elsif (cd_unid_med_compra_nf_w = cd_unid_med_consumo_w) then
                            vl_custo_unit_w     := vl_custo_unit_w * qt_conv_compra_estoque_w * qt_conv_estoque_consumo_w;
                    end if;

                    if (cd_material_compra_w <> l_c01[i].cd_material) and (cd_unid_med_compra_w <> cd_unid_med_compra_mat_w) then
                             vl_custo_unit_w     := vl_custo_item_w;

                            if (cd_unid_med_compra_nf_w = cd_unid_med_estoque_mat_w) then
                                    vl_custo_unit_w     := vl_custo_unit_w * qt_conv_compra_estoque_mat_w;
                            elsif (cd_unid_med_compra_nf_w = cd_unid_med_consumo_mat_w) then
                                    vl_custo_unit_w     := vl_custo_unit_w * qt_conv_compra_estoque_mat_w * qt_conv_estoque_consumo_mat_w;
                           end if;
                    end if;

                    ds_observacao_w := substr(wheb_mensagem_pck.get_texto(nr_seq_mensagem_p => 298469,  Vl_Macros_P => 'DT_PARAM=' || to_char(dt_parametro_w,'dd/mm/yyyy') || ';' ||
                                                   'NR_SEQ_NOTA=' || nr_sequencia_w || ';' ||
                                                   'NR_SEQ_ITEM=' || nr_item_nf_w || ';' ||
                                                   'QT_CUSTO=' || qt_custo_compra_w || ';' ||
                                                   'QT_CONV_COMP_EST=' || qt_conv_compra_estoque_w || ';' ||
                                                   'QT_CONV_EST_CONS=' || qt_conv_estoque_consumo_w),1,4000);

                    if (vl_tributo_w <> 0) then
                           ds_observacao_w := substr(wheb_mensagem_pck.get_texto(nr_seq_mensagem_p => 298471, Vl_Macros_P =>  'DS_OBS=' || ds_observacao_w || ';' ||
                                                        'VL_TRIB=' || vl_tributo_w),1,4000);
                    end if;
             else
                    begin
                    select  coalesce(max(cd_material_estoque), l_c01[i].cd_material)
                    into STRICT    cd_material_estoque_w
                    from    material
                    where   cd_material = cd_material_compra_w;

                    if (l_c01[i].cd_material = cd_material_compra_w) then
                          select  coalesce(max(dt_mesano_referencia),dt_parametro_w)
                          into STRICT    dt_referencia_w
                          from    saldo_estoque
                          where   cd_estabelecimento  = cd_estabelecimento_p
                          and     cd_material     = cd_material_estoque_w
                          and     dt_mesano_referencia between dt_parametro_w and trunc(dt_fim_parametro_w,'month');

                          if (coalesce(cd_material_estoque_w,0) <> 0) then
                                 if (l_c01[i].cd_material <> cd_material_estoque_w) then
                                       ds_material_estoque_w   := substr(wheb_mensagem_pck.get_texto(nr_seq_mensagem_p => 298473, Vl_Macros_P => 
                                                                         'CD_MAT_EST=' || cd_material_estoque_w || ';' ||
                                                                         'DS_MAT_EST=' || substr(obter_desc_material(cd_material_estoque_w),1,255)),1,300);
                                 end if;
                                 begin
                                 select  max(vl_custo_medio)
                                 into STRICT    vl_custo_unit_w
                                 from    saldo_estoque
                                 where   cd_estabelecimento    = cd_estabelecimento_p
                                 and     cd_material           = cd_material_estoque_w
                                 and     dt_mesano_referencia  = trunc(dt_referencia_w,'mm');
                                 exception when others then
                                           vl_custo_unit_w:=0;
                                 end;

                          end if;
                          vl_custo_unit_w := vl_custo_unit_w * qt_conv_compra_estoque_w;

                          ds_observacao_w := substr(wheb_mensagem_pck.get_texto(nr_seq_mensagem_p => 298478, vl_macros_p =>   'DT_PARAM=' || to_char(dt_parametro_w,'dd/mm/yyyy') || ';' ||
                                                    'DR_REF=' || dt_referencia_w || ';' ||
                                                    'QT_CONV_COMP_EST=' || qt_conv_compra_estoque_w || ';' ||
                                                    'DS_MAT_EST=' || ds_material_estoque_w),1,4000);
                    end if;
                    end;
             end if;

             if (vl_custo_unit_w > 0)  then
                     nr_indice_w := v_vl_cotado_compra_w.count + 1;
                     v_vl_cotado_compra_w(nr_indice_w) := vl_custo_unit_w;
                     v_qt_dias_prazo_w(nr_indice_w)    := qt_dias_prazo_w;
                     v_ds_observacao_w(nr_indice_w)    :=ds_observacao_w;
                     v_cd_material_w(nr_indice_w)      := l_c01[i].cd_material;

             end if;

            cd_material_ww  := l_c01[i].cd_material;

            end loop;
            begin
            forall indice in v_vl_cotado_compra_w.first .. v_vl_cotado_compra_w.last
            update  custo_material
            set     vl_cotado_compra    = v_vl_cotado_compra_w(indice),
                    qt_dias_prazo       = v_qt_dias_prazo_w(indice),
                    ds_observacao       = v_ds_observacao_w(indice),
                    dt_atualizacao      = clock_timestamp(),
                    nm_usuario          = nm_usuario_p
            where   cd_estabelecimento  = cd_estabelecimento_p
            and     cd_material         = v_cd_material_w(indice)
            and     nr_seq_tabela       = nr_seq_tabela_p;
            commit;
            v_vl_cotado_compra_w.delete;
            v_qt_dias_prazo_w.delete;
            v_ds_observacao_w.delete;
            v_cd_material_w.delete;
            end;
        end loop;
close c01;

CALL custos_pck.calcular_cotacao_avista( cd_estabelecimento_p => cd_estabelecimento_p,
                                    cd_tabela_custo_p    => cd_tabela_custo_p,
                                    nr_seq_tabela_p      => nr_seq_tabela_p,
                                    nm_usuario_p         => nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE custos_pck.obter_custo_mat_compra ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_tipo_parametro_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) FROM PUBLIC;