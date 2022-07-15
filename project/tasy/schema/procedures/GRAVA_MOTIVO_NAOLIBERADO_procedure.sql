-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_motivo_naoliberado (nr_seq_atendimento_p bigint, nr_seq_motivo_bloq_p bigint, ds_motivo_bloq_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_motivo_bloq_p IS NOT NULL AND nr_seq_motivo_bloq_p::text <> '') and (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
	update 	paciente_atendimento
	set	nr_seq_motivo_bloq = nr_seq_motivo_bloq_p,
		ie_exige_liberacao = 'S',
		ds_bloq_trat_quimio = ds_motivo_bloq_p
	where 	nr_seq_atendimento = nr_seq_atendimento_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_motivo_naoliberado (nr_seq_atendimento_p bigint, nr_seq_motivo_bloq_p bigint, ds_motivo_bloq_p text, nm_usuario_p text) FROM PUBLIC;

