-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_esocial_dados_pck.gravar_alteracao_cad_det ( nr_seq_prestador_p bigint, nm_usuario_p text, esocial_altera_cad_det_p INOUT t_esocial_altera_cad_det) AS $body$
DECLARE


	nr_seq_alt_cad_prest_w	esocial_altera_cad_prest.nr_sequencia%type;
	dt_inicial_w		timestamp;
	dt_final_w		timestamp;

	
BEGIN

	dt_inicial_w	:= trunc(clock_timestamp(),'MONTH');
	dt_final_w	:= pkg_date_utils.start_of(pkg_date_utils.end_of(clock_timestamp(),'MONTH',0),'dd');

	select	coalesce(max(a.nr_sequencia),0)
	into STRICT	nr_seq_alt_cad_prest_w
	from	esocial_altera_cad_prest a
	where	a.nr_seq_prestador	= nr_seq_prestador_p
	and	a.dt_referencia between	dt_inicial_w and dt_final_w;
	

	if (nr_seq_alt_cad_prest_w = 0) then
		insert into esocial_altera_cad_prest(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_referencia,
				nr_seq_prestador)
			values (nextval('esocial_altera_cad_prest_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_prestador_p)
		returning nr_sequencia into nr_seq_alt_cad_prest_w;
	end if;

	for i in esocial_altera_cad_det_p.first .. esocial_altera_cad_det_p.last
	loop
		insert into esocial_altera_cad_det(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_alt_cad_prest,
			nm_campo,
			ds_valor_anterior,
			ds_valor_atual)
		values (nextval('esocial_altera_cad_det_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_alt_cad_prest_w,
			esocial_altera_cad_det_p[i].nm_campo,
			esocial_altera_cad_det_p[i].ds_valor_anterior,
			esocial_altera_cad_det_p[i].ds_valor_atual);

	end loop;

	esocial_altera_cad_det_p.delete;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_esocial_dados_pck.gravar_alteracao_cad_det ( nr_seq_prestador_p bigint, nm_usuario_p text, esocial_altera_cad_det_p INOUT t_esocial_altera_cad_det) FROM PUBLIC;