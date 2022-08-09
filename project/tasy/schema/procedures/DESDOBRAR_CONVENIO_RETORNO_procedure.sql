-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_convenio_retorno (NR_SEQ_RETORNO_P bigint, QT_GUIA_P bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;
nr_seq_retorno_w	bigint;
qt_guias_w 	bigint;

c01 CURSOR FOR

SELECT 	nr_sequencia
from	convenio_retorno_item
where	nr_seq_retorno = nr_seq_retorno_p;


BEGIN

qt_guias_w 		:= 0;
nr_seq_retorno_w		:= NR_SEQ_RETORNO_P;

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */


	if (qt_guias_w = qt_guia_p) then

		select	nextval('convenio_retorno_seq')
		into STRICT	nr_seq_retorno_w
		;

		insert into convenio_retorno(nr_sequencia,
			cd_convenio,
			cd_estabelecimento,
			dt_atualizacao,
			dt_retorno,
			ie_status_retorno,
			nm_usuario,
			nm_usuario_retorno,
			cd_convenio_particular,
			ds_lote_convenio,
			ds_observacao,
			dt_baixa_cr,
			dt_consistencia,
			dt_fim_glosa,
			dt_final,
			dt_inicial,
			dt_limite_glosa,
			dt_recebimento,
			dt_ref_preco,
			dt_vinculacao,
			ie_baixa_unica_ret,
			ie_doc_retorno,
			ie_tipo_glosa,
			nr_seq_cobranca,
			nr_seq_prot_adic,
			nr_seq_protocolo,
			nr_seq_ret_estorno,
			nr_seq_ret_origem,
			nr_seq_tipo)
		SELECT	nr_seq_retorno_w,
			cd_convenio,
			cd_estabelecimento,
			dt_atualizacao,
			dt_retorno,
			ie_status_retorno,
			nm_usuario,
			nm_usuario_retorno,
			cd_convenio_particular,
			ds_lote_convenio,
			ds_observacao,
			dt_baixa_cr,
			dt_consistencia,
			dt_fim_glosa,
			dt_final,
			dt_inicial,
			dt_limite_glosa,
			dt_recebimento,
			dt_ref_preco,
			dt_vinculacao,
			ie_baixa_unica_ret,
			ie_doc_retorno,
			ie_tipo_glosa,
			nr_seq_cobranca,
			nr_seq_prot_adic,
			nr_seq_protocolo,
			nr_seq_ret_estorno,
			nr_seq_ret_origem,
			nr_seq_tipo
		from	convenio_retorno
		where	nr_sequencia	= nr_seq_retorno_p;

		qt_guias_w	:= 0;
	end if;

	qt_guias_w := qt_guias_w +1;

	update	convenio_retorno_item
	set	nr_seq_retorno	= nr_seq_retorno_w
	where	nr_sequencia	= nr_sequencia_w;

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_convenio_retorno (NR_SEQ_RETORNO_P bigint, QT_GUIA_P bigint, nm_usuario_p text) FROM PUBLIC;
