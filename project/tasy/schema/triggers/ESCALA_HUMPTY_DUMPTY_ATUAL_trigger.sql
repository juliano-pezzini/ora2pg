-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS escala_humpty_dumpty_atual ON escala_humpty_dumpty CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_escala_humpty_dumpty_atual() RETURNS trigger AS $BODY$
declare
qt_ponto_w	bigint	:= 0;
qt_idade_w	bigint;
ie_sexo_w	varchar(1);
 
BEGIN 
 
if (coalesce(NEW.nr_atendimento,0) > 0) then 
 
	select (coalesce(trim(both obter_idade(dt_nascimento, coalesce(dt_obito,LOCALTIMESTAMP), 'A')),0))::numeric , 
			ie_sexo 
	into STRICT	qt_idade_w, 
			ie_sexo_w 
	from	Pessoa_fisica 
	where 	cd_pessoa_fisica = obter_pessoa_Atendimento(NEW.nr_atendimento,'C')  LIMIT 1;
 
	if (qt_idade_w >= 13) then	 
		qt_ponto_w	:= qt_ponto_w + 1;
	elsif (qt_idade_w >= 7) then	 
		qt_ponto_w	:= qt_ponto_w + 2;
	elsif (qt_idade_w >= 3) then	 
		qt_ponto_w	:= qt_ponto_w + 3;
	else	 
		qt_ponto_w	:= qt_ponto_w + 4;
	end if;	
	 
	 
	if (ie_sexo_w = 'M') then	 
		qt_ponto_w	:= qt_ponto_w + 2;
	elsif (ie_sexo_w = 'F') then	 
		qt_ponto_w	:= qt_ponto_w + 1;
	end if;
end if;	
	 
 
if (NEW.IE_DIAGNOSTICO	is not null) then 
	qt_ponto_w	:= qt_ponto_w + coalesce(NEW.IE_DIAGNOSTICO,0);
end if;
if (NEW.IE_DEFICIENCIA	is not null) then 
	qt_ponto_w	:= qt_ponto_w + coalesce(NEW.IE_DEFICIENCIA,0);
end if;
if (NEW.IE_FAT_AMBIENT	is not null) then 
	qt_ponto_w	:= qt_ponto_w + coalesce(NEW.IE_FAT_AMBIENT,0);
end if;
if (NEW.IE_RESP_CIRURGIA	is not null) then 
	qt_ponto_w	:= qt_ponto_w + coalesce(NEW.IE_RESP_CIRURGIA,0);
end if;
if (NEW.IE_USO_MEDIC	is not null) then 
	qt_ponto_w	:= qt_ponto_w + coalesce(NEW.IE_USO_MEDIC,0);
end if;
 
NEW.QT_PONTUACAO	:= qt_ponto_w;
 
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_escala_humpty_dumpty_atual() FROM PUBLIC;

CREATE TRIGGER escala_humpty_dumpty_atual
	BEFORE INSERT OR UPDATE ON escala_humpty_dumpty FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_escala_humpty_dumpty_atual();
