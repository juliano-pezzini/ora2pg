-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_lib_linha_cuidado (nr_seq_protocolo_integrado_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		PROTOCOLO_INTEGRADO_LIB.NR_SEQUENCIA%type;	


BEGIN
	
	select	nextval('protocolo_integrado_lib_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into PROTOCOLO_INTEGRADO_LIB(nr_sequencia,
		 dt_atualizacao,
		 nm_usuario,
		 dt_atualizacao_nrec,
		 nm_usuario_nrec,
		 nr_seq_protocolo_integrado,
		 cd_time
	) values (
		nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_protocolo_integrado_p,
		nr_seq_grupo_p
	);
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_lib_linha_cuidado (nr_seq_protocolo_integrado_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) FROM PUBLIC;

