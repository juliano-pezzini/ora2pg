-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_consistir_lote ( nr_lote_contabil_p ctb_movimento.nr_lote_contabil%type, ds_erro_p INOUT text, nm_usuario_p ctb_movimento.nm_usuario%type) AS $body$
DECLARE


ds_exception_w                  varchar(4000);
ds_erro_w                       varchar(2000);
ds_erro_ww                      varchar(2000);
ds_erro_movto_w                 varchar(255);
ds_log_lote_w                   varchar(2000);
vl_total_debito_w               ctb_movimento.vl_movimento%type := 0;
vl_total_credito_w              ctb_movimento.vl_movimento%type := 0;
ie_centro_custo_inativo_w       varchar(01);
ie_encerramento_w               lote_contabil.ie_encerramento%type;
cd_empresa_w                    ctb_mes_ref.cd_empresa%type;
cd_estabelecimento_w            ctb_movimento.cd_estabelecimento%type;
ie_movto_valor_zerado_w         varchar(1);
ie_movto_valor_negativo_w       varchar(1);
ie_movto_centro_estab_w         varchar(1);
ie_consistir_data_movto_w       varchar(1);
ie_consiste_movto_pendente_w    varchar(1);
ie_consiste_revisao_w           tipo_lote_contabil.ie_consiste_revisao%type;
dt_referencia_w                 ctb_movimento.dt_movimento%type;
nr_rowid_w                      oid;
cd_tipo_lote_contabil_w         tipo_lote_contabil.cd_tipo_lote_contabil%type;
qt_tipo_lote_pl_w               bigint;
qt_mov_lote_pl_w                bigint;
ds_consistencia_w               ctb_movimento.ds_consistencia%type;
ie_plano_conta_ifrs_w           empresa.ie_plano_conta_ifrs%type;


BEGIN
begin
CALL philips_contabil_pck.set_ie_consistindo_lote('S');

CALL ctb_gerar_agrup_movto(nr_lote_contabil_p,nm_usuario_p);

begin
select  1
into STRICT    qt_tipo_lote_pl_w
from    tipo_lote_contabil
where   cd_tipo_lote_contabil = 54  LIMIT 1;
exception
    when no_data_found then
        qt_tipo_lote_pl_w := 0;
    when too_many_rows then
        qt_tipo_lote_pl_w := 0;
    when others then
        qt_tipo_lote_pl_w := 0;
end;

ds_erro_w   := '';
ds_erro_ww  := '';

/*Limpa a data e as consistencias*/

update  lote_contabil
set     dt_consistencia  = NULL
where   nr_lote_contabil = nr_lote_contabil_p;
commit;

if (coalesce(philips_contabil_pck.get_ie_reat_saldo(),'N') = 'N') then

    update  ctb_movimento
    set     ds_consistencia  = NULL,
            ie_validacao  = NULL
    where   nr_lote_contabil = nr_lote_contabil_p
    and     (ds_consistencia IS NOT NULL AND ds_consistencia::text <> '');

end if;

commit;

/* Dados do lote contabil*/

begin
select  coalesce(b.ie_encerramento,'N'),
        b.cd_estabelecimento,
        coalesce(a.ie_consiste_revisao,'S'),
        a.cd_tipo_lote_contabil
into STRICT    ie_encerramento_w,
        cd_estabelecimento_w,
        ie_consiste_revisao_w,
        cd_tipo_lote_contabil_w
from    tipo_lote_contabil a,
        lote_contabil b
where   b.cd_tipo_lote_contabil = a.cd_tipo_lote_contabil
and     b.nr_lote_contabil = nr_lote_contabil_p;
exception
    when no_data_found then
        ie_encerramento_w       := null;
        cd_estabelecimento_w    := null;
        ie_consiste_revisao_w   := null;
        cd_tipo_lote_contabil_w := null;
    when too_many_rows then
        ie_encerramento_w       := null;
        cd_estabelecimento_w    := null;
        ie_consiste_revisao_w   := null;
        cd_tipo_lote_contabil_w := null;
    when others then
        ie_encerramento_w       := null;
        cd_estabelecimento_w    := null;
        ie_consiste_revisao_w   := null;
        cd_tipo_lote_contabil_w := null;
end;

begin
select  b.cd_empresa,
        b.dt_referencia
into STRICT    cd_empresa_w,
        dt_referencia_w
from    ctb_mes_ref b,
        lote_contabil a
where   a.nr_lote_contabil  = nr_lote_contabil_p
and     a.nr_seq_mes_ref    = b.nr_sequencia;
exception
    when no_data_found then
        cd_empresa_w    := null;
        dt_referencia_w := null;
    when too_many_rows then
        cd_empresa_w    := null;
        dt_referencia_w := null;
    when others then
        cd_empresa_w    := null;
        dt_referencia_w := null;
end;

/* Parametro de consistencia*/

ie_centro_custo_inativo_w       := coalesce(obter_valor_param_usuario(923, 43, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'S');
ie_movto_valor_zerado_w         := coalesce(obter_valor_param_usuario(923, 49, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'S');
ie_movto_valor_negativo_w       := coalesce(obter_valor_param_usuario(923, 51, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'N');
ie_movto_centro_estab_w         := coalesce(obter_valor_param_usuario(923, 68, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'S');
ie_consistir_data_movto_w       := coalesce(obter_valor_param_usuario(923, 70, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'N');
ie_consiste_movto_pendente_w    := coalesce(obter_valor_param_usuario(923, 84, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'N');

select  coalesce(sum(vl_movimento),0)
into STRICT    vl_total_debito_w
from    ctb_movimento
where   nr_lote_contabil = nr_lote_contabil_p
and     (cd_conta_debito IS NOT NULL AND cd_conta_debito::text <> '');

select  coalesce(sum(vl_movimento),0)
into STRICT    vl_total_credito_w
from    ctb_movimento
where   nr_lote_contabil = nr_lote_contabil_p
and     (cd_conta_credito IS NOT NULL AND cd_conta_credito::text <> '');

if (vl_total_debito_w <> vl_total_credito_w)   then

    ds_erro_w :=    wheb_mensagem_pck.get_texto(280940) ||
                    wheb_mensagem_pck.get_texto(280941) || vl_total_debito_w  ||
                    wheb_mensagem_pck.get_texto(280942) || vl_total_credito_w || chr(13) || chr(10);

end if;

if (ie_movto_valor_zerado_w = 'S') then

    --Movimento contabil com valor zerado
    update  ctb_movimento
    set     ds_consistencia     = wheb_mensagem_pck.get_texto(280943),
            ie_validacao        = '1'
    where   nr_lote_contabil    = nr_lote_contabil_p
    and     vl_movimento        = 0;
    commit;

end if;

if (ie_movto_valor_negativo_w = 'S') then

    --Movimento contabil com valor negativo
    ds_consistencia_w := wheb_mensagem_pck.get_texto(280944);

    update  ctb_movimento a
    set     a.ds_consistencia = ds_consistencia_w,
            a.ie_validacao        = '2'
    where   a.nr_lote_contabil  = nr_lote_contabil_p
    and     a.vl_movimento      < 0;

    commit;

    update  ctb_movimento a
    set     a.ds_consistencia = ds_consistencia_w,
            a.ie_validacao        = '2'
    where   a.nr_lote_contabil  = nr_lote_contabil_p
    and exists (
        SELECT  1
        from    ctb_movto_centro_custo b
        where   b.nr_seq_movimento  = a.nr_sequencia
        and     a.nr_lote_contabil  = nr_lote_contabil_p
        and     b.vl_movimento < 0);
    commit;

end if;

if (qt_tipo_lote_pl_w > 0) and (dt_referencia_w >=  to_date('01/12/2015','dd/mm/yyyy')) then

    --Informe o campo Mutacao PL pois a conta eh de Patrimonio Liquido
    update  ctb_movimento a
    set     a.ds_consistencia = wheb_mensagem_pck.get_texto(404925),
            a.ie_validacao        = '24'
    where   a.nr_lote_contabil  = nr_lote_contabil_p
    and     coalesce(a.nr_seq_mutacao_pl::text, '') = ''
    and exists (
        SELECT  1
        from    conta_contabil b
        where   a.cd_conta_debito   = b.cd_conta_contabil
        and     b.ie_natureza_sped = '03'

union all

        SELECT  1
        from    conta_contabil b
        where   a.cd_conta_credito  = b.cd_conta_contabil
        and     b.ie_natureza_sped = '03');
    commit;

    if (cd_tipo_lote_contabil_w = 54) then

        begin
        select  1
        into STRICT    qt_mov_lote_pl_w
        from    ctb_movimento a
        where   a.nr_lote_contabil  = nr_lote_contabil_p
        and exists (
            SELECT  1
            from    conta_contabil b
            where   a.cd_conta_debito   = b.cd_conta_contabil
            and     b.ie_natureza_sped = '03'

union all

            SELECT  1
            from    conta_contabil b
            where   a.cd_conta_credito  = b.cd_conta_contabil
            and     b.ie_natureza_sped = '03');
        exception
            when no_data_found then
                qt_mov_lote_pl_w := 0;
            when too_many_rows then
                qt_mov_lote_pl_w := 0;
            when others then
                qt_mov_lote_pl_w := 0;
        end;

        if (qt_mov_lote_pl_w = 0) then

            --Deve existir pelo menos um movimento contabil em uma conta de Patrimonio Liquido neste lote
            update  ctb_movimento a
            set     a.ds_consistencia = wheb_mensagem_pck.get_texto(378102),
                    a.ie_validacao        = '23'
            where   a.nr_lote_contabil  = nr_lote_contabil_p;
            commit;

        end if;

    end if;

end if;

--A conta contabil nao pode ser do tipo "Resultado" quando o lancamento eh extemporaneo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(1059206),
        a.ie_validacao        = '25'
where   a.nr_lote_contabil  = nr_lote_contabil_p
and     (a.dt_lancto_ext IS NOT NULL AND a.dt_lancto_ext::text <> '')
and exists (
    SELECT  1
    from    conta_contabil b,
            ctb_grupo_conta c
    where   c.ie_tipo in ('R','C','D')
    and     c.cd_grupo = b.cd_grupo
    and     b.cd_conta_contabil = a.cd_conta_credito

union all

    SELECT  1
    from    conta_contabil b,
            ctb_grupo_conta c
    where   c.ie_tipo in ('R','C','D')
    and     c.cd_grupo = b.cd_grupo
    and     b.cd_conta_contabil = a.cd_conta_debito);

--Lancamento sem a apropriacao por centro de resultado. Esta conta contabil exige informacao do centro de custo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280945),
        a.ie_validacao        = '3'
where   a.nr_lote_contabil  = nr_lote_contabil_p
and     ie_encerramento_w   = 'N'
and not exists (
    SELECT  1
    from    ctb_movto_centro_custo b
    where   a.nr_sequencia  = b.nr_seq_movimento)
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito   = b.cd_conta_contabil
    and     b.ie_centro_custo   = 'S'

union all

    select  1
    from    conta_contabil b
    where   a.cd_conta_credito  = b.cd_conta_contabil
    and     b.ie_centro_custo   = 'S');
commit;

--Lancamento com a apropriacao indevida por centro de resultado. Esta conta contabil nao requer informacao do centro de custo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280946),
        a.ie_validacao        = '4'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    ctb_movto_centro_custo b
    where   a.nr_sequencia  = b.nr_seq_movimento)
and not exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito   = b.cd_conta_contabil
    and     b.ie_centro_custo   in ('S','O')

union all

    select  1
    from    conta_contabil b
    where   a.cd_conta_credito= b.cd_conta_contabil
    and b.ie_centro_custo   in ('S','O'));
commit;

--Lancamento com valor diferente da somatoria dos centros de custo.
ds_consistencia_w := wheb_mensagem_pck.get_texto(280947);

merge into ctb_movimento x
using(
    SELECT  a.nr_sequencia nr,
            sum(b.vl_movimento) vl
    from    ctb_movimento a,
            ctb_movto_centro_custo b
    where   a.nr_sequencia  = b.nr_seq_movimento
    and     a.nr_lote_contabil = nr_lote_contabil_p
    group by a.nr_sequencia
    having  count(*) > 0
    ) y
on (x.nr_sequencia = y.nr  and  x.vl_movimento <> y.vl)
when matched then
update
set x.ds_consistencia = ds_consistencia_w,
    x.ie_validacao        = '5';
commit;

--Existe diferenca de debito e credito no dia deste movimento.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280970),
        a.ie_validacao        = '6'
where   a.nr_lote_contabil = nr_lote_contabil_p
and     trunc(a.dt_movimento) in (
    SELECT  trunc(b.dt_movimento)
    from    ctb_movimento b
    where   b.nr_lote_contabil = nr_lote_contabil_p
    GROUP BY trunc(b.dt_movimento));
commit;

if (trunc(dt_referencia_w, 'MONTH') >=  trunc(to_date('01/04/2015','dd/mm/yyyy'), 'MONTH') HAVING(sum(CASE WHEN coalesce(b.cd_conta_debito::text, '') = '' THEN 0  ELSE b.vl_movimento END ) <> sum(CASE WHEN coalesce(b.cd_conta_credito::text, '') = '' THEN 0  ELSE b.vl_movimento END ))
    ) then

    --Existem lancamentos com diferenca de debito e credito. Informacao obrigatoria para ECD (SPED Contabil)
    ds_consistencia_w := wheb_mensagem_pck.get_texto(317540);

    update  ctb_movimento z
    set     z.ds_consistencia = ds_consistencia_w,
            z.ie_validacao        = '21'
    where   z.nr_lote_contabil = nr_lote_contabil_p
    and exists (
        SELECT  1
        from (
            SELECT  sum(x.vl_mov_deb) vl_mov_deb,
                    sum(x.vl_mov_cred) vl_mov_cred,
                    x.nr_agrup_sequencial
            from (
                select  sum(a.vl_movimento) vl_mov_deb,
                        0 vl_mov_cred,
                        a.nr_agrup_sequencial
                from    ctb_movimento a
                where   a.nr_lote_contabil = nr_lote_contabil_p
                and     (cd_conta_debito IS NOT NULL AND cd_conta_debito::text <> '')
                group by a.nr_agrup_sequencial

union all

                select  0 vl_mov_deb,
                        sum(a.vl_movimento) vl_mov_cred,
                        a.nr_agrup_sequencial
                from    ctb_movimento a
                where   a.nr_lote_contabil = nr_lote_contabil_p
                and     (cd_conta_credito IS NOT NULL AND cd_conta_credito::text <> '')
                group by a.nr_agrup_sequencial
                ) x
            group by x.nr_agrup_sequencial
            ) w
        where   w.nr_agrup_sequencial = z.nr_agrup_sequencial
        and w.vl_mov_deb <> w.vl_mov_cred);
    commit;

    --Lancamentos sem fato contabil. Informacao obrigatoria para ECD (SPED Contabil).
    update  ctb_movimento a
    set     a.ds_consistencia = wheb_mensagem_pck.get_texto(317536),
            a.ie_validacao        = '20'
    where   nr_lote_contabil = nr_lote_contabil_p
    and     exists (
        SELECT  1
        from    ctb_movimento x
        where   a.nr_sequencia      = x.nr_sequencia
        and     a.nr_lote_contabil  = x.nr_lote_contabil
        and     coalesce(x.nr_seq_agrupamento,0) = 0);

end if;

commit;

--O mes do movimento eh diferente da data de referencia
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280972),
        a.ie_validacao        = '7'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    ctb_mes_ref b
    where   a.nr_seq_mes_ref    = b.nr_sequencia
    and     trunc(a.dt_movimento, 'MONTH') <> trunc(b.dt_referencia, 'MONTH'));
commit;

if (ie_consistir_data_movto_w = 'S') then

    --Dia do movimento eh maior que o dia do lote
    update  ctb_movimento a
    set     a.ds_consistencia       = wheb_mensagem_pck.get_texto(280973),
            a.ie_validacao        = '8'
    where   a.nr_lote_contabil      = nr_lote_contabil_p
    and exists (
        SELECT  1
        from    lote_contabil x
        where   x.nr_lote_contabil  = a.nr_lote_contabil
        and     pkg_date_utils.start_of(x.dt_referencia, 'DD', 0) < pkg_date_utils.start_of(a.dt_movimento, 'DD', 0));
    commit;

end if;

--A conta contabil eh do tipo totalizadora
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280983),
        a.ie_validacao        = '9'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito = b.cd_conta_contabil
    and     b.ie_tipo = 'T'

union

    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_credito = b.cd_conta_contabil
    and     b.ie_tipo = 'T');
commit;

--A conta contabil eh de outro estabelecimento
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280984),
        a.ie_validacao        = '10'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil_estab b
    where   b.cd_conta_contabil = a.cd_conta_debito

union all

    SELECT  1
    from    conta_contabil_estab b
    where   b.cd_conta_contabil = a.cd_conta_credito)
and not exists (
    select  1
    from    conta_contabil_estab c
    where   c.cd_conta_contabil = a.cd_conta_debito
    and     c.cd_estabelecimento    = a.cd_estabelecimento
    
union all

    select  1
    from    conta_contabil_estab c
    where   c.cd_conta_contabil = a.cd_conta_credito
    and     c.cd_estabelecimento    = a.cd_estabelecimento);
commit;

--A conta contabil esta inativa.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280985),
        a.ie_validacao        = '11'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito = b.cd_conta_contabil
    and     b.ie_situacao <> 'A'

union

    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_credito = b.cd_conta_contabil
    and     b.ie_situacao <> 'A');
commit;

--Falta informar o grupo no cadastro da conta.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280986),
        a.ie_validacao        = '12'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito = b.cd_conta_contabil
    and     coalesce(b.cd_grupo::text, '') = ''

union

    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_credito = b.cd_conta_contabil
    and     coalesce(b.cd_grupo::text, '') = '');
commit;

--A conta contabil eh de outra empresa.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280987),
        a.ie_validacao        = '13'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito = b.cd_conta_contabil
    and     b.cd_empresa <> cd_empresa_w

union

    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_credito = b.cd_conta_contabil
    and     b.cd_empresa <> cd_empresa_w);
commit;

--Este historico eh de outra empresa.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280988),
        a.ie_validacao        = '14'
where   a.nr_lote_contabil = nr_lote_contabil_p
and not exists (
    SELECT  1
    from    historico_padrao_empresa_v b
    where   a.cd_historico = b.cd_historico
    and     b.cd_empresa = cd_empresa_w);
commit;

--Este historico esta inativo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280989),
        a.ie_validacao        = '15'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    historico_padrao b
    where   a.cd_historico = b.cd_historico
    and     coalesce(b.ie_situacao,'I') <> 'A');
commit;

--Movimento com centro de resultado totalizador.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280991),
        a.ie_validacao        = '16'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    centro_custo c,
            ctb_movto_centro_custo b
    where   b.nr_seq_movimento  = a.nr_sequencia
    and     b.cd_centro_custo   = c.cd_centro_custo
    and     c.ie_tipo       = 'T');
commit;

--Movimento com centro de resultado inativo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280992),
        a.ie_validacao        = '17'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists(
    SELECT  1
    from    centro_custo c,
            ctb_movto_centro_custo b
    where   b.nr_seq_movimento  = a.nr_sequencia
    and     b.cd_centro_custo   = c.cd_centro_custo
    and     c.ie_situacao       <> 'A'
    and     ie_centro_custo_inativo_w = 'S'
    and     (((c.dt_fim_contabil IS NOT NULL AND c.dt_fim_contabil::text <> '')
    and     c.dt_fim_contabil <= a.dt_movimento)
    or      coalesce(c.dt_fim_contabil::text, '') = ''));
commit;

if (ie_movto_centro_estab_w = 'S') then

    --Movimento com centro de resultado de estabelecimento diferente.
    update  ctb_movimento a
    set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280993),
            a.ie_validacao        = '18'
    where   a.nr_lote_contabil = nr_lote_contabil_p
    and exists (
        SELECT  1
        from    centro_custo c,
                ctb_movto_centro_custo b
        where   b.nr_seq_movimento  = a.nr_sequencia
        and     b.cd_centro_custo   = c.cd_centro_custo
        and     c.cd_estabelecimento    <> cd_estabelecimento_w);
    commit;

end if;

if (ie_encerramento_w = 'N' and (trunc(dt_referencia_w, 'MONTH') >= to_date('01/01/2019','dd/mm/yyyy'))) then

    update  ctb_movimento a
    set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280993),
            a.ie_validacao        = '18'
    where   a.nr_lote_contabil = nr_lote_contabil_p
    and exists (
        SELECT  1
        from    centro_custo c,
                ctb_movto_centro_custo b
        where   b.nr_seq_movimento  = a.nr_sequencia
        and     b.cd_centro_custo   = c.cd_centro_custo
        and     c.cd_estabelecimento    <> a.cd_estabelecimento);
    commit;

end if;

/* Movimento com centro de resultado de estabelecimento diferente. */


/*
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(280993),
        a.ie_validacao        = '18'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists(
    select  1
    from    centro_custo c,
            ctb_movto_centro_custo b
    where   b.nr_seq_movimento  = a.nr_sequencia
    and     b.cd_centro_custo   = c.cd_centro_custo
    and     c.cd_estabelecimento    <> a.cd_estabelecimento);
commit;
*/


--Centro de custo nao permitido, pertence a outra empresa.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(351249),
        a.ie_validacao        = '22'
where   a.nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    estabelecimento b,
            centro_custo c,
            ctb_movto_centro_custo d,
            empresa e
    where   d.nr_seq_movimento = a.nr_sequencia
    and     c.cd_estabelecimento = b.cd_estabelecimento
    and     b.cd_empresa = e.cd_empresa
    and     d.cd_centro_custo = c.cd_centro_custo
    and     e.cd_empresa <> cd_empresa_w);
commit;

if (ie_consiste_movto_pendente_w = 'S') and (ie_consiste_revisao_w = 'S') then

    --Movimento pendente para revisao.
    update  ctb_movimento
    set     ds_consistencia = wheb_mensagem_pck.get_texto(280994),
            ie_validacao        = '19'
    where   nr_lote_contabil = nr_lote_contabil_p
    and     ie_revisado <> 'S';
    commit;

end if;

if (cd_tipo_lote_contabil_w = 60 and  ie_plano_conta_ifrs_w = 'S') then
  -- Movimento contabil nao possui dados contabeis de IFRS
  ds_consistencia_w := wheb_mensagem_pck.get_texto(1214272);
  update ctb_movimento a
  set a.ds_consistencia = ds_consistencia_w ,
  a.ie_validacao = '32'
  where a.nr_lote_contabil  = nr_lote_contabil_p
   and
    exists (
    SELECT 1
    from conta_contabil b
    where b.cd_conta_contabil = a.cd_conta_debito
    and b.ie_exige_ifrs_lanc = 'S'

union all

     SELECT 1
     from conta_contabil b
    where b.cd_conta_contabil = a.cd_conta_credito
    and b.ie_exige_ifrs_lanc = 'S')
   and not EXISTS (
   select 1
    from CTB_MOVTO_IFRS mv
    where mv.nr_seq_ctb_movto = a.nr_sequencia );

    -- A conta do movimento contabil IFRS esta fora da data de vigencia
    ds_consistencia_w := wheb_mensagem_pck.get_texto(1214462);

    update ctb_movimento a
    set a.ds_consistencia = ds_consistencia_w ,
    a.ie_validacao = '33'
    where a.nr_lote_contabil  = nr_lote_contabil_p
    and
     exists (
                SELECT 1
                from    conta_contabil_ifrs c,
                        ctb_plano_conta_ifrs p,
                        ctb_movto_ifrs d
                where d.nr_seq_ctb_movto = a.nr_sequencia
                and d.nr_seq_conta_debito = c.nr_seq_conta_ifrs
                and c.cd_conta_contabil = a.cd_conta_debito
                and p.nr_sequencia = c.nr_seq_conta_ifrs
                and obter_se_periodo_vigente(p.dt_inicio_vigencia, p.dt_fim_vigencia, dt_referencia_w) = 'N'
                
union all

                SELECT 1
                from    conta_contabil_ifrs c,
                        ctb_plano_conta_ifrs p,
                        ctb_movto_ifrs d
                where d.nr_seq_ctb_movto = a.nr_sequencia
                and d.nr_seq_conta_credito = c.nr_seq_conta_ifrs
                and c.cd_conta_contabil = a.cd_conta_credito
                and p.nr_sequencia = c.nr_seq_conta_ifrs
                and obter_se_periodo_vigente(p.dt_inicio_vigencia, p.dt_fim_vigencia, dt_referencia_w) = 'N');
   commit;
end if;

--Estabelecimento do movimento inativo.
update  ctb_movimento a
set     a.ds_consistencia = wheb_mensagem_pck.get_texto(1076393),
        a.ie_validacao        = '26'
where   nr_lote_contabil = nr_lote_contabil_p
and exists (
    SELECT  1
    from    estabelecimento b
    where   a.cd_estabelecimento = b.cd_estabelecimento
    and     coalesce(b.ie_situacao,'A') = 'I');
commit;

select  coalesce(max(ds_consistencia), 'X')
into STRICT    ds_erro_movto_w
from    ctb_movimento
where   nr_lote_contabil = nr_lote_contabil_p;

if (ds_erro_movto_w  <> 'X') then
    ds_erro_w   := substr(ds_erro_movto_w, 1, 255);
end if;

/* Identifica contas lancadas fora da data de vigencia*/

ds_erro_ww := consiste_contas_vigencia_lote(nr_lote_contabil_p, ds_erro_ww);

if (coalesce(ds_erro_ww,'X') = 'X') then
    ds_erro_ww := ctb_consistir_classif_lote(nr_lote_contabil_p, nm_usuario_p, ds_erro_ww);
end if;

if (ds_erro_ww IS NOT NULL AND ds_erro_ww::text <> '') then
    ds_erro_w := substr(ds_erro_w || ' - ' || ds_erro_ww,1,2000);
end if;

ds_log_lote_w   := substr(wheb_mensagem_pck.get_texto(280996) || campo_mascara_virgula(vl_total_debito_w) || wheb_mensagem_pck.get_texto(280995) || campo_mascara_virgula(vl_total_credito_w),1,2000);

if (coalesce(ds_erro_w::text, '') = '') then

    update lote_contabil
    set     dt_consistencia     = clock_timestamp(),
            vl_debito       = vl_total_debito_w,
            vl_credito      = vl_total_credito_w
    where   nr_lote_contabil    = nr_lote_contabil_p;

    ds_log_lote_w := substr(wheb_mensagem_pck.get_texto(280997) || campo_mascara_virgula(vl_total_debito_w) || wheb_mensagem_pck.get_texto(280995) || campo_mascara_virgula(vl_total_credito_w),1,2000);
    commit;

end if;

CALL ctb_gravar_log_lote(nr_lote_contabil_p, 4, ds_log_lote_w,nm_usuario_p);

CALL philips_contabil_pck.set_ie_consistindo_lote('N');

exception
    when program_error then
        CALL philips_contabil_pck.set_ie_consistindo_lote('N');
        ds_exception_w := substr(sqlerrm,1,1000);
        CALL wheb_mensagem_pck.exibir_mensagem_abort(448772,'DS_ERRO='||ds_exception_w);
    when others then
        CALL philips_contabil_pck.set_ie_consistindo_lote('N');
        ds_exception_w := substr(sqlerrm,1,1000);
        CALL wheb_mensagem_pck.exibir_mensagem_abort(448772,'DS_ERRO='||ds_exception_w);
end;

ds_erro_p   := substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_consistir_lote ( nr_lote_contabil_p ctb_movimento.nr_lote_contabil%type, ds_erro_p INOUT text, nm_usuario_p ctb_movimento.nm_usuario%type) FROM PUBLIC;

