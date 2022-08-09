-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_vl_conta_excedente ( nr_interno_conta_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE

/*
CRIADO PARA SALVAR O VALOR ORIGINAL DA CONTA
PARA A REGRA DE CONTA EXCEDENTE - MÉXICO
*/
vl_conta_w 			double precision;


BEGIN


if (coalesce(nr_interno_conta_p,0) > 0) and (2 = philips_param_pck.get_cd_pais) then

	vl_conta_w :=  obter_valor_conta(nr_interno_conta_p,0);

	update	conta_paciente_excedente
	set	vl_conta_origem = coalesce(vl_conta_w,0),
		dt_atualizacao 	= clock_timestamp(),
		nm_usuario 	= nm_usuario_p
	where	nr_interno_conta = nr_interno_conta_p;

	if (coalesce(ie_commit_p,'N') = 'S') then
		if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_vl_conta_excedente ( nr_interno_conta_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
