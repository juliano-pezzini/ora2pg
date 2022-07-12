-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pep_med_fatur_after_insert ON pep_med_fatur CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pep_med_fatur_after_insert() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_libera_partic_w	varchar(10);
nr_atendimento_w   bigint;
cd_pessoa_fisica_w varchar(10);
ie_lib_fatur_med_w	varchar(15);	
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

if (TG_OP = 'INSERT') or (TG_OP = 'UPDATE') then
	select	max(ie_lib_fatur_med)
	into STRICT	ie_lib_fatur_med_w
	from	parametro_medico
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;


	if (coalesce(ie_lib_fatur_med_w,'N') = 'S') then
		select	max(c.nr_atendimento),
					max(c.cd_pessoa_fisica)
		into STRICT		nr_atendimento_w,
					cd_pessoa_fisica_w
		from		atendimento_paciente c
		where		c.nr_atendimento = NEW.nr_atendimento;

		if (NEW.dt_liberacao is null) then
			ie_tipo_w := 'LFM';
		elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
			ie_tipo_w := 'XLFM';
		end if;

		if (ie_tipo_w	is not null) then
			CALL Gerar_registro_pendente_PEP(ie_tipo_w, NEW.nr_sequencia, cd_pessoa_fisica_w, nr_atendimento_w, NEW.nm_usuario);	
		end if;
	end if;
elsif (TG_OP = 'DELETE') then
	BEGIN
	delete	FROM pep_item_pendente
	where	nr_seq_registro = OLD.nr_sequencia
	and	coalesce(ie_tipo_pendencia,'L') = 'L'
	and	ie_tipo_registro = 'LFM';

	commit;
	exception
	when others then
		null;
	end;
end if;

<<Final>>
qt_reg_w	:= 0;
  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pep_med_fatur_after_insert() FROM PUBLIC;

CREATE TRIGGER pep_med_fatur_after_insert
	AFTER INSERT OR UPDATE OR DELETE ON pep_med_fatur FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pep_med_fatur_after_insert();

