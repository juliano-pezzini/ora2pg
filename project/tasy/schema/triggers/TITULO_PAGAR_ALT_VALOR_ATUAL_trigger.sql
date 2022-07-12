-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_pagar_alt_valor_atual ON titulo_pagar_alt_valor CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_pagar_alt_valor_atual() RETURNS trigger AS $BODY$
declare

ie_tipo_alteracao_w	varchar(1);
ds_motivo_w		varchar(255);

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
if (NEW.NR_SEQ_MOTIVO is not null) then
	BEGIN
	select	coalesce(ie_tipo_alteracao,'T'),
		ds_motivo
	into STRICT	ie_tipo_alteracao_w,
		ds_motivo_w
	from	motivo_alt_valor
	where	nr_sequencia = NEW.NR_SEQ_MOTIVO;
	
	if (ie_tipo_alteracao_w = 'A') and (NEW.VL_ALTERACAO < NEW.VL_ANTERIOR) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(207613,'ds_motivo='||ds_motivo_w);
	elsif (ie_tipo_alteracao_w = 'D') and (NEW.VL_ALTERACAO > NEW.VL_ANTERIOR) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(207612,'ds_motivo='||ds_motivo_w);
	end if;
	end;
end if;

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_pagar_alt_valor_atual() FROM PUBLIC;

CREATE TRIGGER titulo_pagar_alt_valor_atual
	BEFORE INSERT OR UPDATE ON titulo_pagar_alt_valor FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_pagar_alt_valor_atual();
