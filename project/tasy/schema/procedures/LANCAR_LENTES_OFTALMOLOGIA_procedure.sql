-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lancar_lentes_oftalmologia ( nr_atendimento_P bigint, nr_seq_consulta_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
cd_local_estoque_w smallint;	

BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_consulta_p IS NOT NULL AND nr_seq_consulta_p::text <> '') and (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	select	cd_local_estoque 
	into STRICT	cd_local_estoque_w 
	from	setor_atendimento 
	where	cd_setor_atendimento = cd_setor_atendimento_p;
	 
	CALL gerar_lancto_automatico_lente(	 
			nr_atendimento_p, 
			nr_seq_consulta_p, 
			cd_local_estoque_w, 
			nm_usuario_p);
 
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lancar_lentes_oftalmologia ( nr_atendimento_P bigint, nr_seq_consulta_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

