-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS prescr_proc_material_aftupdate ON prescr_proc_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_prescr_proc_material_aftupdate() RETURNS trigger AS $BODY$
declare
ds_guampa_w varchar(10) := chr(39);
is_volume_selected  varchar(1);
is_active   varchar(1);
nr_urine_count  bigint;
qt_actual_volume    double precision;

BEGIN
select  ie_volume_tempo,
        ie_situacao
into STRICT    is_volume_selected,
        is_active
from    material_exame_lab
where   nr_sequencia = NEW.nr_seq_material;

select  count(*)
into STRICT    nr_urine_count
from    material_exame_lab_int
where   nr_seq_material = NEW.nr_seq_material
and     cd_equipamento = '63'
and     lower(cd_material_integracao) = 'urina';

if ((coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') and (is_volume_selected = 'S' and is_active = 'A' and nr_urine_count > 0 and NEW.qt_volume > 0)) then
    CALL call_interface_file(928, 'itech_pck.send_urine_info('||ds_guampa_w|| NEW.nr_prescricao ||ds_guampa_w||','||ds_guampa_w|| NEW.nr_seq_int_prescr ||ds_guampa_w||','||ds_guampa_w||NEW.nm_usuario||ds_guampa_w||','||ds_guampa_w||0||ds_guampa_w||','||ds_guampa_w||null||ds_guampa_w||','||obter_estabelecimento_ativo||');', NEW.nm_usuario);
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_prescr_proc_material_aftupdate() FROM PUBLIC;

CREATE TRIGGER prescr_proc_material_aftupdate
	AFTER UPDATE ON prescr_proc_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_prescr_proc_material_aftupdate();
