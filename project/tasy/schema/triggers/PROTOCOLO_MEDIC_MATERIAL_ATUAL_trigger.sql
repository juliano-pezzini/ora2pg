-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_medic_material_atual ON protocolo_medic_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_medic_material_atual() RETURNS trigger AS $BODY$
declare
BEGIN
  BEGIN
BEGIN

if (obter_se_prot_lib_regras = 'S') then
	update	protocolo_medicacao
	set	nm_usuario_aprov	 = NULL,
		dt_aprovacao		 = NULL,
		ie_status		=	'PA'
	where	cd_protocolo		=	NEW.cd_protocolo
	and	nr_sequencia		=	NEW.nr_sequencia;
end if;


if (NEW.nr_seq_interno is null) then
	select	nextval('protocolo_medic_material_seq')
	into STRICT	NEW.nr_seq_interno
	;
end if;

if (obter_dados_material_estab(	NEW.cd_material,
					wheb_usuario_pck.get_cd_estabelecimento,
					'PR')	= 'N') and (Obter_Tipo_Material(NEW.cd_material,'C') <> '6') then -- 6 = Medicamento sem apresentação
	-- O material/medicamento não pode ser prescrito. Verifique cadastro do material.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264645);
end if;

if (NEW.hr_dose_especial is not null) and ((NEW.hr_dose_especial <> OLD.hr_dose_especial) or (OLD.dt_dose_especial is null)) then
	NEW.dt_dose_especial := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_dose_especial,'dd/mm/yyyy hh24:mi');
end if;
if (NEW.hr_prim_horario is not null) and ((NEW.hr_prim_horario <> OLD.hr_prim_horario) or (OLD.dt_prim_horario is null)) then
	NEW.dt_prim_horario := to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || NEW.hr_prim_horario,'dd/mm/yyyy hh24:mi');
end if;
exception
	when others then
	null;
end;

  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_medic_material_atual() FROM PUBLIC;

CREATE TRIGGER protocolo_medic_material_atual
	BEFORE INSERT OR UPDATE ON protocolo_medic_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_medic_material_atual();

