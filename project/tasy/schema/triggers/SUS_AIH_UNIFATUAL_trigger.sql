-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS sus_aih_unifatual ON sus_aih_unif CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_sus_aih_unifatual() RETURNS trigger AS $BODY$
DECLARE

cd_convenio_w			integer;
ie_tipo_financiamento_w		varchar(4);
ie_complexidade_w		varchar(2);
ie_dados_comp_conta_w		varchar(15);
ie_codigo_autorizacao_w		bigint;
cd_motivo_cobranca_w		bigint;
cd_cid_causa_morte_w		varchar(15);
BEGIN
  BEGIN

cd_convenio_w	:= cd_convenio_w;
/* Felipe 14/03/2008 - OS 86154
if	(:new.nr_interno_conta is null) and
	(:old.nr_interno_conta is null) then

	select	max(a.cd_convenio)
	into	cd_convenio_w
	from	atend_categoria_convenio	a,
		convenio			c
	where	c.cd_convenio		= a.cd_convenio
	and	c.ie_tipo_convenio	= 3
	and	a.nr_atendimento	= :new.nr_atendimento;

	select	nvl(max(a.nr_interno_conta),null)
	into	:new.nr_interno_conta
	from 	conta_paciente	a
	where 	a.nr_atendimento 	= :new.nr_atendimento
	and	a.cd_convenio_parametro	= cd_convenio_w
	and	a.ie_status_acerto	= 1
	and	a.nr_interno_conta not in (select x.nr_interno_conta from sus_aih_unif x where a.nr_interno_conta = x.nr_interno_conta);
end if;
*/
BEGIN
select	ie_tipo_financiamento,
	ie_complexidade
into STRICT	ie_tipo_financiamento_w,
	ie_complexidade_w
from	sus_procedimento
where	cd_procedimento = NEW.cd_procedimento_real
and	ie_origem_proced = 7;
exception
	when others then
		null;
	end;

if (NEW.ie_tipo_financiamento is null) then
	NEW.ie_tipo_financiamento	:= ie_tipo_financiamento_w;
end if;

if (NEW.ie_complexidade is null) then
	NEW.ie_complexidade	:= ie_complexidade_w;
end if;

if (NEW.cd_procedimento_real	<> OLD.cd_procedimento_real) then
	NEW.ie_complexidade	:= ie_complexidade_w;
	NEW.ie_tipo_financiamento	:= ie_tipo_financiamento_w;
end if;

ie_dados_comp_conta_w := coalesce(Obter_Valor_Param_Usuario(1123,207, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, 0),'N');

if (coalesce(ie_dados_comp_conta_w,'N') = 'S') then
	BEGIN
	if (coalesce(NEW.nr_interno_conta,0) <> 0) then
		BEGIN

		BEGIN
		select	ie_codigo_autorizacao,
			cd_motivo_cobranca,
			cd_cid_causa_morte
		into STRICT	ie_codigo_autorizacao_w,
			cd_motivo_cobranca_w,
			cd_cid_causa_morte_w
		from	sus_dados_aih_conta
		where	nr_interno_conta = NEW.nr_interno_conta;
		exception
		when others then
			ie_codigo_autorizacao_w	:= NEW.ie_codigo_autorizacao;
			cd_motivo_cobranca_w	:= NEW.cd_motivo_cobranca;
			cd_cid_causa_morte_w	:= NEW.cd_cid_causa_morte;
		end;

		NEW.ie_codigo_autorizacao := ie_codigo_autorizacao_w;
		NEW.cd_motivo_cobranca := cd_motivo_cobranca_w;
		NEW.cd_cid_causa_morte := cd_cid_causa_morte_w;

		end;
	end if;
	end;
end if;

  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_sus_aih_unifatual() FROM PUBLIC;

CREATE TRIGGER sus_aih_unifatual
	BEFORE INSERT OR UPDATE ON sus_aih_unif FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_sus_aih_unifatual();
