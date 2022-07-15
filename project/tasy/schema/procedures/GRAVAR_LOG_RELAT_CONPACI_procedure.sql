-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_relat_conpaci (nr_interno_conta_p bigint, nm_usuario_p text, ie_status_acerto_p bigint, cd_perfil_p bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

select	nextval('conpaci_log_relatorio_seq')
	into STRICT	nr_sequencia_w
	;

	insert into conpaci_log_relatorio( nr_sequencia,
					nr_interno_conta,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_status_acerto,
					cd_perfil)
					values (
					nr_sequencia_w,
					nr_interno_conta_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ie_status_acerto_p,
					cd_perfil_p);


commit;

end 		;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_relat_conpaci (nr_interno_conta_p bigint, nm_usuario_p text, ie_status_acerto_p bigint, cd_perfil_p bigint) FROM PUBLIC;

