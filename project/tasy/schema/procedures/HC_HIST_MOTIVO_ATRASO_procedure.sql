-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_hist_motivo_atraso ( NR_SEQ_MOTIVO_P bigint, NR_SEQ_AGENDA_HC_P bigint, NM_USUARIO_P text) AS $body$
BEGIN
if ((NR_SEQ_MOTIVO_P IS NOT NULL AND NR_SEQ_MOTIVO_P::text <> '') and (NR_SEQ_AGENDA_HC_P IS NOT NULL AND NR_SEQ_AGENDA_HC_P::text <> '') and (NM_USUARIO_P IS NOT NULL AND NM_USUARIO_P::text <> '')) then

	insert into AGENDA_HC_ATRASO_HIST(
				NR_SEQUENCIA,
				DT_ATUALIZACAO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO,
				NM_USUARIO_NREC,
				NR_SEQ_AGENDA,
				NR_SEQ_MOTIVO)
    Values (
				nextval('agenda_hc_atraso_hist_seq'),
				clock_timestamp(),
				clock_timestamp(),
				NM_USUARIO_P,
				NM_USUARIO_P,
				NR_SEQ_AGENDA_HC_P,
				NR_SEQ_MOTIVO_P
				);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_hist_motivo_atraso ( NR_SEQ_MOTIVO_P bigint, NR_SEQ_AGENDA_HC_P bigint, NM_USUARIO_P text) FROM PUBLIC;
