-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_simulacao_preco_pck.obter_valor_simulacao (nr_seq_simulacao_p bigint, ie_tipo_contratacao_p text, nr_seq_simul_perfil_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint) RETURNS bigint AS $body$
DECLARE

	vl_simulacao_w	double precision;
	nr_seq_plano_w	bigint;
	nr_seq_tabela_w	bigint;
	
	
BEGIN
	
	if (ie_tipo_contratacao_p <> 'I') and (coalesce(nr_seq_simul_perfil_p::text, '') = '') then
		select	sum(pls_simulacao_preco_pck.obter_valor_simulacao(nr_seq_simulacao,null,nr_sequencia,null,null)) vl_perfil
		into STRICT	vl_simulacao_w
		from	pls_simulacao_perfil
		where	nr_seq_simulacao = nr_seq_simulacao_p;
	else
		if (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') then
			nr_seq_plano_w	:= nr_seq_plano_p;
			nr_seq_tabela_w	:= nr_seq_tabela_p;
		elsif (nr_seq_simul_perfil_p IS NOT NULL AND nr_seq_simul_perfil_p::text <> '') then
			begin
			select	nr_seq_plano,
				nr_seq_tabela
			into STRICT	nr_seq_plano_w,
				nr_seq_tabela_w
			from	pls_simul_perfil_tabela
			where	nr_seq_simul_perfil	= nr_seq_simul_perfil_p
			and	ie_tabela_selecionada = 'S';
			exception
			when others then
				nr_seq_plano_w	:= null;
				nr_seq_tabela_w	:= null;
			end;
		else
			nr_seq_plano_w	:= null;
			nr_seq_tabela_w	:= null;
		end if;
		
		select	sum(vl_item)
		into STRICT	vl_simulacao_w
		from	table(pls_simulacao_preco_pck.obter_resumo_simulacao(nr_seq_simulacao_p,nr_seq_simul_perfil_p,nr_seq_plano_w,nr_seq_tabela_w,'S'))
		where	ie_totalizador = 'S';
	end if;
	
	return coalesce(vl_simulacao_w,0);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_simulacao_preco_pck.obter_valor_simulacao (nr_seq_simulacao_p bigint, ie_tipo_contratacao_p text, nr_seq_simul_perfil_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint) FROM PUBLIC;