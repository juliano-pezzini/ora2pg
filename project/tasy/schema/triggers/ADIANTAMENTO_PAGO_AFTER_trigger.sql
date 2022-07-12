-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS adiantamento_pago_after ON adiantamento_pago CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_adiantamento_pago_after() RETURNS trigger AS $BODY$
declare

ie_cont_prov_adiant_pago_w      parametros_contas_pagar.ie_contab_prov_adiant_pago%type;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (coalesce(NEW.vl_adiantamento, 0) <> 0) then
        BEGIN

        BEGIN
        select  coalesce(ie_contab_prov_adiant_pago, 'N')
        into STRICT    ie_cont_prov_adiant_pago_w
        from    parametros_contas_pagar
        where   cd_estabelecimento = NEW.cd_estabelecimento;
        exception when others then
                ie_cont_prov_adiant_pago_w := 'N';
        end;

        BEGIN
        select  CASE WHEN a.ie_ctb_online='S' THEN  coalesce(a.ie_contab_prov_adiant_pago, 'N')  ELSE ie_cont_prov_adiant_pago_w END 
        into STRICT    ie_cont_prov_adiant_pago_w
        from    ctb_param_lote_contas_pag a
        where   a.cd_empresa = obter_empresa_estab(NEW.cd_estabelecimento)
        and     coalesce(a.cd_estab_exclusivo, NEW.cd_estabelecimento) = NEW.cd_estabelecimento;
        exception when others then
                null;
        end;

        if (ie_cont_prov_adiant_pago_w = 'S') then
                BEGIN
                CALL ctb_concil_financeira_pck.ctb_gravar_documento(       NEW.cd_estabelecimento,
                                                                        NEW.dt_adiantamento,
                                                                        7,
                                                                        NEW.nr_seq_trans_fin,
                                                                        18,
                                                                        NEW.nr_adiantamento,
                                                                        null,
                                                                        null,
                                                                        NEW.vl_adiantamento,
                                                                        'ADIANTAMENTO_PAGO',
                                                                        'VL_ADIANT_PAGO',
                                                                        NEW.nm_usuario);
                end;
        end if;

        end;
end if;
end if;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_adiantamento_pago_after() FROM PUBLIC;

CREATE TRIGGER adiantamento_pago_after
	AFTER INSERT ON adiantamento_pago FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_adiantamento_pago_after();

