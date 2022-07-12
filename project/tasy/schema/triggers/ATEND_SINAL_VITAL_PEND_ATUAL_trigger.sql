-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_sinal_vital_pend_atual ON atendimento_sinal_vital CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_sinal_vital_pend_atual() RETURNS trigger AS $BODY$
declare

qt_reg_w		smallint;
ie_tipo_w		varchar(10);
ie_lib_sinal_vital_w	varchar(10);
nr_seq_reg_elemento_w	bigint;
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;

select	max(ie_lib_sinal_vital)
into STRICT	ie_lib_sinal_vital_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

nr_seq_reg_elemento_w	:= NEW.nr_seq_reg_elemento;

if (coalesce(ie_lib_sinal_vital_w,'N') = 'S') then
	if (NEW.dt_liberacao is null) then
		ie_tipo_w := 'SV';
	elsif (OLD.dt_liberacao is null) and (NEW.dt_liberacao is not null) then
		ie_tipo_w := 'XSV';
	end if;

	BEGIN
	if (ie_tipo_w	is not null) then
		
    CALL Gerar_registro_pendente_PEP(
      cd_tipo_registro_p => ie_tipo_w,
      nr_sequencia_registro_p => NEW.nr_sequencia,
      cd_pessoa_fisica_p => NEW.cd_paciente,
      nr_atendimento_p => NEW.nr_atendimento, 
      nm_usuario_p => NEW.nm_usuario,
      ie_tipo_pendencia_p => 'L',
      nr_seq_reg_elemento_p => nr_seq_reg_elemento_w,
      nr_atend_cons_pepa_p=> NEW.nr_seq_atend_cons_pepa
    );

	end if;
	exception
		when others then
		null;
	end;
	
end if;

<<Final>>
qt_reg_w	:= 0;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_sinal_vital_pend_atual() FROM PUBLIC;

CREATE TRIGGER atend_sinal_vital_pend_atual
	AFTER INSERT OR UPDATE ON atendimento_sinal_vital FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_sinal_vital_pend_atual();

