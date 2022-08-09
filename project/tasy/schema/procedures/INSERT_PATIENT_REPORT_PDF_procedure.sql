-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_patient_report_pdf (nm_usuario_p text, nr_seq_laudo_p bigint, ds_laudo_byte_p bytea) AS $body$
DECLARE


nr_sequencia_w      laudo_paciente_pdf.nr_sequencia%type;
nr_acesso_dicom_w   prescr_procedimento.nr_acesso_dicom%type;
count_w				smallint;


BEGIN
	
	select count(1)
	into STRICT count_w
	from laudo_paciente_pdf
	where nr_seq_laudo = nr_seq_laudo_p;

	if (count_w = 0) then
		select max(b.nr_acesso_dicom)
		into STRICT nr_acesso_dicom_w
		from laudo_paciente a
		left join prescr_procedimento b on
			a.nr_prescricao = b.nr_prescricao and
			a.nr_seq_prescricao = b.nr_sequencia
		where a.nr_sequencia = nr_seq_laudo_p;

		select nextval('laudo_paciente_pdf_seq')
		into STRICT nr_sequencia_w
		;

		insert into
		laudo_paciente_pdf(
			nr_sequencia,
			nr_acesso_dicom,
			nr_seq_laudo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_arquivo)
		values (
			nr_sequencia_w,
			nr_acesso_dicom_w,
			nr_seq_laudo_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_laudo_byte_p);
	else
		update laudo_paciente_pdf
		set dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			ds_arquivo = ds_laudo_byte_p
		where nr_seq_laudo = nr_seq_laudo_p;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_patient_report_pdf (nm_usuario_p text, nr_seq_laudo_p bigint, ds_laudo_byte_p bytea) FROM PUBLIC;
