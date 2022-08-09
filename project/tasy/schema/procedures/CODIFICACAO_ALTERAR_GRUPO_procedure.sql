-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_alterar_grupo ( nr_seq_grupo_p bigint, nr_sequencia_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE



cd_grupo_atual_w		codificacao_atendimento.cd_grupo_atual%type;



BEGIN

	/*select	cd_grupo_atual
	into	cd_grupo_atual_w
	from	codificacao_atendimento
	where	nr_sequencia = nr_sequencia_p;*/
	if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '' AND nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

		update	codificacao_atendimento
		set		nm_responsavel_atual  = NULL,
				nm_responsavel  = NULL,
				cd_grupo_inicial = nr_seq_grupo_p,
				cd_grupo_atual = nr_seq_grupo_p,
				cd_grupo_anterior  = NULL,
				dt_inicio_analise  = NULL,
				ie_status  = NULL,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_p;

		CALL gerar_codificacao_atend_log(nr_sequencia_p, obter_desc_expressao(892282) || ' ' || obter_desc_expressao(310214) || ' '
		|| Obter_Descricao_Padrao('CODIFICACAO_GRUPO', 'DS_GRUPO',cd_grupo_atual_w) || ' ' || obter_desc_expressao(727816) || ' '
		|| Obter_Descricao_Padrao('CODIFICACAO_GRUPO', 'DS_GRUPO',nr_seq_grupo_p) || ' ' || substr(ds_observacao_p,1,100), nm_usuario_p);


	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_alterar_grupo ( nr_seq_grupo_p bigint, nr_sequencia_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
