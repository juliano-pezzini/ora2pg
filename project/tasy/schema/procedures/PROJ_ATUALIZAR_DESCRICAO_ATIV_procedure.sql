-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_atualizar_descricao_ativ (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_cronograma_w	bigint;

C02 CURSOR FOR
SELECT	nr_sequencia
from	proj_cron_etapa
where	nr_seq_cronograma = nr_seq_cronograma_w
order by 1;


BEGIN

select	max(nr_seq_cronograma)
into STRICT	nr_seq_cronograma_w
from	proj_cron_etapa
where	nr_sequencia = nr_sequencia_p
order by 1;

open C02;
loop
fetch C02 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	CALL proj_atualizar_desc_atividade(nr_sequencia_w);
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_atualizar_descricao_ativ (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
