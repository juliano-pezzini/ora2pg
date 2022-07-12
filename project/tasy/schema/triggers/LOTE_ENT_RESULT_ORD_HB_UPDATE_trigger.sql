-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS lote_ent_result_ord_hb_update ON lote_ent_result_ord_hb CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_lote_ent_result_ord_hb_update() RETURNS trigger AS $BODY$
declare
nr_prescricao_w		bigint;
nr_seq_resultado_w	bigint;
nr_seq_prescr_w		bigint;
nr_seq_exame_w		bigint;
ie_formato_result_w	varchar(3);
BEGIN

select	MAX(a.nr_seq_exame),
		MAX(a.nr_sequencia),
		max(a.nr_prescricao),
		max(e.ie_formato_resultado)
into STRICT	nr_seq_exame_w,
		nr_seq_prescr_w,
		nr_prescricao_w,
		ie_formato_result_w
from   	exame_laboratorio e,
		lote_ent_sec_ficha c,
		prescr_medica d,
		prescr_procedimento a
where  	a.nr_prescricao = d.nr_prescricao
and		a.nr_seq_exame = e.nr_seq_exame
and		d.nr_prescricao = c.nr_prescricao
and		a.cd_motivo_baixa = 0
and		a.ie_status_atend = 30
and		c.cd_barras = NEW.cd_barras
and		coalesce(coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'PERKINS'),e.cd_exame_integracao),e.cd_exame) = NEW.cd_exame;

if (nr_prescricao_w is not null) then
	select 	max(nr_seq_resultado)
	into STRICT	nr_seq_resultado_w
	from	exame_lab_resultado
	where	nr_prescricao = nr_prescricao_w;

	if (substr(ie_formato_result_w,1,1) = 'V') then
		update	exame_lab_result_item
		set		qt_resultado = NEW.ds_resultado,
				dt_atualizacao = LOCALTIMESTAMP,
				nm_usuario = NEW.nm_usuario
		where	nr_seq_resultado = nr_seq_resultado_w
		and		nr_seq_prescr = nr_seq_prescr_w;

	elsif (substr(ie_formato_result_w,1,1) = 'D') then
		update	exame_lab_result_item
		set		ds_resultado = NEW.ds_resultado,
				dt_atualizacao = LOCALTIMESTAMP,
				nm_usuario = NEW.nm_usuario
		where	nr_seq_resultado = nr_seq_resultado_w
		and		nr_seq_prescr = nr_seq_prescr_w;

	end if;
end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_lote_ent_result_ord_hb_update() FROM PUBLIC;

CREATE TRIGGER lote_ent_result_ord_hb_update
	BEFORE UPDATE ON lote_ent_result_ord_hb FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_lote_ent_result_ord_hb_update();
