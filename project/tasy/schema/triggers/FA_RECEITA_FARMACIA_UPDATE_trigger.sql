-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS fa_receita_farmacia_update ON fa_receita_farmacia CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_fa_receita_farmacia_update() RETURNS trigger AS $BODY$
declare
 
cd_pessoa_fisica_w	varchar(10);
 
BEGIN 
 
	if (NEW.nr_atendimento is not null) then 
 
		select 	cd_pessoa_fisica 
		into STRICT	cd_pessoa_fisica_w 
		from	atendimento_paciente 
		where	nr_atendimento = NEW.nr_atendimento;
		 
		if (cd_pessoa_fisica_w <> NEW.cd_pessoa_fisica) then 
			-- O atendimento '||:new.nr_atendimento||' não pertence a seguinte pessoa: '||obter_nome_pf(:new.cd_pessoa_fisica)||'. Favor verificar#@#@' 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(263626,	'NR_ATENDIMENTO_W='||TO_CHAR(NEW.NR_ATENDIMENTO)|| ';' || 
															'CD_PESSOA_FISICA_W= '|| obter_nome_pf(NEW.CD_PESSOA_FISICA));
		end if;
	end if;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_fa_receita_farmacia_update() FROM PUBLIC;

CREATE TRIGGER fa_receita_farmacia_update
	BEFORE UPDATE ON fa_receita_farmacia FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_fa_receita_farmacia_update();

