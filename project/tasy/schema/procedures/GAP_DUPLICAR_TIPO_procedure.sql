-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gap_duplicar_tipo ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;
nr_seq_ritual_w		bigint;
nr_seq_ritual_ww		bigint;
nr_seq_Doc_w			bigint;
nr_seq_Doc_ww			bigint;
ds_documento_w			varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	gap_ritual
	where	nr_seq_tipo	= nr_sequencia_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		ds_documento
	from	gap_tipo_doc
	where	nr_seq_tipo	= nr_sequencia_p;



BEGIN

select	nextval('gap_tipo_seq')
into STRICT	nr_sequencia_w
;

insert into gap_tipo(
	nr_sequencia,
	cd_empresa,
	ie_situacao,
	dt_atualizacao,
	nm_usuario,
	ds_tipo,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
SELECT
	nr_sequencia_w,
	cd_empresa,
	ie_situacao,
	clock_timestamp(),
	nm_usuario_p,
	'Cópia ' || ds_tipo || ' por ' || nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p
from	gap_tipo
where	nr_sequencia		= nr_sequencia_p;

OPEN C01;
LOOP
FETCH C01 into
	nr_seq_ritual_ww;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	nextval('gap_ritual_seq')
	into STRICT	nr_seq_ritual_w
	;
	insert into gap_ritual(
		nr_sequencia,
		nr_seq_tipo,
		ie_situacao,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		ds_titulo_etapa,
		cd_pessoa_fisica,
		ds_etapa,
		ds_observacao,
		nr_seq_depto,
		qt_dia,
		ie_regra_pessoa,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	SELECT
		nr_seq_ritual_w,
		nr_sequencia_w,
		ie_situacao,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres,
		ds_titulo_etapa,
		cd_pessoa_fisica,
		ds_etapa,
		ds_observacao,
		nr_seq_depto,
		qt_dia,
		ie_regra_pessoa,
		clock_timestamp(),
		nm_usuario_p
	from	gap_ritual
	where	nr_sequencia		= nr_seq_ritual_ww;
END LOOP;
CLOSE C01;

OPEN C02;
LOOP
FETCH C02 into
	nr_seq_doc_ww,
	ds_documento_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	select	nextval('gap_tipo_doc_seq')
	into STRICT	nr_seq_doc_w
	;

	insert into gap_tipo_doc(
		nr_sequencia,
		ds_documento,
		nr_seq_tipo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		ie_obrigatorio,
		ie_situacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	SELECT
		nr_seq_doc_w,
		ds_documento_w,
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_apres,
		ie_obrigatorio,
		ie_situacao,
		clock_timestamp(),
		nm_usuario_p
	from	gap_tipo_doc
	where	nr_sequencia		= nr_seq_doc_ww;
END LOOP;
CLOSE C02;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gap_duplicar_tipo ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

