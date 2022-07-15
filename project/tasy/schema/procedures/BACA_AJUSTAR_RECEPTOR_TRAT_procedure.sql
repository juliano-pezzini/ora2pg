-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_receptor_trat ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_receptor_w		bigint;
nr_seq_tratamento_w	bigint;
c01 CURSOR FOR
	SELECT 	distinct
		a.nr_sequencia,
		b.nr_sequencia
	from	tx_receptor a,
		paciente_tratamento b
	where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and	b.ie_tratamento in ('TR','TX','PT')
	and	coalesce(b.nr_seq_receptor::text, '') = '';


BEGIN

open C01;
loop
	fetch C01 into	nr_seq_receptor_w,
			nr_seq_tratamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

	update 	paciente_tratamento
	set	nr_seq_receptor = nr_seq_receptor_w
	where	ie_tratamento in ('TR','TX','PT')
	and	nr_sequencia = nr_seq_tratamento_w;

	end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_receptor_trat ( nm_usuario_p text) FROM PUBLIC;

