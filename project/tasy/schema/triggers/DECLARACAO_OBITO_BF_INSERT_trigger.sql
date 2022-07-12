-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS declaracao_obito_bf_insert ON declaracao_obito CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_declaracao_obito_bf_insert() RETURNS trigger AS $BODY$
declare

qt_reg_w		bigint				:= 0;
ie_lib_obito_w		parametro_medico.ie_lib_obito%type	:= 'N';
nr_atendimento_w	declaracao_obito.nr_atendimento%type	:= 0;
ie_inativa_obito_w	varchar(2)				:= 'N';

pragma autonomous_transaction;	
BEGIN
  BEGIN

ie_inativa_obito_w := coalesce(obter_valor_param_usuario(916, 1125, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo),'N');

if ((ie_inativa_obito_w = 'N') or (ie_inativa_obito_w = 'S' AND obter_funcao_ativa != 916)) then


	BEGIN
		select	coalesce(MAX(ie_lib_obito),'N')
		into STRICT	ie_lib_obito_w
		from	parametro_medico
		where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	exception
	when others then
		ie_lib_obito_w := 'N';
	end;

	BEGIN
		select	nr_atendimento
		into STRICT	nr_atendimento_w
		from	declaracao_obito
		where	nr_declaracao = NEW.nr_declaracao
		and	coalesce(ie_situacao,'A') = 'A'
		and (ie_lib_obito_w = 'N' or dt_liberacao is not null)  LIMIT 1;
	exception
	when 	no_data_found then
		nr_atendimento_w := 0;
	end;

	if (nr_atendimento_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(70998,'ITEM='||to_char(nr_atendimento_w));
	else
		if (ie_lib_obito_w = 'S') then

			BEGIN
				select	1
				into STRICT	qt_reg_w
				from	declaracao_obito a,
						atendimento_paciente b
				where	a.nr_atendimento = b.nr_atendimento
				and	b.cd_pessoa_fisica = obter_pessoa_atendimento(NEW.nr_atendimento, 'C')
				and	coalesce(a.ie_situacao,'A') = 'A'
				and	coalesce(a.ie_rn,'N') = 'N'  LIMIT 1;
			exception
			when 	no_data_found then
				qt_reg_w := 0;
			end;

			if (qt_reg_w > 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(319605);
			end if;

		end if;
	end if;
end if;
commit;

  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_declaracao_obito_bf_insert() FROM PUBLIC;

CREATE TRIGGER declaracao_obito_bf_insert
	BEFORE INSERT ON declaracao_obito FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_declaracao_obito_bf_insert();

