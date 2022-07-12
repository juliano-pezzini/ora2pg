-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_classif_afatual ON titulo_pagar_classif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_classif_afatual() RETURNS trigger AS $BODY$
declare

cd_estabelecimento_w                    bigint;
ie_empenho_orcamento_w                  varchar(1);
nr_titulo_w                             bigint;
vl_movimento_w                          ctb_documento.vl_movimento%type;
dt_documento_w                          ctb_documento.dt_competencia%type;
qt_reg_w                                bigint;
reg_integracao_w                        gerar_int_padrao.reg_integracao;
nr_seq_trans_fin_contab_w		titulo_pagar.nr_seq_trans_fin_contab%type;

c01 CURSOR FOR
SELECT  a.nm_atributo,
        a.cd_tipo_lote_contab
from    atributo_contab a
where   a.cd_tipo_lote_contab = 7
and     a.nm_atributo in ( 'VL_TIT_LIQ_IMP', 'VL_TITULO');

c01_w   c01%rowtype;

--pragma autonomous_transaction;

BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	BEGIN
	nr_titulo_w     := coalesce(NEW.nr_titulo, OLD.nr_titulo);

	select  max(cd_estabelecimento),
		max(dt_contabil),
		max(nr_seq_trans_fin_contab)
	into STRICT    cd_estabelecimento_w,
		dt_documento_w,
		nr_seq_trans_fin_contab_w
	from    titulo_pagar
	where   nr_titulo       = nr_titulo_w;

	select  coalesce(max(ie_empenho_orcamento),'N')
	into STRICT    ie_empenho_orcamento_w
	from    parametro_estoque
	where   cd_estabelecimento      = cd_estabelecimento_w;

	if (ie_empenho_orcamento_w = 'S') then
		if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') then
			CALL gerar_empenho_tit_pagar2(NEW.nr_titulo,NEW.cd_centro_custo, NEW.cd_conta_contabil,NEW.vl_titulo,NEW.nm_usuario,1);
		else
			CALL gerar_empenho_tit_pagar2(OLD.nr_titulo,OLD.cd_centro_custo, OLD.cd_conta_contabil,OLD.vl_titulo,OLD.nm_usuario,2);
		end if;
	end if;
	exception when others then
		null;
		/*ds_erro_w     := substr(sqlerrm(sqlcode),1,2000);
		insert into logxxxxxxx_asy(
			cd_log,
			ds_log,
			nm_usuario,
			dt_atualizacao)
		values( 9919,
			substr('Titulo: ' || nr_titulo_w || ' ' || ds_erro_w,1,2000),
			nvl(:new.nm_usuario, :old.nm_usuario),
			sysdate);*/

	end;
/*OS 1430325 - Envio de classificacao de titulos a pagar*/


if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') then
        select  count(*)
        into STRICT    qt_reg_w
        from    intpd_fila_transmissao
        where   nr_seq_documento        = to_char(NEW.nr_titulo)
        and     to_char(dt_atualizacao, 'dd/mm/yyyy hh24:mi:ss') = to_char(LOCALTIMESTAMP,'dd/mm/yyyy hh24:mi:ss')
        and     ie_evento in ('53');

        if (qt_reg_w = 0) then
		select  max(cd_estabelecimento),
			max(ie_tipo_titulo)
			into STRICT reg_integracao_w.cd_estab_documento,
			     reg_integracao_w.ie_tipo_titulo_cpa
			from titulo_pagar
			where nr_titulo = NEW.nr_titulo;
                reg_integracao_w := gerar_int_padrao.gravar_integracao('53', NEW.nr_titulo, NEW.nm_usuario, reg_integracao_w);
        end if;
end if;

if (TG_OP = 'INSERT') then
        /* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


        CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,null,'TP',NEW.dt_atualizacao,'I',NEW.nm_usuario);
elsif (TG_OP = 'UPDATE') then
        /* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


        CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,null,'TP',NEW.dt_atualizacao,'A',NEW.nm_usuario);
elsif (TG_OP = 'DELETE') then
        /* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


        CALL gravar_agend_fluxo_caixa(OLD.nr_titulo,null,'TP',OLD.dt_atualizacao,'E',OLD.nm_usuario);
end if;

if (TG_OP = 'INSERT') then
        open c01;
        loop
        fetch c01 into
                c01_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
                BEGIN

                if (c01_w.nm_atributo = 'VL_TIT_LIQ_IMP') then
                        select  coalesce(CASE WHEN coalesce(NEW.vl_original,0)=0 THEN  null  ELSE NEW.vl_original END , NEW.vl_titulo)
                        into STRICT    vl_movimento_w
;

                elsif (c01_w.nm_atributo = 'VL_TITULO') then
                        vl_movimento_w  := NEW.vl_titulo;

                end if;

                if (coalesce(vl_movimento_w, 0) <> 0) then
                        BEGIN

                        CALL ctb_concil_financeira_pck.ctb_gravar_documento( cd_estabelecimento_w,
                                                                        dt_documento_w,
                                                                        c01_w.cd_tipo_lote_contab,
                                                                        coalesce(NEW.nr_seq_trans_fin,nr_seq_trans_fin_contab_w),
                                                                        2,
                                                                        NEW.nr_titulo,
                                                                        NEW.nr_sequencia,
                                                                        null,
                                                                        vl_movimento_w,
                                                                        'TITULO_PAGAR_CLASSIF',
                                                                        c01_w.nm_atributo,
                                                                        NEW.nm_usuario);
                        end;
                end if;

                end;
        end loop;
        close c01;
elsif (TG_OP = 'UPDATE') then
    update ctb_documento a
    set a.vl_movimento = NEW.vl_titulo,
        a.nr_seq_trans_financ = nr_seq_trans_fin_contab_w,
        a.nm_usuario = NEW.nm_usuario,
        a.dt_atualizacao = LOCALTIMESTAMP
    where a.nr_documento = NEW.nr_titulo
    and a.nr_seq_doc_compl = NEW.nr_sequencia
    and a.nr_doc_analitico is null
    and a.cd_tipo_lote_contabil = 7
    and a.nm_tabela = 'TITULO_PAGAR_CLASSIF'
    and a.nm_atributo = 'VL_TITULO';

    select  coalesce(CASE WHEN coalesce(NEW.vl_original,0)=0 THEN  null  ELSE NEW.vl_original END , NEW.vl_titulo)
    into STRICT    vl_movimento_w
;

    update ctb_documento a
    set a.vl_movimento = vl_movimento_w,
        a.nr_seq_trans_financ = nr_seq_trans_fin_contab_w,
        a.nm_usuario = NEW.nm_usuario,
        a.dt_atualizacao = LOCALTIMESTAMP
    where a.nr_documento = NEW.nr_titulo
    and a.nr_seq_doc_compl = NEW.nr_sequencia
    and a.nr_doc_analitico is null
    and a.cd_tipo_lote_contabil = 7
    and a.nm_tabela = 'TITULO_PAGAR_CLASSIF'
    and a.nm_atributo = 'VL_TIT_LIQ_IMP';
end if;
end if;

  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_classif_afatual() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_classif_afatual
	AFTER INSERT OR UPDATE OR DELETE ON titulo_pagar_classif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_classif_afatual();

