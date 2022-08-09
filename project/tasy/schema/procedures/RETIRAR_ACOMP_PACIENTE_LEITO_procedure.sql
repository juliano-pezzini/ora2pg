-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE retirar_acomp_paciente_leito ( nr_atendimento_p text, cd_pessoa_reserva_p text) AS $body$
DECLARE


cd_unidade_basica_p	unidade_atendimento.cd_unidade_basica%type;
cd_unidade_compl_p	unidade_atendimento.cd_unidade_compl%type;		
					

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND cd_pessoa_reserva_p IS NOT NULL AND cd_pessoa_reserva_p::text <> '') then
	begin
	
	select	max(cd_unidade_basica),	
		max(cd_unidade_compl)
	into STRICT	cd_unidade_basica_p,	
		cd_unidade_compl_p
	from 	unidade_atendimento
	where   nr_atendimento_acomp = nr_atendimento_p
	and 	cd_paciente_reserva  = cd_pessoa_reserva_p;	

	if (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '' AND cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '')then
		CALL retirar_acompanhante_leito(	cd_unidade_basica_p,	
						cd_unidade_compl_p,
						wheb_usuario_pck.get_cd_perfil,
						wheb_usuario_pck.get_cd_estabelecimento,
						wheb_usuario_pck.get_nm_usuario);
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE retirar_acomp_paciente_leito ( nr_atendimento_p text, cd_pessoa_reserva_p text) FROM PUBLIC;
