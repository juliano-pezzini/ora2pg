-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_baixa_update ON titulo_pagar_baixa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_baixa_update() RETURNS trigger AS $BODY$
DECLARE

nr_seq_banco_w                  movto_trans_financ.nr_seq_banco%type;
nr_seq_caixa_w                  movto_trans_financ.nr_seq_caixa%type;
qt_tit_rec_w                    bigint;
cd_estabelecimento_w            integer;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
/* Estabelecimento */

select  max(cd_estabelecimento)
into STRICT    cd_estabelecimento_w
from    titulo_pagar
where   nr_titulo       = NEW.nr_titulo;

/* Controle Bancario */

select  max(a.nr_seq_banco)
into STRICT    nr_seq_banco_w
from    movto_trans_financ a
where   a.nr_sequencia  = NEW.nr_seq_movto_trans_fin;

/* tesoraria */

select  max(a.nr_seq_caixa)
into STRICT    nr_seq_caixa_w
from    movto_trans_financ a
where   a.nr_sequencia  = NEW.nr_seq_movto_trans_fin;

/* abatimento */

select  count(*)
into STRICT    qt_tit_rec_w
from    titulo_receber_liq a
where   a.nr_seq_baixa_pagar    = NEW.nr_sequencia
and     a.nr_tit_pagar          = NEW.nr_titulo;

if (coalesce(qt_tit_rec_w,0)    > 0) then
        NEW.ie_origem_baixa := 'AB';

elsif (NEW.nr_bordero is not null) then
        NEW.ie_origem_baixa := 'BP';

elsif (NEW.nr_seq_movto_trans_fin is not null) and (nr_seq_banco_w is not null) then
        NEW.ie_origem_baixa := 'CB';

elsif (NEW.nr_seq_escrit is not null) then
        NEW.ie_origem_baixa := 'PE';

elsif (NEW.nr_seq_baixa_origem is not null) then
        NEW.ie_origem_baixa := 'ET';


elsif (NEW.nr_seq_movto_trans_fin  is not null) and (nr_seq_caixa_w is not null) then
        NEW.ie_origem_baixa := 'TS';
else
        NEW.ie_origem_baixa := 'TP';
end if;

if (OLD.dt_baixa <> NEW.dt_baixa) then
        CALL philips_contabil_pck.valida_se_dia_fechado(OBTER_EMPRESA_ESTAB(cd_estabelecimento_w),NEW.dt_baixa);
end if;


if (obter_nr_seq_locale(NEW.nm_usuario) = 2) then --(philips_param_pck.get_cd_pais = 2)
        if ( NEW.nr_nfe_imp is not null) /*and (:old.nr_nfe_imp is null) */
then
                        CALL ctb_uuid_pck.atualizar_uuid_movt_contab_doc(NEW.nr_titulo,
                                                                NEW.nr_sequencia,
                                                                13,
                                                                NEW.nr_nfe_imp,
                                                                null,
                                                                null
                                                                );
        end if;
end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_baixa_update() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_baixa_update
	BEFORE UPDATE ON titulo_pagar_baixa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_baixa_update();
