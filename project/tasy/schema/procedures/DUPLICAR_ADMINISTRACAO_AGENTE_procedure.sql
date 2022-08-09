-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_administracao_agente ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into cirurgia_agente_anest_ocor(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_cirur_agente,
	dt_inicio_adm,
	dt_final_adm,
	qt_dose,
	ie_aplic_bolus,
	qt_velocidade_inf,
	ds_observacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	ie_situacao)
SELECT 	nextval('cirurgia_agente_anest_ocor_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_cirur_agente,
	clock_timestamp(),
	clock_timestamp(),
	qt_dose,
	ie_aplic_bolus,
	qt_velocidade_inf,
	ds_observacao,
	nm_usuario_p,
	clock_timestamp(),
	'A'
	from cirurgia_agente_anest_ocor
	where nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_administracao_agente ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
