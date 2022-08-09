-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_registrar_orientacoes ( nr_seq_triagem_p bigint, ds_orientacoes_p text, ie_liberar_p text, ie_status_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
CALL san_gravar_orientacoes_doacao(nr_seq_triagem_p, ds_orientacoes_p, nm_usuario_p);
 
if (ie_liberar_p = 'S') then 
	CALL san_atualizar_status_doacao(nr_seq_triagem_p, nm_usuario_p, ie_status_p);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_registrar_orientacoes ( nr_seq_triagem_p bigint, ds_orientacoes_p text, ie_liberar_p text, ie_status_p bigint, nm_usuario_p text) FROM PUBLIC;
