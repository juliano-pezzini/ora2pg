-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_req_resp_parece ( nr_parecer_p bigint, nr_sequencia_p bigint, ie_tipo_evolucao_p text, nm_usuario_p text, cd_evolucao_p INOUT bigint) AS $body$
DECLARE

				 
cd_evolucao_w		bigint;

BEGIN
 
select	nextval('evolucao_paciente_seq') 
into STRICT	cd_evolucao_w
;
 
CALL gerar_evolucao_parecer(nr_parecer_p, nr_sequencia_p, ie_tipo_evolucao_p, nm_usuario_p, cd_evolucao_w);
cd_evolucao_p := cd_evolucao_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_req_resp_parece ( nr_parecer_p bigint, nr_sequencia_p bigint, ie_tipo_evolucao_p text, nm_usuario_p text, cd_evolucao_p INOUT bigint) FROM PUBLIC;

