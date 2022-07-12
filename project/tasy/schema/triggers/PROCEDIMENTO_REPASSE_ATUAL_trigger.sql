-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS procedimento_repasse_atual ON procedimento_repasse CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_procedimento_repasse_atual() RETURNS trigger AS $BODY$
declare

cont_w				smallint;
nr_seq_repasse_w		bigint;
qt_reg_w			smallint;
ie_vincular_rep_proc_pos_w	varchar(1);
ie_vinc_repasse_ret_w		varchar(1);
ie_conta_repasse_w		parametro_faturamento.ie_conta_repasse%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

BEGIN

NEW.ds_log := substr(OLD.ds_log || chr(13) || chr(10) || ' Atualizacao no repasse: ' || substr(dbms_utility.format_call_stack,1,4000),1,4000);

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

cd_estabelecimento_w	:= obter_estabelecimento_ativo;

select	max(IE_CONTA_REPASSE)
into STRICT	ie_conta_repasse_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_w;

CALL CONSISTIR_VENC_REPASSE(
	OLD.nr_repasse_terceiro,
	NEW.nr_repasse_terceiro,
	OLD.vl_repasse,
	NEW.vl_repasse,
	OLD.vl_liberado,
	NEW.vl_liberado);


-- se esta desvinculando

if (NEW.nr_repasse_terceiro is null) and (OLD.nr_repasse_terceiro is not null) then
	select	count(*)
	into STRICT	cont_w
	from	repasse_terceiro
	where	nr_repasse_terceiro	= OLD.nr_repasse_terceiro
	and	ie_status		= 'F';

	if (cont_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(220250,'NR_REPASSE_P='||OLD.nr_repasse_terceiro);
		/*'O repasse deste procedimento ja esta fechado!' || chr(13) ||
						'Repasse: ' || :old.nr_repasse_terceiro);*/

	end if;
end if;

-- se esta vinculando

if (NEW.nr_repasse_terceiro is not null) and (OLD.nr_repasse_terceiro is null) then
	select	count(*)
	into STRICT	cont_w
	from	repasse_terceiro
	where	nr_repasse_terceiro	= NEW.nr_repasse_terceiro
	and	ie_status		= 'F';

	if (cont_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(220250,'NR_REPASSE_P='||OLD.nr_repasse_terceiro);
		/*'O repasse deste procedimento ja esta fechado!' || chr(13) ||
						'Repasse: ' || :old.nr_repasse_terceiro);*/

	end if;
end if;

if (NEW.ie_status <> OLD.ie_status) and
	(((ie_conta_repasse_w = 'S') and
	((NEW.ie_status = 'S') or (NEW.ie_status = 'L'))) or
	((ie_conta_repasse_w = 'R') and
	((NEW.ie_status = 'R') or (NEW.ie_status = 'S') or (NEW.ie_status = 'L')))) then
	BEGIN
	if (NEW.dt_liberacao is null) then
		NEW.dt_liberacao	:= LOCALTIMESTAMP;
	end if;

	if (NEW.nr_repasse_terceiro is null) and (OLD.nr_repasse_terceiro is null) then

		nr_seq_repasse_w := obter_repasse_terceiro(
			NEW.dt_liberacao, NEW.nr_seq_terceiro, NEW.nm_usuario, NEW.nr_seq_procedimento, 'P', nr_seq_repasse_w, null, null);

		select	coalesce(max(b.ie_vincular_rep_proc_pos),'S'),
			coalesce(max(b.ie_vinc_repasse_ret),'S')
		into STRICT	ie_vincular_rep_proc_pos_w,
			ie_vinc_repasse_ret_w
		from	parametro_faturamento b,
			terceiro a
		where	a.cd_estabelecimento	= b.cd_estabelecimento
		and	a.nr_sequencia		= NEW.nr_seq_terceiro;

		if (coalesce(nr_seq_repasse_w,0) > 0) then
			if	((ie_vincular_rep_proc_pos_w = 'N') and (trunc(NEW.dt_liberacao, 'dd') > trunc(LOCALTIMESTAMP, 'dd'))) or (ie_vinc_repasse_ret_w = 'N') then
				NEW.nr_repasse_terceiro	:= null;
			else
				NEW.nr_repasse_terceiro	:= nr_seq_repasse_w;
			end if;
		end if;

	end if;
	end;
end if;

if (NEW.ie_status <> OLD.ie_status) and
	((NEW.ie_status = 'R') or (NEW.ie_status = 'S') or (NEW.ie_status = 'L')) then

	CALL CONSISTIR_ITEM_REPASSE_TIT(NEW.nr_seq_procedimento,null);

end if;

if (NEW.ie_status <> OLD.ie_status) then
	NEW.ds_status := substr(obter_valor_dominio(1129, NEW.ie_status),1,50);
end if;

if (NEW.nr_seq_trans_fin <> OLD.nr_seq_trans_fin) then
    NEW.ds_transacao := substr(obter_desc_trans_financ(NEW.nr_seq_trans_fin),1,100);
end if;

<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_procedimento_repasse_atual() FROM PUBLIC;

CREATE TRIGGER procedimento_repasse_atual
	BEFORE UPDATE ON procedimento_repasse FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_procedimento_repasse_atual();

