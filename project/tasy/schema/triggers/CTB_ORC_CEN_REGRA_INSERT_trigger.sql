-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_orc_cen_regra_insert ON ctb_orc_cen_regra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_orc_cen_regra_insert() RETURNS trigger AS $BODY$
declare

ie_conta_vigente_w		varchar(1);
ie_tipo_w			varchar(1);
ie_situacao_w			varchar(1);
ie_permite_w			varchar(1);
ie_resultado_w		varchar(1);

BEGIN
if (NEW.ie_regra_valor = 'VF') then
	BEGIN
	NEW.pr_aplicar			:= null;
	NEW.nr_seq_mes_ref_orig		:= null;
	if (NEW.vl_fixo is null) then
		/*Para regra de valor fixo deve haver um valor informado, mesmo que seja zero!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266569);
	end if;
	if (NEW.nr_seq_mes_ref_orig is not null) then
		/*'Para valores fixos informar a data inicial e final e não o mês de origem!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266570);
	end if;
	if (NEW.dt_mes_inic is null) or (NEW.dt_mes_fim is null) then
		/*'Para valores fixos informar a data inicial e final!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266571);
	end if;
	if (NEW.cd_centro_custo is null) and (NEW.nr_seq_criterio_rateio is null) then
		/*Para valores fixos deve-se informar um critério de rateio ou um Centro de custo!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266572);
	end if;
	if (NEW.cd_conta_contabil is null) then
		/*Para valores fixos informar a conta contabil!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266573);
	end if;
	if (NEW.cd_centro_custo is not null) and (NEW.nr_seq_criterio_rateio is not null) then
		/*Para valores fixos deve-se informar somente um critério de rateio ou um Centro de custo!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266574);
	end if;
	end;
elsif (NEW.ie_regra_valor = 'PV') or (NEW.ie_regra_valor = 'PAV') then
	BEGIN
	if (NEW.dt_mes_inic is null) or (NEW.dt_mes_fim is null) then
		/*Para este tipo de regra deve ser informado mês inicial e final!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266575);
	end if;
	if (NEW.pr_aplicar is null) then
		/*Para este tipo de regra deve ser informado uma % APLICAR válida!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266576);
	end if;
	end;
end if;

if (NEW.ie_regra_valor = 'PV') then
	NEW.vl_fixo			:= null;
	NEW.nr_seq_mes_ref_orig	:= null;

	select	coalesce(max(obter_valor_param_usuario(925, 30, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento)), 'N')
	into STRICT	ie_permite_w
	;
	/* Matheus OS 84429 28/02/2008*/

	if (ie_permite_w = 'N') and (coalesce(NEW.cd_centro_origem,0) = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266577);
	end if;
elsif (NEW.ie_regra_valor = 'PAV') then
	NEW.vl_fixo			:= null;
elsif (NEW.ie_regra_valor = 'CM') then
	NEW.vl_fixo			:= null;
	NEW.pr_aplicar			:= null;
	NEW.nr_seq_mes_ref_orig	:= null;
end if;

/* Consistência centro destino*/

if (NEW.cd_centro_custo is not null) then
	select	coalesce(max(ie_tipo),'X'),
		coalesce(max(ie_situacao),'I')
	into STRICT	ie_tipo_w,
		ie_situacao_w
	from	centro_custo
	where	cd_centro_custo = NEW.cd_centro_custo;

	if (ie_tipo_w <> 'A') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266580);
		/*Só pode ser informado centro de custo do tipo analítico!');*/

	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266581);
		/*O centro de custo informado está inativo!');*/

	end if;

end if;
/* Consistência centro origem*/

if (NEW.cd_centro_origem is not null) then
	select	coalesce(max(ie_tipo),'X'),
		coalesce(max(ie_situacao),'I')
	into STRICT	ie_tipo_w,
		ie_situacao_w
	from	centro_custo
	where	cd_centro_custo = NEW.cd_centro_origem;

	if (ie_tipo_w <> 'A') then
		/*Só pode ser informado centro de custo Origem do tipo analítico!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266582);
	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266583);
		/*O centro de custo origem informado está inativo!');*/

	end if;
end if;

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
		/*Só pode ser informado Conta contábil analítica!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266584);
	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266585);
		/*A conta contábil destino informada está inativa!');*/

	end if;
	if (ie_resultado_w not in ('R','C','D')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266586);
		/*A conta contábil destino informada não é do tipo resultado!');*/

	end if;

end if;

/* Consistencia conta origem*/

if (NEW.cd_conta_origem is not null) then
	select	coalesce(max(a.ie_tipo),'X'),
		coalesce(max(a.ie_situacao),'I'),
		max(b.ie_tipo)
	into STRICT	ie_tipo_w,
		ie_situacao_w,
		ie_resultado_w
	from	ctb_grupo_conta b,
		conta_contabil a
	where	a.cd_grupo		= b.cd_grupo
	and	a.cd_conta_contabil	= NEW.cd_conta_origem;

	if (ie_tipo_w <> 'A') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266584);
	end if;

	if (ie_situacao_w = 'I') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266587);
	end if;
	if (ie_resultado_w not in ('R','C','D')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266588);
	end if;

end if;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_orc_cen_regra_insert() FROM PUBLIC;

CREATE TRIGGER ctb_orc_cen_regra_insert
	BEFORE INSERT OR UPDATE ON ctb_orc_cen_regra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_orc_cen_regra_insert();
