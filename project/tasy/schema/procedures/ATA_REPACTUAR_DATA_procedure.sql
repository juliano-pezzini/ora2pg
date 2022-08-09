-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ata_repactuar_data ( nm_usuario_p text, nr_sequencia_p bigint, dt_repactuada_p timestamp) AS $body$
DECLARE


nr_seq_ordem_w			bigint;
dt_atu_prev_solucao_w		timestamp;
dt_prev_solucao_w		timestamp;
nr_seq_classif_reuniao_w	bigint := 0;


BEGIN

select	max(x.nr_seq_ordem)		
into STRICT	nr_seq_ordem_w		
from	proj_ata_pendencia_os x
where	x.nr_seq_pendencia = nr_sequencia_p;

select	a.dt_atu_prev_solucao,
		a.dt_prev_solucao,
		c.nr_seq_classif_reuniao		
into STRICT	dt_atu_prev_solucao_w,
		dt_prev_solucao_w,
		nr_seq_classif_reuniao_w
from	proj_ata_pendencia a,
		proj_ata b,
		ata_reuniao c
where	a.nr_seq_ata = b.nr_sequencia
and 	b.nr_seq_reuniao = c.nr_sequencia					
and 	a.nr_sequencia = nr_sequencia_p;


-- Na primeira  vez que repactuar, atualiza a data de previsão da solução coma nova data e guarda a primeira data prevista num campo auxiliar . Após isto começa a contar como repactuada

--nr_seq_classif_reuniao_w = 3	Análise Crítica / Business Review

--nr_seq_classif_reuniao_w = 43	QBR Meeting

--nr_seq_classif_reuniao_w = 62 ISMS Review
if (((obter_se_base_corp = 'S' or obter_se_base_wheb = 'S') AND (nr_seq_classif_reuniao_w = 62
		or nr_seq_classif_reuniao_w = 3 or nr_seq_classif_reuniao_w = 43))
			and coalesce(dt_atu_prev_solucao_w::text, '') = ''
			and trunc(clock_timestamp()) <= dt_prev_solucao_w) then
	
		update	proj_ata_pendencia a
		set		a.dt_atu_prev_solucao	= dt_prev_solucao_w,
				a.dt_prev_solucao		= dt_repactuada_p, 		
				a.nm_usuario			= nm_usuario_p
		where	a.nr_sequencia			= nr_sequencia_p;
else

	update	proj_ata_pendencia a
	set		a.dt_repactuada	= dt_repactuada_p,
			a.nm_usuario	= nm_usuario_p
	where	a.nr_sequencia	= nr_sequencia_p;	
end if;

update	man_ordem_servico a
set		a.dt_fim_previsto	= dt_repactuada_p,
		a.nm_usuario		= nm_usuario_p
where	a.nr_sequencia		= nr_seq_ordem_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ata_repactuar_data ( nm_usuario_p text, nr_sequencia_p bigint, dt_repactuada_p timestamp) FROM PUBLIC;
