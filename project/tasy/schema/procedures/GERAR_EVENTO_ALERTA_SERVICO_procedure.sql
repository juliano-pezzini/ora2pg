-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_alerta_servico (cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_evento_w			bigint;
nr_seq_unidade_w		bigint;	
qt_evento_servico_w		bigint;
dt_log_w			timestamp;		
			 
C01 CURSOR FOR 
	SELECT	nr_seq_unidade 
	from	sl_unid_atend 
	where	dt_atualizacao_nrec > coalesce(dt_log_w,clock_timestamp());

C02 CURSOR FOR 
	SELECT	nr_seq_evento 
	from	regra_envio_sms 
	where	cd_estabelecimento	= 1 
	and	ie_evento_disp 		= 'GEIN' 
	and	coalesce(ie_situacao,'A') = 'A';


BEGIN 
 
select	max(dt_atualizacao) 
into STRICT	dt_log_w 
from	log_tasy 
where	cd_log = 1504;
 
 
select	count(*) 
into STRICT	qt_evento_servico_w 
from	sl_unid_atend 
where	dt_atualizacao_nrec > coalesce(dt_log_w,clock_timestamp());
	 
if (qt_evento_servico_w > 0) then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_unidade_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		open c02;
		loop 
		fetch c02 into	 
			nr_seq_evento_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin			 
			CALL gerar_evento_paciente(nr_seq_evento_w,null,null,null,nm_usuario_p,null,null,null,null,null,null,null,null,null,null,'N',nr_seq_unidade_w);
			end;
		end loop;
		close c02;
		 
		end;
	end loop;
	close C01;
 
/*	insert	into log_XXtasy (dt_atualizacao, 
				nm_usuario, 
				cd_log, 
				ds_log) 
			values (sysdate, 
				nm_usuario_p, 
				1504, 
				substr('Evento: '|| nr_seq_evento_w || ' - Unidade: '|| nr_seq_unidade_w,1,100));  */
 
end if;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_alerta_servico (cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
