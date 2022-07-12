-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_fisica_conta_ctb_update ON pessoa_fisica_conta_ctb CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_fisica_conta_ctb_update() RETURNS trigger AS $BODY$
DECLARE
qt_existe_vigencia_w		smallint;
dt_inicio_vigencia_w		timestamp;
dt_fim_vigencia_w		timestamp;
ie_conta_vigente_w		varchar(1);
qt_reg_w	smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
select	count(*)
into STRICT	qt_existe_vigencia_w
from	conta_contabil
where	cd_conta_contabil = NEW.cd_conta_contabil
and	dt_inicio_vigencia is not null
and	dt_fim_vigencia is not null;

if (qt_existe_vigencia_w > 0) then
	BEGIN
	if (NEW.dt_inicio_vigencia is null) or (NEW.dt_fim_vigencia is null) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(278469);
	end if;

	select	dt_inicio_vigencia,
		dt_fim_vigencia
	into STRICT	dt_inicio_vigencia_w,
		dt_fim_vigencia_w
	from	conta_contabil
	where	cd_conta_contabil = NEW.cd_conta_contabil;

	if (dt_inicio_vigencia_w < NEW.dt_inicio_vigencia) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(278471);
	end if;
	if (dt_fim_vigencia_w > NEW.dt_fim_vigencia) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(278473);
	end if;

	end;
end if;

if (NEW.dt_inicio_vigencia > NEW.dt_fim_vigencia) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(278475);
end if;

<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_fisica_conta_ctb_update() FROM PUBLIC;

CREATE TRIGGER pessoa_fisica_conta_ctb_update
	BEFORE UPDATE ON pessoa_fisica_conta_ctb FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_fisica_conta_ctb_update();
