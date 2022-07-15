-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_sisreg ( nr_seq_interno_p bigint, nr_protocolo_sisreg_p bigint, nm_usuario_p text) AS $body$
BEGIN
	update 	sus_laudo_paciente 
	set	nr_protocolo_sisreg = nr_protocolo_sisreg_p, 
		ie_status_sisreg = '1', 
		dt_envio_sisreg	= clock_timestamp(),	 
		nm_usuario_sisreg = nm_usuario_p, 
		dt_atualizacao = clock_timestamp(), 
		nm_usuario = nm_usuario_p 
	where	nr_seq_interno = nr_seq_interno_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_sisreg ( nr_seq_interno_p bigint, nr_protocolo_sisreg_p bigint, nm_usuario_p text) FROM PUBLIC;

