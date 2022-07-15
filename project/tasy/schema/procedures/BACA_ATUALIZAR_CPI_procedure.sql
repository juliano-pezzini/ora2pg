-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualizar_cpi () AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
nr_prontuario_w		bigint;
cd_estabelecimento_w	smallint;
nr_sequencia_w		bigint;
nr_controle_w		bigint;

C01 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	a.nr_prontuario
from	pessoa_fisica a
where	(a.nr_prontuario IS NOT NULL AND a.nr_prontuario::text <> '')
and	not exists (	select	1
			from	same_cpi_prontuario b
			where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica);


BEGIN

select	min(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	estabelecimento;

open c01;
loop
	fetch c01 into
		cd_pessoa_fisica_w,
		nr_prontuario_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	select	nextval('same_cpi_prontuario_seq')
	into STRICT	nr_sequencia_w
	;

	insert into same_cpi_prontuario(
		nr_sequencia,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		nr_prontuario,
		cd_pessoa_fisica,
		qt_volume,
		ds_localizacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nr_sequencia_w,
		cd_estabelecimento_w,
		clock_timestamp(),
		'Tasy',
		nr_prontuario_w,
		cd_pessoa_fisica_w,
		1,
		null,
		clock_timestamp(),
		'Tasy');

	nr_controle_w	:= nr_controle_w	+ 1;
	if (nr_controle_w > 5000) then
		nr_controle_w	:= 0;
		commit;
	end if;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualizar_cpi () FROM PUBLIC;

