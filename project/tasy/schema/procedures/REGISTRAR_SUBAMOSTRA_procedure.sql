-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_subamostra ( nr_seq_peca_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_prescricao_w		bigint;
nr_seq_prescr_w		bigint;
cd_topografia_w		varchar(10);
cd_morfologia_w		varchar(10);
nr_seq_laudo_w		bigint;
nr_seq_tipo_w		bigint;
nr_controle_w		varchar(50);
cd_doenca_cid_w		varchar(10);
ie_situacao_w   		varchar(1);
NR_SEQ_MORF_DESC_ADIC_w bigint;


BEGIN

IF (coalesce(nr_seq_peca_p,0) > 0) then

	select	nr_prescricao,
		nr_seq_prescr,
		cd_topografia,
		cd_morfologia,
		nr_seq_laudo,
		cd_doenca_cid,
		nr_seq_tipo,
		ie_situacao,
    NR_SEQ_MORF_DESC_ADIC
	into STRICT	nr_prescricao_w,
		nr_seq_prescr_w,
		cd_topografia_w,
		cd_morfologia_w,
		nr_seq_laudo_w,
		cd_doenca_cid_w,
		nr_seq_tipo_w,
		ie_situacao_w,
    NR_SEQ_MORF_DESC_ADIC_w
	from	prescr_proc_peca
	where	nr_sequencia	= nr_seq_peca_p;

	select	max(Calcular_numero_controle_peca(nr_seq_tipo_w, nr_prescricao_w, nr_seq_prescr_w))
	into STRICT	nr_controle_w
	;

	select	nextval('prescr_proc_peca_seq')
	into STRICT	nr_sequencia_w
	;

	insert into prescr_proc_peca(nr_sequencia,
		nr_prescricao,
		nr_seq_prescr,
		cd_topografia,
		cd_morfologia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_laudo,
		cd_doenca_cid,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_peca,
		nr_seq_tipo,
		nr_controle,
    ie_situacao,
    NR_SEQ_MORF_DESC_ADIC)
	values (nr_sequencia_w,
		nr_prescricao_w,
		nr_seq_prescr_w,
		cd_topografia_w,
		cd_morfologia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_laudo_w,
		cd_doenca_cid_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_peca_p,
		nr_seq_tipo_w,
		nr_controle_w,
    ie_situacao_w,
    NR_SEQ_MORF_DESC_ADIC_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_subamostra ( nr_seq_peca_p bigint, nm_usuario_p text) FROM PUBLIC;

