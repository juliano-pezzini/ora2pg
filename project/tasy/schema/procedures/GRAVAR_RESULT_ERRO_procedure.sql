-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_result_erro ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into lab_gravar_result_erro(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_prescr)
values (nextval('lab_gravar_result_erro_seq'),
				clock_timestamp(),
				coalesce(nm_usuario_p,'UsuarioNulo'),
				clock_timestamp(),
				coalesce(nm_usuario_p,'UsuarioNulo'),
				nr_prescricao_p,
				nr_seq_prescr_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_result_erro ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nm_usuario_p text) FROM PUBLIC;
