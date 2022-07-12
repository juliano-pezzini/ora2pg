-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cirurgia_participante_delete ON cirurgia_participante CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cirurgia_participante_delete() RETURNS trigger AS $BODY$
DECLARE
ie_gerar_particip_w	varchar(255);
 
BEGIN 
 
ie_gerar_particip_w := Obter_Valor_Param_Usuario(872, 448, Obter_Perfil_Ativo, NEW.nm_usuario, 0);
 
if (ie_gerar_particip_w = 'S') and (wheb_usuario_pck.get_cd_funcao = 872) then 
	 
	if (OLD.cd_pessoa_fisica is not null) then 
 
		CALL Ajustar_Participante_Proc( 
				'DELETE', 
				OLD.nr_cirurgia, 
				OLD.nr_sequencia, 
				OLD.ie_funcao, 
				OLD.cd_pessoa_fisica, 
				OLD.nm_participante, 
				OLD.nr_seq_procedimento, 
				'');
	end if;
elsif (coalesce(ie_gerar_particip_w,'X') <> 'U') then 
	 
	CALL Ajustar_Participante_Proc( 
			'DELETE', 
			OLD.nr_cirurgia, 
			OLD.nr_sequencia, 
			OLD.ie_funcao, 
			OLD.cd_pessoa_fisica, 
			OLD.nm_participante, 
			OLD.nr_seq_procedimento, 
			'');
end if;
RETURN OLD;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cirurgia_participante_delete() FROM PUBLIC;

CREATE TRIGGER cirurgia_participante_delete
	BEFORE DELETE ON cirurgia_participante FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cirurgia_participante_delete();

