-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_dcb_insert () AS $body$
DECLARE


cd_dcb_w		varchar(20);
nr_sequencia_w		bigint;
nr_seq_dcb_w		bigint;
nr_seq_medic_contro_w	bigint;
nr_max_seq_w		bigint;
cd_dcb_novo_w		varchar(20);

C01 CURSOR FOR
	SELECT	b.cd_dcb,
		b.nr_sequencia,
		a.nr_sequencia
	from	dcb_medic_controlado b,
		medic_controlado a
	where	(a.nr_seq_dcb IS NOT NULL AND a.nr_seq_dcb::text <> '')
	and	a.nr_seq_dcb = b.nr_sequencia;

C02 CURSOR FOR
	SELECT	b.cd_dcb,
		b.nr_sequencia,
		a.nr_sequencia
	from	dcb_medic_controlado b,
		medic_ficha_tecnica a
	where	(a.nr_seq_dcb IS NOT NULL AND a.nr_seq_dcb::text <> '')
	and	a.nr_seq_dcb = b.nr_sequencia;

BEGIN

update	dcb_medic_controlado
set	cd_versao	= 1996;

commit;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_max_seq_w
from	dcb_medic_controlado;

insert into dcb_medic_controlado(
	nr_sequencia,
	cd_dcb,
	ds_dcb,
	dt_atualizacao,
	nm_usuario,
	cd_antigo,
	cd_cas,
	ie_situacao,
	cd_versao)
SELECT	nr_max_seq_w + row_number() OVER () AS rownum,
	cd_dcb_novo,
	ds_dcb,
	clock_timestamp(),
	'Tasy',
	cd_dcb_antigo,
	cd_registro_cas,
	'A',
	2003
from	export_dcb;

commit;


OPEN C01;
LOOP
FETCH C01 into
		cd_dcb_w,
		nr_sequencia_w,
		nr_seq_medic_contro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	coalesce(max(cd_dcb),cd_dcb_w),
		coalesce(max(nr_sequencia),nr_sequencia_w)
	into STRICT	cd_dcb_novo_w,
		nr_seq_dcb_w
	from	dcb_medic_controlado
	where	cd_antigo = cd_dcb_w;

	update	medic_controlado a
	set	a.nr_seq_dcb = nr_seq_dcb_w
	where	nr_sequencia = nr_seq_medic_contro_w;

END LOOP;
Close C01;


OPEN C02;
LOOP
FETCH C02 into
		cd_dcb_w,
		nr_sequencia_w,
		nr_seq_medic_contro_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	select	coalesce(max(cd_dcb),cd_dcb_w),
		coalesce(max(nr_sequencia),nr_sequencia_w)
	into STRICT	cd_dcb_novo_w,
		nr_seq_dcb_w
	from	dcb_medic_controlado
	where	cd_antigo = cd_dcb_w;

	update	medic_ficha_tecnica a
	set	a.nr_seq_dcb = nr_seq_dcb_w
	where	nr_sequencia = nr_seq_medic_contro_w;

END LOOP;
Close C02;

commit;

update	dcb_medic_controlado a
set	a.ie_situacao	= 'I'
where	a.cd_versao	= 1996
and	not exists (SELECT	1
			from	medic_controlado b
			where	a.nr_sequencia	= b.nr_seq_dcb)
and	not exists (select	1
			from	medic_ficha_tecnica c
			where	a.nr_sequencia	= c.nr_seq_dcb);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_dcb_insert () FROM PUBLIC;

