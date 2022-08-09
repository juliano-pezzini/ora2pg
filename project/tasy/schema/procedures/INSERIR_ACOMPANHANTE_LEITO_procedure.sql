-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_acompanhante_leito ( nr_atendimento_p bigint, cd_acompanhante_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atend_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_acompanhante_p IS NOT NULL AND cd_acompanhante_p::text <> '') and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') and (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') then
	begin

	update	unidade_atendimento
	set	ie_status_unidade	= 'M',
		nr_atendimento_Acomp	= nr_atendimento_p,
		cd_paciente_reserva	= cd_acompanhante_p,
		nm_usuario_reserva	= nm_usuario_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	cd_unidade_basica	= cd_unidade_basica_p
	and	cd_unidade_compl	= cd_unidade_compl_p
	and	cd_setor_atendimento	= cd_setor_atend_p;

	commit;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_acompanhante_leito ( nr_atendimento_p bigint, cd_acompanhante_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atend_p text, nm_usuario_p text) FROM PUBLIC;
