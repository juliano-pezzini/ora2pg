-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_qua_doc_trein () AS $body$
DECLARE


nr_seq_doc_w		integer;
dt_treinamento_w	timestamp;
cd_pessoa_treinada_w	varchar(10);
qt_minuto_w		bigint;
vl_nota_w		double precision;
nr_seq_treinamento_w	bigint;

c01 CURSOR FOR
	SELECT	distinct nr_seq_doc
	from	qua_doc_trein;

c02 CURSOR FOR
	SELECT	dt_treinamento,
		cd_pessoa_treinada,
		coalesce(qt_minuto,0),
		vl_nota
	from	qua_doc_trein
	where	nr_seq_doc = nr_seq_doc_w;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_doc_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	max(dt_treinamento)
	into STRICT	dt_treinamento_w
	from	qua_doc_trein
	where	nr_seq_doc = nr_seq_doc_w;

	select	nextval('qua_doc_treinamento_seq')
	into STRICT	nr_seq_treinamento_w
	;

	insert into qua_doc_treinamento(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_documento,
		dt_prevista,
		dt_real,
		ds_treinamento,
		qt_tempo_previsto,
		ie_filmagem)
	values (	nr_seq_treinamento_w,
		clock_timestamp(),
		'Baca_Ajuste',
		nr_seq_doc_w,
		dt_treinamento_w,
		dt_treinamento_w,
		'Treinamento padrão',
		0,
		'N');

	open c02;
	loop
	fetch c02 into
		dt_treinamento_w,
		cd_pessoa_treinada_w,
		qt_minuto_w,
		vl_nota_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		insert into qua_doc_trein_pessoa(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_treinamento,
			cd_pessoa_fisica,
			ie_faltou,
			vl_nota)
		values (nextval('qua_doc_trein_pessoa_seq'),
			clock_timestamp(),
			'Baca_Ajuste',
			nr_seq_treinamento_w,
			cd_pessoa_treinada_w,
			'N',
			vl_nota_w);

		update	qua_doc_treinamento
		set	qt_tempo_previsto = qt_minuto_w
		where	nr_sequencia = nr_seq_treinamento_w;

		end;
	end loop;
	close c02;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_qua_doc_trein () FROM PUBLIC;

