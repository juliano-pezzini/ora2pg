-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_fases_pend_prot_radio (nr_seq_tratamento_p bigint) RETURNS bigint AS $body$
DECLARE



qt_fases_pendentes_prot_w bigint := 0;
nr_seq_volume_trat_w bigint;
qt_fase_pend_volume bigint;

c01 CURSOR FOR
	SELECT nr_sequencia
	from rxt_volume_tratamento
	where nr_seq_tratamento = nr_seq_tratamento_p;


BEGIN

if (nr_seq_tratamento_p IS NOT NULL AND nr_seq_tratamento_p::text <> '') then

open c01;
	loop
	fetch c01 into nr_seq_volume_trat_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select count(*)
		into STRICT qt_fase_pend_volume
		from rxt_fase_tratamento
		where coalesce(dt_lib_seg_fisico::text, '') = ''
		and coalesce(dt_aprovacao_medico::text, '') = ''
		and nr_seq_volume_tratamento = nr_seq_volume_trat_w;
		
		qt_fases_pendentes_prot_w := qt_fases_pendentes_prot_w + qt_fase_pend_volume;
		
		end;
	end loop;
	close c01;

end if;

return	qt_fases_pendentes_prot_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_fases_pend_prot_radio (nr_seq_tratamento_p bigint) FROM PUBLIC;
