-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS oft_oculos_pend_atual ON oft_oculos CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_oft_oculos_pend_atual() RETURNS trigger AS $BODY$
declare

PRAGMA AUTONOMOUS_TRANSACTION;

qt_reg_w	               smallint;
ie_tipo_w		            varchar(10);
cd_pessoa_fisica_w	varchar(30);
nr_atendimento_w    bigint;
ie_libera_exames_oft_w	varchar(5);
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	coalesce(max(ie_libera_exames_oft),'N')
into STRICT	ie_libera_exames_oft_w
from	parametro_medico
where	cd_estabelecimento = obter_estabelecimento_ativo;

if (ie_libera_exames_oft_w = 'S') then
	if (TG_OP = 'INSERT') or (TG_OP = 'UPDATE') then

		if (NEW.dt_liberacao is null) then
			ie_tipo_w := 'REOL';
		elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
               ie_tipo_w := 'XREOL';
		end if;

      select	max(a.nr_atendimento),
                  max(a.cd_pessoa_fisica)
      into STRICT	   nr_atendimento_w,
                  cd_pessoa_fisica_w
      from     oft_consulta a where a.nr_sequencia = NEW.nr_seq_consulta;

		BEGIN
		if (ie_tipo_w	is not null) then
			CALL Gerar_registro_pendente_PEP(ie_tipo_w, NEW.nr_sequencia, cd_pessoa_fisica_w, nr_atendimento_w, NEW.nm_usuario);
		end if;
		exception
			when others then
			null;
		end;

	elsif (TG_OP = 'DELETE') then
            delete 	from pep_item_pendente
            where 	IE_TIPO_REGISTRO = 'REOL'
            and	      nr_seq_registro = OLD.nr_sequencia
            and	      coalesce(IE_TIPO_PENDENCIA,'L')	= 'L';

            commit;
    end if;

	commit;
end if;

<<Final>>
qt_reg_w	:= 0;
  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_oft_oculos_pend_atual() FROM PUBLIC;

CREATE TRIGGER oft_oculos_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON oft_oculos FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_oft_oculos_pend_atual();
