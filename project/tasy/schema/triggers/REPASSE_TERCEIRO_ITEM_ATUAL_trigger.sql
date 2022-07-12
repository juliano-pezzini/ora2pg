-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS repasse_terceiro_item_atual ON repasse_terceiro_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_repasse_terceiro_item_atual() RETURNS trigger AS $BODY$
declare

cont_w				smallint;
nr_seq_repasse_w		bigint;
qt_reg_w			smallint;
ie_vincular_rep_proc_pos_w	varchar(1);
ie_vinc_repasse_ret_w		varchar(1);

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

CALL CONSISTIR_VENC_REPASSE(
	OLD.nr_repasse_terceiro,
	NEW.nr_repasse_terceiro,
	OLD.vl_repasse,
	NEW.vl_repasse,
	0,
	0);


-- se está desvinculando
if (NEW.nr_repasse_terceiro is null) and (OLD.nr_repasse_terceiro is not null) then
	select	count(*)
	into STRICT	cont_w
	from	repasse_terceiro
	where	nr_repasse_terceiro	= OLD.nr_repasse_terceiro
	and	ie_status		= 'F';

	if (cont_w > 0) then
		/* O repasse deste item já está fechado!
		Repasse: #@NR_REPASSE_TERCEIRO#@*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266952, 'NR_REPASSE_TERCEIRO=' || OLD.nr_repasse_terceiro);
	end if;
end if;

-- se está vinculando
if (NEW.nr_repasse_terceiro is not null) and (OLD.nr_repasse_terceiro is null) then
	select	count(*)
	into STRICT	cont_w
	from	repasse_terceiro
	where	nr_repasse_terceiro	= NEW.nr_repasse_terceiro
	and	ie_status		= 'F';

	if (cont_w > 0) then
		/* O repasse deste item já está fechado!
		Repasse: #@NR_REPASSE_TERCEIRO#@*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266952, 'NR_REPASSE_TERCEIRO=' || OLD.nr_repasse_terceiro);
	end if;
end if;

<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_repasse_terceiro_item_atual() FROM PUBLIC;

CREATE TRIGGER repasse_terceiro_item_atual
	BEFORE UPDATE ON repasse_terceiro_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_repasse_terceiro_item_atual();

