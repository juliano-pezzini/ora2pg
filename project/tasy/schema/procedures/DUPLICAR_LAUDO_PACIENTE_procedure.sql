-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_laudo_paciente (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w	bigint;
nr_laudo_w		bigint;
nr_seq_laudo_w	bigint;


BEGIN

select nextval('laudo_paciente_seq')
into STRICT nr_seq_laudo_w
;

select 	nr_atendimento
into STRICT	nr_atendimento_w
from laudo_paciente
where nr_sequencia = nr_sequencia_p;

select max(nr_laudo) + 1
into STRICT	nr_laudo_w
from laudo_paciente
where nr_atendimento = nr_atendimento_w;

insert into laudo_paciente(	NR_SEQUENCIA,
					NR_ATENDIMENTO,
					DT_ENTRADA_UNIDADE,
					NR_LAUDO,
					NM_USUARIO,
					DT_ATUALIZACAO,
					CD_MEDICO_RESP,
					DS_TITULO_LAUDO,
					DT_LAUDO,
					CD_LAUDO_PADRAO,
					IE_NORMAL,
					DT_EXAME,
					NR_PRESCRICAO,
					CD_PROTOCOLO,
					CD_PROJETO,
					NR_SEQ_PROC,
					NR_SEQ_PRESCRICAO,
					DT_PREV_ENTREGA,
					DT_REAL_ENTREGA,
					QT_IMAGEM,
					nr_exame)
SELECT	nr_seq_laudo_w,
		NR_ATENDIMENTO,
		DT_ENTRADA_UNIDADE,
		nr_laudo_w,
		nm_usuario_p,
		clock_timestamp(),
		CD_MEDICO_RESP,
		DS_TITULO_LAUDO,
		DT_LAUDO,
		CD_LAUDO_PADRAO,
		IE_NORMAL,
		DT_EXAME,
		NR_PRESCRICAO,
		CD_PROTOCOLO,
		CD_PROJETO,
		NR_SEQ_PROC,
		NR_SEQ_PRESCRICAO,
		DT_PREV_ENTREGA,
		DT_REAL_ENTREGA,
		QT_IMAGEM,
		nr_exame
from laudo_paciente
where nr_sequencia = nr_sequencia_p;

CALL copia_campo_long('LAUDO_PACIENTE','DS_LAUDO','WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
								 'NR_SEQUENCIA='||nr_sequencia_p,'NR_SEQUENCIA='||nr_seq_laudo_w);

CALL Vincular_Procedimento_Laudo(nr_seq_laudo_w,'N',nm_usuario_p);

insert into laudo_paciente_imagem(
		nr_sequencia,
		nr_seq_imagem,
		dt_atualizacao,
		nm_usuario,
		ds_arquivo_imagem,
		ds_imagem)
SELECT	nr_seq_laudo_w,
	nr_seq_imagem,
	clock_timestamp(),
	nm_usuario_p,
	ds_arquivo_imagem,
	ds_imagem
from laudo_paciente_imagem
where nr_sequencia = nr_sequencia_p;

insert into laudo_paciente_diag(
			nr_sequencia,
			cd_doenca,
			dt_atualizacao,
			nm_usuario)
SELECT	nr_seq_laudo_w,
		cd_doenca,
		clock_timestamp(),
		nm_usuario_p
from laudo_paciente_diag
where nr_sequencia = nr_sequencia_p;

insert into laudo_paciente_medida(nr_sequencia,
		 nr_seq_laudo,
		 nr_seq_medida,
		 dt_atualizacao,
		 nm_usuario,
		 qt_medida,
		 qt_minimo,
		 qt_maximo)
SELECT	nextval('laudo_paciente_medida_seq'),
		nr_seq_laudo_w,
		nr_seq_medida,
		clock_timestamp(),
		nm_usuario_p,
		qt_medida,
		qt_minimo,
		qt_maximo
from laudo_paciente_medida
where nr_seq_laudo = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_laudo_paciente (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

