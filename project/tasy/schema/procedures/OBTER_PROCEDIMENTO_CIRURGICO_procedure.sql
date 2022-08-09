-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_procedimento_cirurgico ( nr_seq_fatur_p bigint, nr_cirurgia_p bigint, nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_inicio_real_w	timestamp;
dt_termino_w	timestamp;


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select	dt_inicio_real,
		dt_termino
	into STRICT	dt_inicio_real_w,
		dt_termino_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;

	insert into	pep_med_fatur_proc(nr_sequencia,
			nr_seq_fatur,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_proc_interno,
			qt_fatur,
			cd_procedimento,
			ie_origem_proced,
			dt_procedimento,
			dt_inicio_procedimento,
			dt_fim_procedimento,
			ds_observacao,
			ie_tecnica_utilizada,
			ie_via_acesso,
			tx_reducao_acres)
	values (	nextval('pep_med_fatur_proc_seq'),
			nr_seq_fatur_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			CASE WHEN nr_seq_proc_interno_p=0 THEN null  ELSE nr_seq_proc_interno_p END ,
			0,
			cd_procedimento_p,
			ie_origem_proced_p,
			clock_timestamp(),
			dt_inicio_real_w,
			dt_termino_w,
			'',
			null,
			null,
			null);

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_procedimento_cirurgico ( nr_seq_fatur_p bigint, nr_cirurgia_p bigint, nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nm_usuario_p text) FROM PUBLIC;
