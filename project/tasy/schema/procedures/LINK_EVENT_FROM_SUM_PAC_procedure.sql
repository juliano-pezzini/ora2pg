-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE link_event_from_sum_pac (nr_seq_etapa_p bigint, nr_dia_inicial_p bigint, nr_dia_final_p bigint, nr_ordem_inicial_p bigint, nr_ordem_final_p bigint, nr_seq_protocolo_integrado_p bigint, ie_reset_records_p bigint) AS $body$
DECLARE


nr_seq_summary_w 	bigint;

c01 CURSOR FOR
SELECT * from (
  SELECT 	nr_sequencia, nr_dia_protocolo, nr_seq_ordem
  from	protocolo_int_pac_evento
  where nr_dia_protocolo between nr_dia_inicial_p and nr_dia_final_p
  and nr_sequencia(select ev.nr_sequencia
  from protocolo_int_pac_evento ev,
  protocolo_int_pac_etapa et
  where ev.nr_seq_prt_int_pac_etapa = et.nr_sequencia
  and coalesce(et.ie_evento_sumario,'N') = 'S'
  and et.nr_seq_protocolo_int_pac = nr_seq_protocolo_integrado_p)
) a;

BEGIN

if (ie_reset_records_p = 1) then

  select max(nr_sequencia)
  into STRICT nr_seq_summary_w
  from protocolo_int_pac_etapa
  where nr_seq_protocolo_int_pac = nr_seq_protocolo_integrado_p
  and coalesce(ie_evento_sumario,'N') = 'S';

  if (nr_seq_summary_w > 0) then

    update protocolo_int_pac_evento
    set nr_seq_prt_int_pac_etapa = nr_seq_summary_w
    where nr_seq_prt_int_pac_etapa = nr_seq_etapa_p;

  end if;

end if;

for c01_w in c01 loop

  if ((nr_dia_inicial_p = nr_dia_final_p
  and c01_w.nr_seq_ordem >= nr_ordem_inicial_p and c01_w.nr_seq_ordem <= nr_ordem_final_p) 
  or (nr_dia_inicial_p <> nr_dia_final_p 
  and ((c01_w.nr_dia_protocolo = nr_dia_inicial_p and c01_w.nr_seq_ordem >= nr_ordem_inicial_p)
  or (c01_w.nr_dia_protocolo = nr_dia_final_p and c01_w.nr_seq_ordem <= nr_ordem_final_p)
  or (c01_w.nr_dia_protocolo > nr_dia_inicial_p and c01_w.nr_dia_protocolo < nr_dia_final_p)))) then

    update protocolo_int_pac_evento
    set nr_seq_prt_int_pac_etapa = nr_seq_etapa_p
    where nr_sequencia = c01_w.nr_sequencia;

  end if;

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE link_event_from_sum_pac (nr_seq_etapa_p bigint, nr_dia_inicial_p bigint, nr_dia_final_p bigint, nr_ordem_inicial_p bigint, nr_ordem_final_p bigint, nr_seq_protocolo_integrado_p bigint, ie_reset_records_p bigint) FROM PUBLIC;
