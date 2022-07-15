-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_posicao_cirurgia ( nr_cirurgia_p bigint, cd_profissional_p text, ie_tipo_p text, nm_usuario_p text, nr_seq_justificativa_p bigint, ds_justificativa_p text, nr_seq_pepo_p bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN

select	nextval('posicao_cirurgia_seq')
into STRICT	nr_sequencia_w
;

if (nr_cirurgia_p > 0) or (nr_seq_pepo_p > 0) then

	insert into posicao_cirurgia(	nr_sequencia,
			nr_cirurgia,
			ie_posicao,
			cd_profissional,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_posicao,
			nr_seq_justificativa,
			ds_justificativa,
			nr_seq_pepo,
			ie_situacao,
			dt_liberacao)
	values (nr_sequencia_w,
			nr_cirurgia_p,
			ie_tipo_p,
			cd_profissional_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_justificativa_p,
			ds_justificativa_p,
			nr_seq_pepo_p,
			'A',
            CASE WHEN Obter_Funcao_Ativa=-3006 THEN clock_timestamp()  ELSE null END );
	commit;

end if;	
nr_sequencia_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_posicao_cirurgia ( nr_cirurgia_p bigint, cd_profissional_p text, ie_tipo_p text, nm_usuario_p text, nr_seq_justificativa_p bigint, ds_justificativa_p text, nr_seq_pepo_p bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

