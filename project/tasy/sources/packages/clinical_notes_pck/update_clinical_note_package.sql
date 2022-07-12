-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE clinical_notes_pck.update_clinical_note (cd_evolucao_p bigint, ie_med_rec_type_p text, ie_soap_type_p text, ie_stage_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN
	delete from clinical_note_soap_data
		where cd_evolucao = cd_evolucao_p
		and ie_med_rec_type = ie_med_rec_type_p
		and ie_stage = ie_stage_p
		and ie_soap_type = ie_soap_type_p and nr_seq_med_item=nr_sequencia_p;
	CALL clinical_notes_pck.soap_data_after_delete(cd_evolucao_p);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE clinical_notes_pck.update_clinical_note (cd_evolucao_p bigint, ie_med_rec_type_p text, ie_soap_type_p text, ie_stage_p bigint, nr_sequencia_p bigint) FROM PUBLIC;