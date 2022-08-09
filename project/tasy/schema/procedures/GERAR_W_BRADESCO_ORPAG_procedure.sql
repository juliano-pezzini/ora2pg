-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_bradesco_orpag ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w	bigint;
nr_atendimento_w	bigint;

cd_procedimento_w	varchar(15);
qt_procedimento_w	bigint;

ds_proced_w		varchar(4000);

ds_proced1_w		varchar(42);
ds_proced2_w		varchar(42);
ds_proced3_w		varchar(42);

i			integer;

nr_interno_conta_ant_w	bigint := 0;

C01 CURSOR FOR 
	SELECT	nr_atendimento, 
		nr_interno_conta 
	from conta_paciente 
	where nr_seq_protocolo = nr_seq_protocolo_p 
	order by 1,2;

C02 CURSOR FOR 
	SELECT	lpad(coalesce(cd_procedimento_convenio,cd_procedimento), '8', ' '), 
		trunc(qt_procedimento) 
	from procedimento_paciente 
	where nr_interno_conta = nr_interno_conta_w 
	order by 1;
		

BEGIN 
 
delete FROM w_hdh_orpag;
 
open C01;
loop 
	fetch C01 into	nr_atendimento_w, 
			nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
	ds_proced_w	:= '';
	open c02;
	loop 
		fetch c02 into	cd_procedimento_w, 
				qt_procedimento_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
 
		i := 1;
		for i in 1..qt_procedimento_w loop			 
			ds_proced_w := ds_proced_w || cd_procedimento_w || ' 1  ';
		end loop;
 
	end loop;
	close c02;
 
	while length(ds_proced_w) > 0 loop 
		ds_proced1_w := substr(ds_proced_w,1,42);
		ds_proced2_w := substr(ds_proced_w,43,42);
		ds_proced3_w := substr(ds_proced_w,85,42);
		insert into w_hdh_orpag( 
			NR_SEQUENCIA      , 
			NR_SEQ_PROTOCOLO    , 
			NR_ATENDIMENTO     , 
			NR_INTERNO_CONTA    , 
			DS_LINHA1       , 
			DS_LINHA2       , 
			DS_LINHA3       ) 
		values ( 
			nextval('w_hdh_orpag_seq'), 
			nr_seq_protocolo_p, 
			nr_atendimento_w, 
			nr_interno_conta_w, 
			ds_proced1_w, 
			ds_proced2_w, 
			ds_proced3_w);
		ds_proced_w := substr(ds_proced_w,127,length(ds_proced_w));
	end loop;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_bradesco_orpag ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
