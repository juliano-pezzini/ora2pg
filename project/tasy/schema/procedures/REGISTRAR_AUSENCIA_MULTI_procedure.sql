-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_ausencia_multi (cd_profissional_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_motivo_afast_p text, cd_substituto_p text, cd_escala_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into escala_afastamento_prof(nr_sequencia,
				    dt_inicio,
				    dt_final,
				    nr_seq_motivo_afast,
				    cd_profissional,
				    cd_profissional_subst,
				    dt_atualizacao,
				    dt_atualizacao_nrec,
				    nm_usuario,
				    nm_usuario_nrec,
				    nr_seq_escala,
				    ie_tipo_escala)
			    values ( nextval('escala_afastamento_prof_seq'),
			            dt_inicial_p,
				    fim_dia(dt_final_p),
				    cd_motivo_afast_p,
				    cd_profissional_p,
				    cd_substituto_p,
				    clock_timestamp(),
				    clock_timestamp(),
				    nm_usuario_p,
				    nm_usuario_p,
				    CASE WHEN cd_escala_p=0 THEN ''  ELSE cd_escala_p END ,
				    'S');


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_ausencia_multi (cd_profissional_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_motivo_afast_p text, cd_substituto_p text, cd_escala_p bigint, nm_usuario_p text) FROM PUBLIC;

