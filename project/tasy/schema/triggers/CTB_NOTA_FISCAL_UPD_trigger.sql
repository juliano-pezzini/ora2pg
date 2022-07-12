-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_nota_fiscal_upd ON nota_fiscal CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_nota_fiscal_upd() RETURNS trigger AS $BODY$
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
    /* se o pais do usuario for mexico */

    if (obter_nr_seq_locale(NEW.nm_usuario) = 2) then

        NEW.cd_cno := coalesce(NEW.cd_cno,obter_dados_pf_pj(NEW.cd_pessoa_fisica,NEW.cd_cgc,'RFC'));

        CALL ctb_uuid_pck.atualizar_uuid_movt_contab_doc(
                null,
                null,
                14,
                NEW.nr_nfe_imp,
                NEW.nr_lote_contabil,
                NEW.nr_sequencia,
                NEW.nr_sequencia_ref,
                NEW.nr_seq_baixa_tit
                );
        CALL ctb_uuid_pck.atualizar_uuid_documento(
                NEW.nr_sequencia,
                NEW.nr_nfe_imp,
                NEW.nr_interno_conta);
    end if;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_nota_fiscal_upd() FROM PUBLIC;

CREATE TRIGGER ctb_nota_fiscal_upd
	BEFORE UPDATE OF nr_nfe_imp ON nota_fiscal FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_nota_fiscal_upd();

