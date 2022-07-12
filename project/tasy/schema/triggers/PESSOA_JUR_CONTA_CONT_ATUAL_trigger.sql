-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pessoa_jur_conta_cont_atual ON pessoa_jur_conta_cont CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pessoa_jur_conta_cont_atual() RETURNS trigger AS $BODY$
declare
ds_erro_w		varchar(2000);
ie_tipo_w			varchar(1);
BEGIN

if (NEW.cd_conta_contabil is not null) then

	select	max(ie_tipo)
	into STRICT	ie_tipo_w
	from	conta_contabil
	where	cd_conta_contabil	= NEW.cd_conta_contabil;

	if (ie_tipo_w = 'T') then
		/*(-20011,'Não pode ser informado conta do tipo Título! ' ||
						'Conta: ' || :new.cd_conta_contabil || ' PJ: ' || :new.cd_cgc || '#@#@');*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(263192,'CD_CONTA=' || NEW.cd_conta_contabil ||
								';CD_CGC=' || NEW.cd_cgc);
	end if;
end if;

ds_erro_w := con_consiste_vigencia_conta(NEW.cd_conta_contabil, NEW.dt_inicio_vigencia, NEW.dt_fim_vigencia, ds_erro_w);
if (ds_erro_w is not null) then
	/*(-20111, ds_erro_w);*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(263193,'DS_ERRO=' || ds_erro_w);
end if;

RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pessoa_jur_conta_cont_atual() FROM PUBLIC;

CREATE TRIGGER pessoa_jur_conta_cont_atual
	BEFORE INSERT OR UPDATE ON pessoa_jur_conta_cont FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pessoa_jur_conta_cont_atual();
