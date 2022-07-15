-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_imp_plan_medic ( nr_seq_plano_p bigint) AS $body$
DECLARE


nr_sequencia_w 		bigint;
nm_usuario_w		varchar(100);
cd_pessoa_fisica_w	varchar(10);


BEGIN

select	nextval('plano_medic_hist_imp_seq')
into STRICT	nr_sequencia_w
;

nm_usuario_w 		:= wheb_usuario_pck.get_nm_usuario;
cd_pessoa_fisica_w 	:= obter_pf_usuario(nm_usuario_w, 'C');

insert into plano_medic_hist_imp(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			dt_impressao,
			nr_seq_plano)
values (
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_w,
			clock_timestamp(),
			nm_usuario_w,
			cd_pessoa_fisica_w,
			clock_timestamp(),
			nr_seq_plano_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_imp_plan_medic ( nr_seq_plano_p bigint) FROM PUBLIC;

