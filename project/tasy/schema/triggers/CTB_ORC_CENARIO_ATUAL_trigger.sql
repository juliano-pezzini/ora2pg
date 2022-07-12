-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_orc_cenario_atual ON ctb_orc_cenario CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_orc_cenario_atual() RETURNS trigger AS $BODY$
declare
-- local variables here
BEGIN
  BEGIN
if (NEW.ie_tipo_cenario = 'P' and coalesce(NEW.nr_ano, 0) <> 0) then
	if TG_OP = 'INSERT' then
		BEGIN
			--  Mes Inicio
			select	a.nr_sequencia
			into STRICT	NEW.nr_seq_mes_inicio
			from	ctb_mes_ref a
			where	to_char(a.dt_referencia, 'MM/YYYY')	= '01/' || NEW.nr_ano
			and	a.cd_empresa				= NEW.cd_empresa;

			--  Mes Fim
			select	nr_sequencia
			into STRICT	NEW.nr_seq_mes_fim
			from	ctb_mes_ref
			where	to_char(dt_referencia, 'MM/YYYY')	= '12/' || NEW.nr_ano
			and	cd_empresa				= NEW.cd_empresa;
		exception
			when no_data_found then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1111918);
		end;
	elsif (NEW.nr_ano <> OLD.nr_ano) then
		BEGIN
			--  Mes Inicio
			select	a.nr_sequencia
			into STRICT	NEW.nr_seq_mes_inicio
			from	ctb_mes_ref a
			where	to_char(a.dt_referencia, 'MM/YYYY')	= '01/' || NEW.nr_ano
			and	a.cd_empresa				= NEW.cd_empresa;

			--  Mes Fim
			select	nr_sequencia
			into STRICT	NEW.nr_seq_mes_fim
			from	ctb_mes_ref
			where	to_char(dt_referencia, 'MM/YYYY')	= '12/' || NEW.nr_ano
			and	cd_empresa				= NEW.cd_empresa;
		exception
			when no_data_found then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1111918);
		end;
	end if;
end if;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_orc_cenario_atual() FROM PUBLIC;

CREATE TRIGGER ctb_orc_cenario_atual
	BEFORE INSERT OR UPDATE ON ctb_orc_cenario FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_orc_cenario_atual();
