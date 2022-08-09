-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_rol_segmentacao ( nr_seq_rol_grupo_p bigint, ie_segmentacao_p text, nm_usuario_p text) AS $body$
BEGIN

insert into 	pls_rol_segmentacao(nr_sequencia, nm_usuario, dt_atualizacao,
		ie_segmentacao, nr_seq_rol_grupo)
values (nextval('pls_rol_segmentacao_seq'), nm_usuario_p, clock_timestamp(),
		ie_segmentacao_p, nr_seq_rol_grupo_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_rol_segmentacao ( nr_seq_rol_grupo_p bigint, ie_segmentacao_p text, nm_usuario_p text) FROM PUBLIC;
