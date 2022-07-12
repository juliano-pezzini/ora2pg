-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ped_exame_externo_pend_atual ON pedido_exame_externo CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ped_exame_externo_pend_atual() RETURNS trigger AS $BODY$
declare
qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_lib_solic_externo_w	varchar(10) := 'S';
nr_seq_reg_elemento_w	bigint;
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

BEGIN

	if (TG_OP = 'INSERT') or (TG_OP = 'UPDATE') then
		
		select	max(ie_lib_solic_externo)
		into STRICT	ie_lib_solic_externo_w
		from	parametro_medico
		where   cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

		if (coalesce(ie_lib_solic_externo_w,'N') = 'S') then
			if (NEW.dt_liberacao is null) then
				ie_tipo_w := 'PEE';
			elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
				ie_tipo_w := 'XPEE';
			end if;


			if (ie_tipo_w	is not null) then

        CALL Gerar_registro_pendente_PEP(
          cd_tipo_registro_p => ie_tipo_w,
          nr_sequencia_registro_p => NEW.nr_sequencia,
          cd_pessoa_fisica_p => obter_pessoa_atendimento(NEW.nr_atendimento,'C'),
          nr_atendimento_p => NEW.nr_atendimento,
          nm_usuario_p => NEW.nm_usuario,
          ie_tipo_pendencia_p => 'L',
          nr_seq_reg_elemento_p => nr_seq_reg_elemento_w,
          nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
        );
			end if;

			
		end if;
	elsif (TG_OP = 'DELETE') then
		
		delete	from pep_item_pendente
		where 	IE_TIPO_REGISTRO = 'PEE'
		and	nr_seq_registro = OLD.nr_sequencia
		and	coalesce(IE_TIPO_PENDENCIA,'L')	= 'L';
		
	end if;

exception
when others then
	null;
end;

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
-- REVOKE ALL ON FUNCTION trigger_fct_ped_exame_externo_pend_atual() FROM PUBLIC;

CREATE TRIGGER ped_exame_externo_pend_atual
	AFTER INSERT OR UPDATE OR DELETE ON pedido_exame_externo FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ped_exame_externo_pend_atual();

