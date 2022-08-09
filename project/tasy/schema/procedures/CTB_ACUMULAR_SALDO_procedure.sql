-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_acumular_saldo ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_estabelecimento_w		integer;
cd_conta_contabil_w		varchar(40);
cd_classificacao_w			varchar(40);
cd_classif_w			varchar(40);
cd_empresa_w			integer;
vl_debito_w			double precision;
vl_credito_w			double precision;
vl_movimento_w			double precision;
vl_encerramento_w			double precision;
vl_saldo_w			double precision;
nr_sequencia_w			bigint;
qt_vigente_w			bigint;
k				integer;
ie_deb_cre_w			varchar(01);
ie_deb_cre_ww			varchar(01);
ie_tipo_w				varchar(01);
vl_saldo_ww			double precision;
vl_saldo_erro_ww			double precision;
ds_erro_w			varchar(2000);
ie_compensacao_w			varchar(01);
dt_referencia_w		timestamp;
ds_erro_ww			varchar(600);
vl_enc_debito_w			double precision;
vl_enc_credito_w		double precision;
cd_classif_ww			varchar(40);
cd_classif_sup_w		varchar(40);
qt_regra_classif_w		bigint;
nr_nivel_conta_w		bigint;
ds_consiste_w			varchar(4000);
vl_eliminacao_w			ctb_saldo.vl_eliminacao%type;
ie_excecao_interna_w    boolean	:= false;

C01 CURSOR FOR
SELECT	a.cd_estabelecimento,
	a.cd_classificacao,
	a.cd_classif_sup,
	sum(vl_debito),
	sum(vl_credito),
	sum(vl_movimento),
	sum(vl_encerramento),
	coalesce(sum(vl_enc_debito),0),
	coalesce(sum(vl_enc_credito),0),
	sum(vl_saldo),
	c.ie_debito_credito,
	b.ie_tipo,
	coalesce(ie_compensacao,'N'),
	coalesce(sum(a.vl_eliminacao),0)
from	ctb_grupo_conta c,
	conta_contabil b,
	ctb_saldo a
where	substr(obter_se_conta_vigente2(b.cd_conta_contabil, b.dt_inicio_vigencia, b.dt_fim_vigencia,dt_referencia_w),1,1) = 'S'
and	a.cd_estabelecimento	= coalesce(cd_estabelecimento_p, a.cd_estabelecimento)
and	a.cd_conta_contabil	= b.cd_conta_contabil
and	b.cd_grupo		= c.cd_grupo
and	K			< 20
and	a.nr_nivel_conta 	= k
and	(a.cd_classif_sup IS NOT NULL AND a.cd_classif_sup::text <> '')
and	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
group by
	a.cd_estabelecimento,
	a.cd_classificacao,
	a.cd_classif_sup,
	c.ie_debito_credito,
	b.ie_tipo,
	coalesce(ie_compensacao,'N');


BEGIN

select	cd_empresa,
	dt_referencia
into STRICT	cd_empresa_w,
	dt_referencia_w
from	ctb_mes_ref
where	nr_sequencia	= nr_seq_mes_ref_p;

select	coalesce(max(1),0)
into STRICT	qt_regra_classif_w

where exists (	SELECT	1
		from	conta_contabil_classif);

delete	from ctb_saldo
where	nr_seq_mes_ref	= nr_seq_mes_ref_p
and	cd_estabelecimento	= coalesce(cd_estabelecimento_p, cd_estabelecimento)
and	cd_conta_contabil in (
	SELECT	cd_conta_contabil
	from	conta_contabil
	where	ie_tipo	= 'T');

k				:= 20;
begin
    while k > 0 loop
        open C01;
        loop
        fetch C01 into
            cd_estabelecimento_w,
            cd_classif_w,
            cd_classificacao_w,
            vl_debito_w,
            vl_credito_w,
            vl_movimento_w,
            vl_encerramento_w,
            vl_enc_debito_w,
            vl_enc_credito_w,
            vl_saldo_w,
            ie_deb_cre_w,
            ie_tipo_w,
            ie_compensacao_w,
            vl_eliminacao_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
            begin

            cd_conta_contabil_w	:= null;
            qt_vigente_w		:= 0;

        /*	select	count(*)
            into	qt_vigente_w
            from	conta_contabil
            where 	substr(ctb_obter_classif_conta(cd_conta_contabil, cd_classificacao, dt_referencia_w),1,40)	= cd_classificacao_w
            and	cd_empresa		= cd_empresa_w
            and	(substr(obter_se_conta_vigente(cd_conta_contabil, dt_referencia_w),1,1) = 'S');*/
            if (qt_regra_classif_w > 0) then

                select	min(a.cd_conta_contabil)
                into STRICT	cd_conta_contabil_w
                from	conta_contabil b,
                    conta_contabil_classif a
                where	a.cd_conta_contabil	= b.cd_conta_contabil
                and	b.cd_empresa		= cd_empresa_w
                and	a.dt_inicio_vigencia   <= dt_referencia_w
                and	coalesce(a.dt_fim_vigencia, dt_referencia_w) >= dt_referencia_w
                and	substr(obter_se_conta_vigente2(a.cd_conta_contabil, b.dt_inicio_vigencia, b.dt_fim_vigencia, dt_referencia_w),1,1) = 'S'
                and	a.cd_classificacao	= cd_classificacao_w;

                if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then
                    qt_vigente_w	:= 1;
                end if;
            end if;


            if (coalesce(cd_conta_contabil_w,'X') = 'X') then

                select	count(*)
                into STRICT	qt_vigente_w
                from	conta_contabil
                where 	cd_classificacao	= cd_classificacao_w
                and	cd_empresa		= cd_empresa_w
                and (substr(obter_se_conta_vigente2(cd_conta_contabil, dt_inicio_vigencia, dt_fim_vigencia, dt_referencia_w),1,1) = 'S');

                select	min(cd_conta_contabil)
                into STRICT	cd_conta_contabil_w
                from	conta_contabil a
                where 	cd_classificacao	= cd_classificacao_w
                and	cd_empresa		= cd_empresa_w
                and	substr(obter_se_conta_vigente2( a.cd_conta_contabil, a.dt_inicio_vigencia, a.dt_fim_vigencia, dt_referencia_w),1,1) = 'S';


            end if;


            if (qt_vigente_w = 0) then /*Coloquei esta consistencia, nos casos de que a conta nao esta na troca e virou o mes*/
                ds_erro_w		:= WHEB_MENSAGEM_PCK.get_texto(277963) || cd_classif_w ||  '/' || chr(13) || chr(10) || cd_classificacao_w || WHEB_MENSAGEM_PCK.get_texto(277964);
                k			:= -1;
            elsif (coalesce(cd_conta_contabil_w::text, '') = '') then
                ds_erro_w		:= WHEB_MENSAGEM_PCK.get_texto(277965) || cd_classif_w || chr(13) ||
                            WHEB_MENSAGEM_PCK.get_texto(277966) || cd_classificacao_w || chr(13) ||
                            WHEB_MENSAGEM_PCK.get_texto(277967) || dt_referencia_w;
                k			:= -1;
            else
                begin

                if (ie_compensacao_w = 'S') and (k			= 2) then
                    vl_debito_w		:= 0;
                    vl_credito_w		:= 0;
                    vl_movimento_w	:= 0;
                    vl_encerramento_w	:= 0;
                    vl_saldo_w		:= 0;
                    vl_enc_debito_w		:= 0;
                    vl_enc_credito_w	:= 0;
                    vl_eliminacao_w		:= 0;
                end if;

                select	max(ie_debito_credito)
                into STRICT	ie_deb_cre_ww
                from	ctb_grupo_conta b,
                    conta_contabil a
                where	a.cd_conta_contabil	= cd_conta_contabil_w
                and	a.cd_grupo		= b.cd_grupo;
                select	nextval('ctb_saldo_seq')
                into STRICT	nr_sequencia_w
;
                if (ie_deb_cre_w <> ie_deb_cre_ww) then
                    vl_saldo_w		:= vl_saldo_w * -1;
                    vl_movimento_w	:= vl_movimento_w * -1;
                    vl_encerramento_w	:= vl_encerramento_w * -1;
                end if;

                cd_classificacao_w	:= substr(ctb_obter_classif_conta(cd_conta_contabil_w, cd_classificacao_w, dt_referencia_w),1,40);
                cd_classif_sup_w	:= substr(ctb_obter_classif_conta_sup(cd_classificacao_w, dt_referencia_w, cd_empresa_w),1,40);
                nr_nivel_conta_w	:= ctb_obter_nivel_classif_conta(cd_classificacao_w);

                begin
                insert into ctb_saldo(
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
                    vl_encerramento,
                    vl_enc_debito,
                    vl_enc_credito,
                    cd_classificacao,
                    cd_classif_sup,
                    nr_nivel_conta,
                    vl_eliminacao)
                values (	nr_sequencia_w,
                    nr_seq_mes_ref_p,
                    clock_timestamp(),
                    nm_usuario_p,
                    cd_estabelecimento_w,
                    cd_conta_contabil_w,
                    vl_debito_w,
                    vl_credito_w,
                    vl_saldo_w,
                    vl_movimento_w,
                    vl_encerramento_w,
                    vl_enc_debito_w,
                    vl_enc_credito_w,
                    cd_classificacao_w,
                    cd_classif_sup_w,
                    nr_nivel_conta_w,
                    vl_eliminacao_w);
                exception when unique_violation then
                        if (ie_tipo_w ='A') then
                            vl_saldo_ww	:= vl_saldo_w;
                        else
                            vl_saldo_ww	:= vl_movimento_w;
                        end if;

                        vl_saldo_ww		:= vl_saldo_w;
                        select	sum(vl_saldo)
                        into STRICT	vl_saldo_erro_ww
                        from	ctb_saldo
                        where	cd_estabelecimento	= cd_estabelecimento_w
                        and	nr_seq_mes_ref	= nr_seq_mes_ref_p
                        and	cd_conta_contabil	= cd_conta_contabil_w;

                        begin
                        update ctb_saldo
                        set	vl_debito		= vl_debito + vl_debito_w,
                            vl_credito 	= vl_credito + vl_credito_w,
                            vl_movimento	= vl_movimento + vl_movimento_w,
                            vl_encerramento	= vl_encerramento + vl_encerramento_w,
                            vl_saldo		= vl_saldo + vl_saldo_ww,
                            vl_enc_debito	= vl_enc_debito + vl_enc_debito_w,
                            vl_enc_credito	= vl_enc_credito + vl_enc_credito_w,
                            cd_classificacao = cd_classificacao_w,
                            cd_classif_sup	= cd_classif_sup_w,
                            nr_nivel_conta	= nr_nivel_conta_w,
                            vl_eliminacao	= coalesce(vl_eliminacao,0) + vl_eliminacao_w
                        where	cd_estabelecimento	= cd_estabelecimento_w
                        and	nr_seq_mes_ref	= nr_seq_mes_ref_p
                        and	cd_conta_contabil	= cd_conta_contabil_w;
                        exception when others then
                            ie_excecao_interna_w := true;
                            ds_erro_ww	:= sqlerrm(SQLSTATE);
                            ds_consiste_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(277969) || chr(13) ||
                            WHEB_MENSAGEM_PCK.get_texto(277970) || cd_conta_contabil_w || WHEB_MENSAGEM_PCK.get_texto(277971) || nr_seq_mes_ref_p || chr(13) ||
                            WHEB_MENSAGEM_PCK.get_texto(277972) || vl_saldo_erro_ww || WHEB_MENSAGEM_PCK.get_texto(277973) ||  vl_saldo_ww || chr(13) || ds_erro_ww,1,4000);
                            CALL wheb_mensagem_pck.exibir_mensagem_abort(184609,'DS_ERRO_W=' || ds_consiste_w);
                        end;
                end;
                end;
            end if;
            end;
        end loop;
        close C01;
        commit;
        K	:= K - 1;
    end loop;
exception when others then
    if (ie_excecao_interna_w) then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(184609,'DS_ERRO_W=' || ds_consiste_w);
    else
        ds_erro_ww	:= substr(sqlerrm(SQLSTATE), 1, 600);
        CALL wheb_mensagem_pck.exibir_mensagem_abort(1118983, 'DS_ERRO_W=' || ds_erro_ww);
    end if;
end;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_acumular_saldo ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
