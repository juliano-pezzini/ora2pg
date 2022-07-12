-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_reserva_prod_delete ON san_reserva_prod CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_reserva_prod_delete() RETURNS trigger AS $BODY$
declare
nr_prescricao_w san_reserva_item.nr_prescricao%type;
nr_seq_procedimento_w san_reserva_item.nr_seq_prescr%type;
nr_seq_horario_w prescr_proc_bolsa.nr_seq_horario%type;
nm_usuario_w san_reserva_item.nm_usuario%type;
pragma autonomous_transaction;

BEGIN

select  max(b.nr_prescricao),
		max(b.nr_seq_prescr),
		max(b.nm_usuario)
into STRICT	nr_prescricao_w,
		nr_seq_procedimento_w,
		nm_usuario_w
from 	san_reserva a,
		san_reserva_item b
where 	a.nr_sequencia = b.nr_seq_reserva
and 	a.nr_sequencia = OLD.nr_seq_reserva;

select 	max(nr_sequencia)
into STRICT	nr_seq_horario_w
from 	prescr_proc_hor
where 	nr_prescricao = nr_prescricao_w
and		nr_seq_procedimento = nr_seq_procedimento_w
and		coalesce(ie_aprazado, 'N') = 'S';

CALL Deletar_registro_ISBT(nr_prescricao_w, nr_seq_procedimento_w, null, nm_usuario_w, nr_seq_horario_w);

if (nr_seq_horario_w is not null) then
	CALL suspender_prescr_proc_hor(nr_seq_horario_w, nm_usuario_w);
end if;

RETURN OLD;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_reserva_prod_delete() FROM PUBLIC;

CREATE TRIGGER san_reserva_prod_delete
	BEFORE DELETE ON san_reserva_prod FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_reserva_prod_delete();
