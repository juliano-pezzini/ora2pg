-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_cirurgia_resumo_alta ( nr_cirurgia_p bigint, nr_seq_atend_sumario_p bigint, nm_usuario_p text) AS $body$
BEGIN
insert into atend_sumario_alta_item(
			 nr_sequencia,
			 cd_doenca,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 ie_tipo_item,
			 nr_seq_atend_sumario,
			 nr_cirurgia)
		values (
			 nextval('atend_sumario_alta_item_seq'),
			 null,
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 'I',
			 nr_seq_atend_sumario_p,
			 nr_cirurgia_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_cirurgia_resumo_alta ( nr_cirurgia_p bigint, nr_seq_atend_sumario_p bigint, nm_usuario_p text) FROM PUBLIC;
