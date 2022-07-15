-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_confidencias () AS $body$
DECLARE


nr_seq_consulta_w	bigint;
nr_seq_cliente_w	bigint;
nr_atendimento_w	bigint;
ds_consulta_w		text;
dt_atualizacao_w	timestamp;
nm_usuario_w		varchar(15);
ds_erro_w		varchar(2000);
qt_contador_w		bigint := 0;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_cliente,
		a.nr_atendimento,
		a.ds_consulta,
		a.dt_atualizacao,
		a.nm_usuario
	from	med_consulta a
	where	a.ie_tipo_consulta = 7
	and	(a.ds_consulta IS NOT NULL AND a.ds_consulta::text <> '')
	and	not exists (	SELECT	1
				from	med_confidencia b
				where	b.nr_seq_consulta = a.nr_sequencia)
	order by	a.nr_seq_cliente;


BEGIN

open	c01;
loop
fetch	c01 into
	nr_seq_consulta_w,
	nr_seq_cliente_w,
	nr_atendimento_w,
	ds_consulta_w,
	dt_atualizacao_w,
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	qt_contador_w	:= qt_contador_w + 1;

	begin
	insert into med_confidencia(
		nr_sequencia,
		nr_seq_cliente,
		nr_atendimento,
		dt_confidencia,
		ds_confidencia,
		nr_seq_consulta,
		dt_atualizacao,
		nm_usuario)
	values (
		nextval('med_confidencia_seq'),
		nr_seq_cliente_w,
		nr_atendimento_w,
		dt_atualizacao_w,
		ds_consulta_w,
		nr_seq_consulta_w,
		dt_atualizacao_w,
		nm_usuario_w);
	exception
		when others then
			ds_erro_w	:= substr(SQLERRM(SQLSTATE),1,1800);
			/*insert into logxxx_tasy values (sysdate,'TasyMed',4,'TasyMed - Confidências: ' || ds_erro_w || ' - Seq: ' || nr_seq_consulta_w || ' - Atend: ' || nr_atendimento_w || ' - Cliente: ' || nr_seq_cliente_w);*/

			commit;
	end;

	if (qt_contador_w = 500) then
		begin
		qt_contador_w	:= 0;
		commit;
		end;
	end if;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_confidencias () FROM PUBLIC;

