-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS adiant_pago_dev_after ON adiant_pago_dev CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_adiant_pago_dev_after() RETURNS trigger AS $BODY$
declare

cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (coalesce(NEW.vl_devolucao, 0) <> 0) then
	BEGIN
	
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	adiantamento_pago
	where	nr_adiantamento = NEW.nr_adiantamento;
	
	CALL ctb_concil_financeira_pck.ctb_gravar_documento(	cd_estabelecimento_w,
								NEW.dt_devolucao,
								7,
								NEW.nr_seq_trans_fin,
								17,
								NEW.nr_adiantamento,
								NEW.nr_sequencia,
								null,
								NEW.vl_devolucao,
								'ADIANT_PAGO_DEV',
								'VL_ADIANT_DEV',
								NEW.nm_usuario);
	
	end;
end if;
end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_adiant_pago_dev_after() FROM PUBLIC;

CREATE TRIGGER adiant_pago_dev_after
	AFTER INSERT ON adiant_pago_dev FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_adiant_pago_dev_after();
