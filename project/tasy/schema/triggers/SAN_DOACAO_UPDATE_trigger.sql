-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_doacao_update ON san_doacao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_doacao_update() RETURNS trigger AS $BODY$
declare
ie_sexo_w		varchar(1);
qt_reg_w		smallint;
ie_altera_volume_w	varchar(1);
ds_parametro_459_w	varchar(10);
ie_gerar_nr_sangue_w	san_parametro.ie_gerar_nr_sangue%type;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'N')  then
	goto Final;
end if;

select	coalesce(max(ie_altera_volume),'S')
into STRICT	ie_altera_volume_w
from	san_parametro
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

select	coalesce(max(ie_gerar_nr_sangue), 'N')
into STRICT	ie_gerar_nr_sangue_w
from	san_parametro
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if	((ie_altera_volume_w = 'S') and (NEW.qt_peso is not null) and (coalesce(NEW.qt_peso,0) <> coalesce(OLD.qt_peso,0))) then

	select	coalesce(max(ie_sexo),'X')
	into STRICT	ie_sexo_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = NEW.cd_pessoa_fisica;

	if (ie_sexo_w = 'F') then
		NEW.qt_coletada := NEW.qt_peso * 8;
	elsif (ie_sexo_w = 'M') then
		NEW.qt_coletada := NEW.qt_peso * 9;
	end if;

	if (NEW.qt_coletada > 500) then
		NEW.qt_coletada := 500;
	end if;
end if;
if (OLD.dt_fim_coleta <> NEW.dt_fim_coleta) or (OLD.dt_fim_coleta is null and NEW.dt_fim_coleta is not null) then
	NEW.dt_fim_coleta	:= to_date(to_char(coalesce(OLD.dt_fim_coleta,LOCALTIMESTAMP),'dd/mm/yyyy')||' '||to_char(NEW.dt_fim_coleta,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
end if;


if	(OLD.cd_pessoa_fisica is not null AND OLD.cd_pessoa_fisica <> NEW.cd_pessoa_fisica) then

	ds_parametro_459_w := obter_valor_param_usuario(450,459,obter_perfil_ativo,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);

	if (NEW.dt_liberacao_cadastro is not null) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(283961);
	elsif (coalesce(ds_parametro_459_w,'S') = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(283966);
	end if;
end if;

if (NEW.nr_sangue is not null) and (ie_gerar_nr_sangue_w = 'S') then

	if (NEW.nr_sequencia <> san_existe_nr_sangue(NEW.nr_sequencia, NEW.nr_sangue)) then
		CALL gravar_log_atendimento_pragma(120, null, obter_expressao_dic_objeto(75481) || '(' || NEW.nr_sangue || ')', wheb_usuario_pck.get_nm_usuario);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(75481);
	end if;

end if;

if	 ((OLD.qt_peso <> NEW.qt_peso) or (OLD.qt_peso is null and  NEW.qt_peso is not null))  then

	update 	pessoa_fisica
	set	qt_peso = NEW.qt_peso
	where 	cd_pessoa_fisica = NEW.cd_pessoa_fisica;

end if;

if	 ((OLD.qt_altura <> NEW.qt_altura) or (OLD.qt_altura is null and  NEW.qt_altura is not null))   then

	update 	pessoa_fisica
	set	qt_altura_cm = NEW.qt_altura
	where 	cd_pessoa_fisica = NEW.cd_pessoa_fisica;

end if;

<<Final>>
qt_reg_w	:= 0;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_doacao_update() FROM PUBLIC;

CREATE TRIGGER san_doacao_update
	BEFORE UPDATE ON san_doacao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_doacao_update();
