-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_afterinsert ON titulo_pagar CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_afterinsert() RETURNS trigger AS $BODY$
declare

vl_movimento_w		ctb_documento.vl_movimento%type;
dt_documento_w		ctb_documento.dt_atualizacao%type;
ie_contab_curto_prazo_w parametros_contas_pagar.ie_contab_curto_prazo%type;
nr_seq_trans_financ_w	ctb_documento.nr_seq_trans_financ%type;
qt_reg_w		bigint;
reg_integracao_w	gerar_int_padrao.reg_integracao;
ie_situacao_ctb_w	ctb_documento.ie_situacao_ctb%type  := 'P';
nr_seq_info_ctb_w	ctb_documento.nr_seq_info%type;
ie_concil_contab_w	pls_visible_false.ie_concil_contab%type;
ie_contab_classif_w ctb_param_lote_contas_pag.ie_contab_classif%type;

c01 CURSOR FOR
	SELECT	a.nm_atributo,
		7 cd_tipo_lote_contab
	from	atributo_contab a
	where 	a.cd_tipo_lote_contab = 7
	and 	a.nm_atributo in ( 'VL_TITULO', 'VL_CURTO_PRAZO', 'VL_LONGO_PRAZO')
	
union all

	SELECT	a.nm_atributo,
		37 cd_tipo_lote_contab
	from	atributo_contab a
	where	a.cd_tipo_lote_contab = 37
	and	a.nm_atributo = 'VL_TITULO_PAGAR'
	and	NEW.ie_origem_titulo = '19'
	and	ie_concil_contab_w = 'S'
	and	((NEW.nr_seq_pls_lote_contest is not null) or (NEW.nr_seq_pls_lote_disc is not null))
	and	NEW.ie_situacao <> 'C';
c01_w		c01%rowtype;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
BEGIN
select  coalesce(ie_contab_curto_prazo, 'N')
into STRICT    ie_contab_curto_prazo_w
from    parametros_contas_pagar
where   cd_estabelecimento = NEW.cd_estabelecimento;
exception when others then
ie_contab_curto_prazo_w := 'N';
end;

BEGIN
select	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from	pls_visible_false
where	cd_estabelecimento = NEW.cd_estabelecimento;
exception when others then
	ie_concil_contab_w := 'N';
end;

BEGIN
select  x.ie_contab_curto_prazo, x.ie_contab_classif
into STRICT    ie_contab_curto_prazo_w, ie_contab_classif_w
from (
    SELECT  CASE WHEN a.ie_ctb_online='S' THEN  coalesce(a.ie_contab_curto_prazo, 'N')  ELSE 'N' END  ie_contab_curto_prazo,
    		a.ie_contab_classif
    from    ctb_param_lote_contas_pag a
    where   a.cd_empresa = obter_empresa_estab(NEW.cd_estabelecimento)
    and     coalesce(a.cd_estab_exclusivo, NEW.cd_estabelecimento) = NEW.cd_estabelecimento
    order by(coalesce(a.cd_estab_exclusivo,0)) desc ) x LIMIT 1;
exception
    when no_data_found then
        ie_contab_curto_prazo_w := 'N';
        ie_contab_classif_w := 'N';
    when others then
        ie_contab_curto_prazo_w := 'N';
        ie_contab_classif_w := 'N';
end;


    if (TG_OP = 'INSERT') then
    BEGIN

        /*OS 1430325 - Envio de titulos a pagar*/


        select  count(*)
        into STRICT    qt_reg_w
        from    intpd_fila_transmissao
        where   nr_seq_documento                = to_char(NEW.nr_titulo)
        and     to_char(dt_atualizacao, 'dd/mm/yyyy hh24:mi:ss') = to_char(LOCALTIMESTAMP,'dd/mm/yyyy hh24:mi:ss')
        and	ie_evento in ('53');

        if (qt_reg_w = 0) then
		reg_integracao_w.cd_estab_documento    := NEW.cd_estabelecimento;
		reg_integracao_w.ie_tipo_titulo_cpa    := NEW.ie_tipo_titulo;
            	reg_integracao_w := gerar_int_padrao.gravar_integracao('53', NEW.nr_titulo, NEW.nm_usuario, reg_integracao_w);
        end if;

        /* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


        CALL gravar_agend_fluxo_caixa(NEW.nr_titulo,null,'TP',coalesce(NEW.dt_vencimento_atual,NEW.dt_vencimento_original),'I',NEW.nm_usuario);

        if (coalesce(NEW.nr_repasse_terceiro, 0) = 0) then
        BEGIN
            open c01;
            loop
            fetch c01 into
                c01_w;
            EXIT WHEN NOT FOUND; /* apply on c01 */
           	BEGIN

                vl_movimento_w:= NEW.vl_titulo;
                dt_documento_w:= null;
		if (c01_w.cd_tipo_lote_contab = 7) then
			if (c01_w.nm_atributo = 'VL_TITULO') then
				BEGIN
				dt_documento_w		:= NEW.dt_contabil;
				nr_seq_trans_financ_w	:= NEW.nr_seq_trans_fin_contab;
				end;
			elsif	((c01_w.nm_atributo = 'VL_CURTO_PRAZO') or (c01_w.nm_atributo = 'VL_LONGO_PRAZO')) then
				BEGIN
				vl_movimento_w	:= null;
				if (ie_contab_curto_prazo_w = 'S') then
					BEGIN
					dt_documento_w:= NEW.dt_contabil;
					if (c01_w.nm_atributo = 'VL_CURTO_PRAZO') then
						BEGIN
						dt_documento_w:= pkg_date_utils.add_month(NEW.dt_vencimento_atual,-12,0);
						end;
					end if;

					if (pkg_date_utils.add_month(NEW.dt_vencimento_atual,-12,0) >= NEW.dt_contabil) and (c01_w.nm_atributo = 'VL_CURTO_PRAZO')
						or (NEW.dt_vencimento_atual > pkg_date_utils.add_month(NEW.dt_contabil,12,0)) and (c01_w.nm_atributo = 'VL_LONGO_PRAZO') then
						BEGIN
						if (coalesce(NEW.nr_seq_tf_curto_prazo, 0) <> 0) then
							BEGIN
							nr_seq_trans_financ_w	:= NEW.nr_seq_tf_curto_prazo;
							vl_movimento_w		:= NEW.vl_titulo;
							end;
						end if;
						end;
					end if;
					end;
				end if;
				end;
			end if;
		elsif (c01_w.cd_tipo_lote_contab = 37) then
			vl_movimento_w		:= NEW.vl_titulo;
			dt_documento_w		:= NEW.dt_contabil;
			nr_seq_trans_financ_w	:= NEW.nr_seq_trans_fin_contab;
			nr_seq_info_ctb_w	:= case c01_w.nm_atributo
						   when 'VL_RECEBIDO' then 14
						   when 'VL_REC_GLOSA' then 14
						   when	'VL_PAGO' then 13
						   when 'VL_PAG_GLOSA' then 13
						   when 'VL_TITULO_RECEBER' then 46
						   when 'VL_TITULO_PAGAR' then 47
						   when 'VL_REC_MAIOR'	then 14
						   end;

			CALL ctb_concil_financeira_pck.ctb_gravar_documento(  	NEW.cd_estabelecimento,
										dt_documento_w,
										37,
										nr_seq_trans_financ_w,
										nr_seq_info_ctb_w,
										NEW.nr_titulo,
										null,
										null,
										vl_movimento_w,
										'TITULO_PAGAR',
										c01_w.nm_atributo,
										NEW.nm_usuario,
                                        'P',
                                        null,
                                        NEW.nr_seq_proj_rec);
		end if;

		if (coalesce(vl_movimento_w, 0) <> 0 and c01_w.cd_tipo_lote_contab <> 37) then
			select 	CASE WHEN ie_contab_classif_w='S' THEN  'N'  ELSE 'P' END
			into STRICT 	ie_situacao_ctb_w
			;

			if (ie_situacao_ctb_w = 'P') and (NEW.nr_seq_trans_fin_contab is not null) and (c01_w.nm_atributo  = 'VL_TITULO') then

				select  CASE WHEN count(a.nr_sequencia)=0 THEN 'P'  ELSE 'N' END
				into STRICT  ie_situacao_ctb_w
				from  trans_financ_contab a
				where  a.nr_seq_trans_financ  = NEW.nr_seq_trans_fin_contab
				and  a.ie_regra_conta  = 'INF'
				and  a.nm_atributo    = c01_w.nm_atributo;

				if (ie_situacao_ctb_w = 'P') then
					select  CASE WHEN count(a.nr_sequencia)=0 THEN 'P'  ELSE 'N' END
					into STRICT  	ie_situacao_ctb_w
					from  	trans_financ_contab a
					where  	a.nr_seq_trans_financ  = NEW.nr_seq_trans_fin_contab
					and  	a.nm_atributo    = c01_w.nm_atributo
					and (a.ie_regra_centro_custo  = 'INF' or (a.ie_regra_centro_custo  = 'IF' and a.cd_centro_custo is not null)
					);
				end if;

			end if;

			CALL ctb_concil_financeira_pck.ctb_gravar_documento(  	NEW.cd_estabelecimento,
										dt_documento_w,
										7,
										nr_seq_trans_financ_w,
										2,
										NEW.nr_titulo,
										null,
										null,
										vl_movimento_w,
										'TITULO_PAGAR',
										c01_w.nm_atributo,
										NEW.nm_usuario,
										ie_situacao_ctb_w,
										null,
                                        NEW.nr_seq_proj_rec);
		end if;
		end;
	end loop;
	close c01;
        end;
        end if;
    end;
    end if;

    if (TG_OP = 'UPDATE') then
        BEGIN
	ie_situacao_ctb_w  := 'P';
	if (NEW.nr_seq_trans_fin_contab is not null) and (coalesce(NEW.nr_seq_trans_fin_contab,0) != coalesce(OLD.nr_seq_trans_fin_contab,0)) then
		select  CASE WHEN count(a.nr_sequencia)=0 THEN 'P'  ELSE 'N' END
		into STRICT  ie_situacao_ctb_w
		from  trans_financ_contab a
		where  a.nr_seq_trans_financ  = NEW.nr_seq_trans_fin_contab
		and  a.ie_regra_conta  = 'INF'
		and  a.nm_atributo    = 'VL_TITULO';

		if (ie_situacao_ctb_w = 'P') then
			BEGIN
			select  CASE WHEN count(a.nr_sequencia)=0 THEN 'P'  ELSE 'N' END
			into STRICT  ie_situacao_ctb_w
			from  trans_financ_contab a
			where  a.nr_seq_trans_financ  = NEW.nr_seq_trans_fin_contab
			and  a.ie_regra_centro_custo  = 'INF'
			and  a.nm_atributo    = 'VL_TITULO';
			end;
		end if;
 	end if;

        update  ctb_documento
        set  	nr_seq_trans_financ   = NEW.nr_seq_trans_fin_contab,
             	ie_situacao_ctb    = CASE WHEN ie_situacao_ctb='P' THEN ie_situacao_ctb_w  ELSE ie_situacao_ctb END ,
                nr_seq_proj_rec = NEW.nr_seq_proj_rec
        where  	nr_documento     = NEW.nr_titulo
        and	coalesce(nr_seq_doc_compl, 0)= 0
        and	nm_tabela     = 'TITULO_PAGAR'
        and 	nm_atributo in ('VL_TITULO')
        and	coalesce(nr_lote_contabil,0)  = 0;

        update	ctb_documento
        set	nr_seq_trans_financ = NEW.nr_seq_tf_curto_prazo,
            nr_seq_proj_rec = NEW.nr_seq_proj_rec
        where	nr_documento = NEW.nr_titulo
        and 	coalesce(nr_seq_doc_compl, 0) = 0
        and	nm_tabela = 'TITULO_PAGAR'
        and 	nm_atributo in ('VL_CURTO_PRAZO', 'VL_LONGO_PRAZO')
  	and	coalesce(nr_lote_contabil,0)	= 0;

        end;
    end if;
end if;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_afterinsert() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_afterinsert
	AFTER INSERT OR UPDATE ON titulo_pagar FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_afterinsert();
