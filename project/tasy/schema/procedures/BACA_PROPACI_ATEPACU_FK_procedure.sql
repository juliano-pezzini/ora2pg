-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_propaci_atepacu_fk () AS $body$
DECLARE


qt_columns_w		bigint;

nr_atendimento_w	bigint;
dt_entrada_unidade_w	timestamp;

nr_sequencia_w		bigint;
nr_seq_atepacu_w	bigint;
i			bigint;

c01 CURSOR FOR
	SELECT	nr_atendimento,
		dt_entrada_unidade
	from atend_paciente_unidade
	where coalesce(nr_seq_interno::text, '') = '';

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade
	from procedimento_paciente
	where coalesce(nr_seq_atepacu::text, '') = ''
	
union

	SELECT	nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade
	from procedimento_paciente a
	where (nr_seq_atepacu IS NOT NULL AND nr_seq_atepacu::text <> '')
	  and not exists (select 1 from atend_paciente_unidade x
				where x.nr_seq_interno = a.nr_seq_atepacu);

c03 CURSOR FOR
	SELECT nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade
	from material_atend_paciente
	where coalesce(nr_seq_atepacu::text, '') = ''
	
union

	SELECT nr_sequencia,
		nr_atendimento,
		dt_entrada_unidade
	from material_atend_paciente a
	where (nr_seq_atepacu IS NOT NULL AND nr_seq_atepacu::text <> '')
	  and not exists (select 1 from atend_paciente_unidade x
				where x.nr_seq_interno = a.nr_seq_atepacu);


BEGIN

select	count(*)
into STRICT	qt_columns_w
from user_cons_columns
where constraint_name = 'PROPACI_ATEPACU_FK';

if (qt_columns_w = 2) then
	i := 0;
	open c01;
	loop
		fetch C01 into	nr_atendimento_w,
				dt_entrada_unidade_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

		i := i + 1;
		update atend_paciente_unidade
		set nr_seq_interno = nextval('atend_paciente_unidade_seq')
		where nr_atendimento		= nr_atendimento_w
		  and dt_entrada_unidade	= dt_entrada_unidade_w;
	end loop;
	close c01;
	/*insert into logxxxx_tasy values (sysdate, 'Baca', 12345, 'Geração seq interno: ' || i);*/

	RAISE NOTICE '% %', substr(wheb_mensagem_pck.get_texto(303084),1,255), i;
	commit;

	i := 0;
	open c02;
	loop
		fetch C02 into	nr_sequencia_w,
				nr_atendimento_w,
				dt_entrada_unidade_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */

		i := i + 1;
		select	nr_seq_interno
		into STRICT	nr_seq_atepacu_w
		from atend_paciente_unidade
		where nr_atendimento		= nr_atendimento_w
		  and dt_entrada_unidade	= dt_entrada_unidade_w;

		update procedimento_paciente
		set nr_seq_atepacu = nr_seq_atepacu_w
		where nr_sequencia = nr_sequencia_w;
	end loop;
	close c02;
	/*insert into logxxxx_tasy values (sysdate, 'Baca', 12345, 'Acerto de NR_SEQ_ATEPACU em PROCEDIMENTO_PACIENTE: ' || i);*/

	RAISE NOTICE '% %', substr(wheb_mensagem_pck.get_texto(303086),1,255), i;
	commit;

	i := 0;
	open c03;
	loop
		fetch C03 into	nr_sequencia_w,
				nr_atendimento_w,
				dt_entrada_unidade_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */

		i := i + 1;
		select	nr_seq_interno
		into STRICT	nr_seq_atepacu_w
		from atend_paciente_unidade
		where nr_atendimento		= nr_atendimento_w
		  and dt_entrada_unidade	= dt_entrada_unidade_w;

		update material_atend_paciente
		set nr_seq_atepacu = nr_seq_atepacu_w
		where nr_sequencia = nr_sequencia_w;
	end loop;
	close c03;
	/*insert into logxxxx_tasy values (sysdate, 'Baca', 12345, 'Acerto de NR_SEQ_ATEPACU em MATERIAL_ATEND_PACIENTE: ' || i);*/

	RAISE NOTICE '% %', substr(wheb_mensagem_pck.get_texto(303091),1,255), i;
	commit;

	CALL Exec_SQL_Dinamico('DROP ATEPACU_UK','alter table atend_paciente_unidade drop constraint atepacu_uk');
	CALL Exec_SQL_Dinamico('DROP ATEPACU_I4','drop index atepacu_i4');
	CALL Exec_SQL_Dinamico('CREATE ATEPACU_UK','ALTER TABLE ATEND_PACIENTE_UNIDADE
				ADD (CONSTRAINT ATEPACU_UK Unique (NR_SEQ_INTERNO) USING INDEX Tablespace TASY_INDEX)');
	CALL Exec_SQL_Dinamico('DROP PROPACI_ATEPACU_UK','alter table procedimento_paciente drop constraint PROPACI_ATEPACU_FK');
	CALL Exec_SQL_Dinamico('CREATE PROPACI_ATEPACU_UK','alter TABLE procedimento_paciente
				ADD (CONSTRAINT PROPACI_ATEPACU_FK FOREIGN KEY (NR_SEQ_ATEPACU) REFERENCES ATEND_PACIENTE_UNIDADE (NR_SEQ_INTERNO))');
	CALL Exec_SQL_Dinamico('DROP MATPACI_ATEPACU_UK','alter table material_atend_paciente drop constraint MATPACI_ATEPACU_FK');
	CALL Exec_SQL_Dinamico('DROP MATPACI_ATEPACU_UK','alter TABLE material_atend_paciente
				ADD (CONSTRAINT MATPACI_ATEPACU_FK FOREIGN KEY (NR_SEQ_ATEPACU) REFERENCES ATEND_PACIENTE_UNIDADE (NR_SEQ_INTERNO))');

	select	count(*)
	into STRICT	qt_columns_w
	from user_cons_columns
	where constraint_name = 'ATEPACU_UK';
	/*insert into logxxxx_tasy values (sysdate, 'Baca', 12345, 'Acerto ATEPACU_UK: ' || qt_columns_w);*/

	select	count(*)
	into STRICT	qt_columns_w
	from user_cons_columns
	where constraint_name = 'PROPACI_ATEPACU_FK';
	/*insert into logxxxx_tasy values (sysdate, 'Baca', 12345, 'Acerto PROPACI_ATEPACU_UK: ' || qt_columns_w);*/

	select	count(*)
	into STRICT	qt_columns_w
	from user_cons_columns
	where constraint_name = 'MATPACI_ATEPACU_FK';
	/*insert into logxxxxx_tasy values (sysdate, 'Baca', 12345, 'Acerto MATPACI_ATEPACU_UK: ' || qt_columns_w);*/

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_propaci_atepacu_fk () FROM PUBLIC;
