-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE selec_cartao_encaixe_agexame ( nr_seq_encaixe_p bigint, cd_usuario_plano_p text, dt_validade_carteira_p timestamp, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_parametro_w		varchar(255);


BEGIN

if (nr_seq_encaixe_p IS NOT NULL AND nr_seq_encaixe_p::text <> '') then
	begin

	update	agenda_paciente
	set	dt_validade_carteira	= dt_validade_carteira_p,
		cd_usuario_convenio	= cd_usuario_plano_p
	where	nr_sequencia		= nr_seq_encaixe_p;

	vl_parametro_w := Obter_Param_Usuario(820, 116, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

	if (vl_parametro_w = 'S') then
		CALL gera_plano_ops_agepac(nr_seq_encaixe_p);
	end if;

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE selec_cartao_encaixe_agexame ( nr_seq_encaixe_p bigint, cd_usuario_plano_p text, dt_validade_carteira_p timestamp, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

