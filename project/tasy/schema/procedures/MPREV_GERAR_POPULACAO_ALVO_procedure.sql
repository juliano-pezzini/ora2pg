-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_gerar_populacao_alvo (nr_seq_populacao_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE

				
nr_seq_regra_cubo_w	mprev_regra_cubo.nr_sequencia%type;
dt_inicio_geracao_w	timestamp;
dt_fim_geracao_w	timestamp;
ie_origem_dados_w	mprev_config_geral.ie_origem_dados%type;


BEGIN

dt_inicio_geracao_w 	:= null;
dt_fim_geracao_w	:= null;

if (nr_seq_populacao_p IS NOT NULL AND nr_seq_populacao_p::text <> '') then
	
	select	a.nr_seq_regra_cubo
	into STRICT	nr_seq_regra_cubo_w
	from	mprev_populacao_alvo a
	where	a.nr_sequencia	= nr_seq_populacao_p;

	 select coalesce(max(ie_origem_dados),'O')
	 into STRICT	ie_origem_dados_w
	 from 	mprev_config_geral
	 where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	
	if (ie_opcao_p = 'G') then
		dt_inicio_geracao_w := clock_timestamp();
	end if;
	
	/* Atualizar a data de inicio de geracao da populacao */

	update	mprev_populacao_alvo
	set	dt_inicio_geracao 	= dt_inicio_geracao_w,
		nm_usuario 			= nm_usuario_p,
		dt_atualizacao 		= clock_timestamp()
	where	nr_sequencia	= nr_seq_populacao_p;
	
	if (ie_origem_dados_w = 'P') then
		CALL mprev_pop_alvo_prest_pck.desfazer_geracao_pop_alvo(nr_seq_populacao_p);
	else
		CALL mprev_pop_alvo_pck.desfazer_geracao_pop_alvo(nr_seq_populacao_p);
	end if;
	
	if (ie_opcao_p = 'G') then
		if (ie_origem_dados_w = 'P') then
			CALL mprev_pop_alvo_prest_pck.gerar_populacao_alvo(nr_seq_regra_cubo_w,nr_seq_populacao_p,nm_usuario_p);
		else
			CALL mprev_pop_alvo_pck.gerar_populacao_alvo(nr_seq_regra_cubo_w,nr_seq_populacao_p,nm_usuario_p);
		end if;
		dt_fim_geracao_w := clock_timestamp();
	end if;
	
	/* Atualizar a data de termino de geracao da populacao */

	update	mprev_populacao_alvo
	set	dt_fim_geracao 		= dt_fim_geracao_w,
		nm_usuario 			= nm_usuario_p,
		dt_atualizacao 		= clock_timestamp()
	where	nr_sequencia	= nr_seq_populacao_p;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gerar_populacao_alvo (nr_seq_populacao_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;
