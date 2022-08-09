-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_compl_lote_pagto ( nr_seq_lote_p bigint, nr_seq_prestador_p bigint, nr_seq_protocolo_p bigint, nr_protocolo_prestador_p bigint, nr_seq_conta_p bigint, ie_tipo_guia_p text, nr_seq_tipo_prestador_p bigint, nr_seq_classif_prestador_p bigint, ie_tipo_desp_proc_p text, ie_tipo_desp_mat_p text, ie_conta_intercambio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_evento_w			bigint;
qt_protocolo_w			bigint;
qt_conta_w			bigint;

C01 CURSOR FOR
	SELECT	nr_seq_evento
	from	w_pls_selecao_evento_compl
	where	nm_usuario	= nm_usuario_p;

BEGIN
if (nr_seq_protocolo_p <> 0) then
	select	count(*)
	into STRICT	qt_protocolo_w
	from	pls_protocolo_conta
	where	nr_sequencia	= nr_seq_protocolo_p;

	if (qt_protocolo_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184544);
	end if;
end if;

if (nr_seq_conta_p <> 0) then
	select	count(*)
	into STRICT	qt_conta_w
	from	pls_conta
	where	nr_sequencia	= nr_seq_conta_p;

	if (qt_conta_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(184545);
	end if;
end if;

open C01;
loop
fetch C01 into
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	insert into pls_lote_pgto_compl(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_conta,
		nr_seq_protocolo,
		ie_tipo_guia,
		ie_tipo_despesa_proc,
		ie_tipo_despesa_mat,
		nr_seq_lote,
		nr_seq_prestador,
		nr_protocolo_prestador,
		nr_seq_classif_prestador,
		nr_seq_evento,
		nr_seq_tipo_prestador,
		ie_conta_intercambio)
	values (nextval('pls_lote_pgto_compl_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		CASE WHEN nr_seq_conta_p=0 THEN null  ELSE nr_seq_conta_p END ,
		CASE WHEN nr_seq_protocolo_p=0 THEN null  ELSE nr_seq_protocolo_p END ,
		ie_tipo_guia_p,
		ie_tipo_desp_proc_p,
		ie_tipo_desp_mat_p,
		nr_seq_lote_p,
		CASE WHEN nr_seq_prestador_p=0 THEN null  ELSE nr_seq_prestador_p END ,
		CASE WHEN nr_protocolo_prestador_p=0 THEN null  ELSE nr_protocolo_prestador_p END ,
		CASE WHEN nr_seq_classif_prestador_p=0 THEN null  ELSE nr_seq_classif_prestador_p END ,
		nr_seq_evento_w,
		CASE WHEN nr_seq_tipo_prestador_p=0 THEN null  ELSE nr_seq_tipo_prestador_p END ,
		CASE WHEN ie_conta_intercambio_p=0 THEN 'N' WHEN ie_conta_intercambio_p=1 THEN 'I' WHEN ie_conta_intercambio_p=2 THEN 'S'  ELSE 'S' END );
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_compl_lote_pagto ( nr_seq_lote_p bigint, nr_seq_prestador_p bigint, nr_seq_protocolo_p bigint, nr_protocolo_prestador_p bigint, nr_seq_conta_p bigint, ie_tipo_guia_p text, nr_seq_tipo_prestador_p bigint, nr_seq_classif_prestador_p bigint, ie_tipo_desp_proc_p text, ie_tipo_desp_mat_p text, ie_conta_intercambio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
