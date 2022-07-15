-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_elab_doc ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_estabelecimento_w		bigint;
cd_setor_atendimento_w	bigint;
qt_documento_w		bigint;
qt_doc_elab_w			bigint;
dt_referencia_w		timestamp;

C01 CURSOR FOR
	SELECT	cd_estabelecimento,
		cd_setor_atendimento,
	count(*) qt_documento,
	sum(CASE WHEN ie_status='P' THEN 0  ELSE 1 END ) qt_elaborado
from	qua_documento
where	ie_situacao	= 'A'
and	trunc(dt_atualizacao_nrec, 'month') <= TRUNC(dt_referencia_p, 'month')
group by
	cd_estabelecimento,
	cd_setor_atendimento;


BEGIN

dt_referencia_w		:= trunc(dt_referencia_p,'month');

delete from eis_qua_doc_elab
where	trunc(dt_referencia,'mm') = trunc(dt_referencia_w,'mm');

OPEN C01;
LOOP
FETCH C01 into
	cd_estabelecimento_w,
	cd_setor_atendimento_w,
	qt_documento_w,
	qt_doc_elab_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	nextval('eis_qua_doc_elab_seq')
	into STRICT	nr_sequencia_w
	;
	insert	into eis_qua_doc_elab(
		nr_sequencia,
		cd_estabelecimento,
		dt_referencia,
		dt_atualizacao,
		nm_usuario,
		cd_setor_atendimento,
		qt_documento,
		qt_doc_elaborado)
	values (
		nr_sequencia_w,
		cd_estabelecimento_w,
		dt_referencia_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_setor_atendimento_w,
		qt_documento_w,
		qt_doc_elab_w);

END LOOP;
CLOSE C01;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_elab_doc ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

