-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comunic_etapa () AS $body$
DECLARE

 
nr_seq_etapa_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_gerado_w		varchar(2000);

c01 CURSOR FOR 
	SELECT	nr_sequencia, 
		nr_seq_contrato 
	into STRICT	nr_seq_etapa_w, 
		nr_seq_contrato_w 
	from	contrato_etapa 
	where	dt_prevista = trunc(clock_timestamp(),'dd') + 1;


BEGIN 
	 
	open c01;
	loop 
	fetch c01 into	 
		nr_seq_etapa_w, 
		nr_seq_contrato_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		nr_seq_gerado_w := con_enviar_comunic_etapa(nr_seq_etapa_w, nr_seq_contrato_w, '', 'Tasy', nr_seq_gerado_w);
		end;
	end loop;
	close c01;
 
	commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comunic_etapa () FROM PUBLIC;
