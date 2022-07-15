-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comunic_iniciativa_bsc () AS $body$
DECLARE

 
nr_seq_obj_w			bigint;
nr_seq_iniciativa_w		bigint;
qt_possui_regra_w		bigint;
dt_conclusao_desejada_w	timestamp;
qt_dias_aviso_w			bigint;
nm_usuario_job_w		varchar(15);

C01 CURSOR FOR 
SELECT	a.nr_sequencia 
from	ple_objetivo a;

C02 CURSOR FOR 
SELECT	a.nr_sequencia,	 
		dt_conclusao_desejada 
from	man_ordem_servico a 
where	a.nr_seq_obj_bsc = nr_seq_obj_w 
and		coalesce(dt_fim_real::text, '') = '';	
 

BEGIN 
select	count(*) 
into STRICT	qt_possui_regra_w 
from	bsc_regra_envio_ci 
where	ie_evento = 'AD';
 
 
if (qt_possui_regra_w > 0) then 
 
	open C01;
	loop 
	fetch C01 into 
		nr_seq_obj_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		open C02;
		loop 
			fetch C02 into 
			nr_seq_iniciativa_w, 
			dt_conclusao_desejada_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			select	max(coalesce(qt_dias_aviso,0)), 
					max(nm_usuario_job) 
			into STRICT	qt_dias_aviso_w, 
					nm_usuario_job_w 
			from	bsc_regra_envio_ci 
			where	ie_evento = 'AD';
			 
			if (trunc(dt_conclusao_desejada_w - qt_dias_aviso_w) between trunc(clock_timestamp() - qt_dias_aviso_w) and trunc(clock_timestamp())) then 
				CALL gerar_comunic_iniciativa('AD',nr_seq_obj_w,nr_seq_iniciativa_w,nm_usuario_job_w);
			end if;
			end;
		end loop;
		close C02;
		 
		end;
	end loop;
	close C01;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comunic_iniciativa_bsc () FROM PUBLIC;

