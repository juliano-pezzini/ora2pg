-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE repetir_proxima_escala ( nm_usuario_p text, nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_escala_w		bigint;
cd_pessoa_fisica_w	varchar(10);
cd_pessoa_origem_w	varchar(10);
ds_observacao_w		varchar(255);
ie_feriado_w		varchar(1);
qt_min_executado_w	bigint;
cd_cbo_sus_w		integer;
nr_seq_motivo_afast_w	bigint;
nr_ordem_escala_w		bigint;
cd_pessoa_fisica_ww	varchar(15);
nr_seq_classif_escala_w	bigint;
qt_min_executado_ww	bigint;
nr_ordem_escala_ww	bigint;
qt_escala_diaria_adic_w	bigint;

c01 CURSOR FOR
SELECT	cd_pessoa_fisica,
	nr_seq_classif_escala,
	qt_min_executado,
	nr_ordem_escala
from	escala_diaria_adic
where	nr_seq_escala_diaria = nr_sequencia_p;


BEGIN
select	nr_seq_escala,
	cd_pessoa_fisica,
	cd_pessoa_origem,
	ds_observacao,
	ie_feriado,
	qt_min_executado,
	cd_cbo_sus,
	nr_seq_motivo_afast,
	nr_ordem_escala
into STRICT	nr_seq_escala_w,
	cd_pessoa_fisica_w,
	cd_pessoa_origem_w,
	ds_observacao_w,
	ie_feriado_w,
	qt_min_executado_w,
	cd_cbo_sus_w,
	nr_seq_motivo_afast_w,
	nr_ordem_escala_w
from	escala_diaria
where	nr_sequencia = nr_sequencia_p;

select	nextval('escala_diaria_seq')
into STRICT	nr_sequencia_w
;

insert	into 	escala_diaria(	nr_sequencia,
				nr_seq_escala,
				dt_atualizacao,
				nm_usuario,
				cd_pessoa_fisica,
				dt_inicio,
				dt_fim,
				cd_pessoa_origem,
				ds_observacao,
				ie_feriado,
				qt_min_executado,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_cbo_sus,
				nr_seq_motivo_afast,
				nr_ordem_escala)
			values (	nr_sequencia_w,
				nr_seq_escala_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_fisica_w,
				dt_inicio_p,
				dt_fim_p,
				cd_pessoa_origem_w,
				ds_observacao_w,
				ie_feriado_w,
				qt_min_executado_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_cbo_sus_w,
				nr_seq_motivo_afast_w,
				nr_ordem_escala_w);

select	count(*)
into STRICT	qt_escala_diaria_adic_w
from	escala_diaria_adic
where	nr_seq_escala_diaria = nr_sequencia_p;

if (qt_escala_diaria_adic_w > 0) then
	begin
	open c01;
	loop
	fetch c01 into
		cd_pessoa_fisica_ww,
		nr_seq_classif_escala_w,
		qt_min_executado_ww,
		nr_ordem_escala_ww;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		insert	into	escala_diaria_adic(nr_sequencia,
				nr_seq_escala_diaria,
				dt_atualizacao,
				nm_usuario,
				cd_pessoa_fisica,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_classif_escala,
				qt_min_executado,
				nr_ordem_escala)
			values (nextval('escala_diaria_adic_seq'),
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_pessoa_fisica_ww,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_classif_escala_w,
				qt_min_executado_ww,
				nr_ordem_escala_ww);
	end loop;
	close c01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE repetir_proxima_escala ( nm_usuario_p text, nr_sequencia_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

