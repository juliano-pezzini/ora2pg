-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_mot_reclamacao ( nr_seq_guia_p bigint, nr_seq_reclamacao_p bigint, dt_reclamacao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prestador_w		bigint;
nr_seq_reclamacao_w		bigint;
nr_seq_segurado_w		bigint;


BEGIN

select	nr_seq_prestador,
	nr_seq_segurado
into STRICT	nr_seq_prestador_w,
	nr_seq_segurado_w
from	pls_guia_plano
where	nr_sequencia = nr_seq_guia_p;

insert into pls_prestador_negativa(
			nr_sequencia,
			dt_reclamacao,
			nr_seq_guia,
			nr_seq_prestador,
			nr_seq_reclamacao,
			nr_seq_segurado,
			nm_usuario,
			nm_usuario_nrec,
			dt_atualizacao,
			dt_atualizacao_nrec)
		values (	nextval('pls_prestador_negativa_seq'),
			dt_reclamacao_p,
			nr_seq_guia_p,
			nr_seq_prestador_w,
			nr_seq_reclamacao_p,
			nr_seq_segurado_w,
			nm_usuario_p,
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp());


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_mot_reclamacao ( nr_seq_guia_p bigint, nr_seq_reclamacao_p bigint, dt_reclamacao_p timestamp, nm_usuario_p text) FROM PUBLIC;

