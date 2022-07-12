-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_regra_ticket_medio_insert ON ctb_regra_ticket_medio CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_regra_ticket_medio_insert() RETURNS trigger AS $BODY$
declare

ds_regra_w		varchar(40);
ie_conta_vigente_w	varchar(1);
ie_tipo_w			varchar(1);
ie_situacao_w		varchar(1);
ie_resultado_w		varchar(1);

BEGIN
ds_regra_w	:= substr(obter_valor_dominio(1719,NEW.ie_regra),1,40);

if (NEW.nr_seq_grupo_conta is not null) then
	NEW.cd_conta_contabil	:= null;
end if;

if (NEW.ie_regra = 'VF') then
	NEW.pr_aplicar		:= null;
	NEW.nr_seq_mes_ref	:= null;
elsif (NEW.ie_regra = 'PO') then
	NEW.vl_fixo		:= null;
elsif (NEW.ie_regra = 'PV') then
	NEW.vl_fixo		:= null;
	NEW.nr_seq_mes_ref	:= null;
	if (NEW.dt_mes_inic is null) or (NEW.dt_mes_fim is null) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266575);
		/*Para este tipo de regra é obrigatória a informação dos campos Mês inicial e final!#@#@');*/

	end if;
end if;

if (NEW.cd_conta_contabil is null) and (NEW.nr_seq_grupo_conta is null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266608,'NR_SEQ_REGRA=' || NEW.nr_seq_regra);
end if;

ie_conta_vigente_w	:= substr(obter_se_conta_vigente(NEW.cd_conta_contabil, LOCALTIMESTAMP),1,1);

if (ie_conta_vigente_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(237680,'CD_CONTA_CONTABIL_W=' || NEW.cd_conta_contabil);
	/*Esta conta contábil esta fora da data de vigência.');*/

end if;

if (NEW.ie_regra = 'VF') and (NEW.cd_centro_custo is null) and (NEW.nr_seq_grupo_centro is null) then
	/*Deve ser informado um grupo ou um centro de custo!');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(266610);
end if;


/* Consistência centro de custo */

if (NEW.cd_centro_custo is not null) then
	select	coalesce(max(ie_tipo),'X'),
		coalesce(max(ie_situacao),'I')
	into STRICT	ie_tipo_w,
		ie_situacao_w
	from	centro_custo
	where	cd_centro_custo = NEW.cd_centro_custo;

	if (ie_tipo_w <> 'A') then
		/*Só pode ser informado centro de custo do tipo analítico!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266580);
	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266581);
		/*O centro de custo informado está inativo! ' || 'Código: ' || :new.cd_centro_custo);*/

	end if;

end if;

/* Conta contábil */

if (NEW.cd_conta_contabil is not null) then
	select	coalesce(max(a.ie_tipo),'X'),
		coalesce(max(a.ie_situacao),'I'),
		max(b.ie_tipo)
	into STRICT	ie_tipo_w,
		ie_situacao_w,
		ie_resultado_w
	from	ctb_grupo_conta b,
		conta_contabil a
	where	a.cd_grupo		= b.cd_grupo
	and	a.cd_conta_contabil	= NEW.cd_conta_contabil;

	if (ie_tipo_w <> 'A') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266584);
		/*Só pode ser informado Conta contábil analítica!');*/

	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266611,'CD_CONTA_CONTABIL=' || NEW.cd_conta_contabil);
		/*'A conta contábil informada está inativa!');*/

	end if;
	if (ie_resultado_w not in ('R','C','D')) then
		/*A conta contábil informada não é do tipo resultado!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266614);
	end if;

end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_regra_ticket_medio_insert() FROM PUBLIC;

CREATE TRIGGER ctb_regra_ticket_medio_insert
	BEFORE INSERT OR UPDATE ON ctb_regra_ticket_medio FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_regra_ticket_medio_insert();
