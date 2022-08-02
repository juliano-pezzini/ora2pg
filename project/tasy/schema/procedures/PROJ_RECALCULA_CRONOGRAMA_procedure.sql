-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_recalcula_cronograma (nr_seq_cronograma_p bigint) AS $body$
DECLARE


nr_seq_etapa_w  bigint;

c01 CURSOR FOR
 SELECT  nr_sequencia
 from proj_cron_etapa
 where nr_seq_cronograma = nr_seq_cronograma_p
 and coalesce(ie_situacao,'A') = 'A';


BEGIN

open c01;
loop
fetch c01 into nr_seq_etapa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 begin


 CALL Atualizar_Horas_Etapa_Cron(nr_seq_etapa_w);
 end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_recalcula_cronograma (nr_seq_cronograma_p bigint) FROM PUBLIC;

