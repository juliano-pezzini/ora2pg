-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_tabela_contrato ( nr_seq_contrato_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nr_seq_tabela_nova_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_contrato_w			timestamp;
nr_seq_tabela_w			bigint;
qt_idade_inicial_w		integer;
qt_idade_final_w		integer;
vl_preco_atual_w		double precision;
tx_acrescimo_w			double precision;
qt_registros_w			bigint;
ie_tabela_contrato_w		varchar(1);
nm_estipulante_w		varchar(80);
ie_tipo_contratacao_w		varchar(3);
vl_preco_nao_subsidiado_w	double precision;
ie_preco_w			varchar(2);
nr_seq_contrato_tabela_w	bigint;
nr_contrato_w			bigint;
vl_minimo_w			double precision;
ie_grau_titularidade_w		varchar(2);
vl_adaptacao_w			double precision;
vl_preco_nao_subsid_atual_w   double precision;
ie_manutencao_preco_w      varchar(1);
qt_vidas_inicial_w       bigint;
qt_vidas_final_w        bigint;
vl_preco_inicial_w		pls_plano_preco.vl_preco_inicial%type;	
 
c01 CURSOR FOR 
	SELECT	qt_idade_inicial, 
		qt_idade_final, 
		vl_preco_inicial, 
		vl_preco_atual, 
		tx_acrescimo, 
		vl_preco_nao_subsidiado, 
		vl_minimo, 
		ie_grau_titularidade, 
		vl_adaptacao, 
		vl_preco_nao_subsid_atual, 
		ie_manutencao_preco, 
		qt_vidas_inicial, 
		qt_vidas_final 
	from	pls_plano_preco 
	where	nr_seq_tabela	= nr_seq_tabela_p 
	order by qt_idade_inicial;


BEGIN 
 
if (coalesce(nr_seq_tabela_p::text, '') = '') then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 198418, null);
	/* A tabela não pôde ser gerada pois não foi informada uma tabela base! */
 
end if;
 
select	coalesce(max(ie_preco),0) 
into STRICT	ie_preco_w 
from	pls_plano 
where	nr_sequencia	= nr_seq_plano_p;
 
if (ie_preco_w in (1,4)) then 
	select	nr_contrato, 
		coalesce(dt_contrato,clock_timestamp()), 
		substr(obter_nome_pf_pj(cd_pf_estipulante,cd_cgc_estipulante),1,80) 
	into STRICT	nr_contrato_w, 
		dt_contrato_w, 
		nm_estipulante_w 
	from	pls_contrato 
	where	nr_sequencia	= nr_seq_contrato_p;
 
	if (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') and (nr_seq_tabela_p IS NOT NULL AND nr_seq_tabela_p::text <> '') then 
		 
		select	nextval('pls_tabela_preco_seq') 
		into STRICT	nr_seq_tabela_w 
		;
		 
		insert into pls_tabela_preco(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nm_tabela, 
			dt_inicio_vigencia, 
			nr_seq_plano, 
			cd_codigo_ant, 
			ie_tabela_base, 
			nr_contrato, 
			nr_seq_tabela_origem, 
			nr_seq_faixa_etaria, 
			ie_tabela_contrato, 
			nr_segurado, 
			ie_proposta_adesao, 
			ie_simulacao_preco, 
			nr_seq_sca, 
			nr_seq_tabela_ant, 
			nr_seq_proposta, 
			nr_seq_contrato_inter, 
			nr_seq_tabela_original, 
			nr_seq_contrato_repasse, 
			ie_preco_vidas_contrato, 
			ie_calculo_vidas, 
			tx_adaptacao, 
			nr_seq_tabela_interc, 
			dt_liberacao) 
		SELECT	nr_seq_tabela_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			'Tabela para o contrato ' || to_char(nr_contrato_w) || ' - ' || nm_estipulante_w || ' - 2 ', 
			dt_contrato_w, 
			nr_seq_plano_p, 
			cd_codigo_ant, 
			'N', 
			nr_seq_contrato_p, 
			nr_sequencia, 
			nr_seq_faixa_etaria, 
			ie_tabela_contrato, 
			nr_segurado, 
			ie_proposta_adesao, 
			ie_simulacao_preco, 
			nr_seq_sca, 
			nr_seq_tabela_ant, 
			nr_seq_proposta, 
			nr_seq_contrato_inter, 
			nr_seq_tabela_original, 
			nr_seq_contrato_repasse, 
			ie_preco_vidas_contrato, 
			ie_calculo_vidas, 
			tx_adaptacao, 
			nr_seq_tabela_interc, 
			clock_timestamp() 
		from	pls_tabela_preco 
		where	nr_sequencia	= nr_seq_tabela_p;
		 
		open c01;
		loop 
		fetch c01 into	qt_idade_inicial_w, 
				qt_idade_final_w, 
				vl_preco_inicial_w, 
				vl_preco_atual_w, 
				tx_acrescimo_w, 
				vl_preco_nao_subsidiado_w, 
				vl_minimo_w, 
				ie_grau_titularidade_w, 
				vl_adaptacao_w, 
				vl_preco_nao_subsid_atual_w, 
				ie_manutencao_preco_w, 
				qt_vidas_inicial_w, 
				qt_vidas_final_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		 
			insert into pls_plano_preco(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				nr_seq_tabela, 
				qt_idade_inicial, 
				qt_idade_final, 
				vl_preco_inicial, 
				vl_preco_atual, 
				tx_acrescimo, 
				vl_preco_nao_subsidiado, 
				vl_minimo, 
				ie_grau_titularidade, 
				vl_adaptacao, 
				vl_preco_nao_subsid_atual, 
				ie_manutencao_preco, 
				qt_vidas_inicial, 
				qt_vidas_final) 
			values (nextval('pls_plano_preco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_tabela_w, 
				qt_idade_inicial_w, 
				qt_idade_final_w, 
				vl_preco_inicial_w, 
				vl_preco_atual_w, 
				tx_acrescimo_w, 
				vl_preco_nao_subsidiado_w, 
				vl_minimo_w, 
				ie_grau_titularidade_w, 
				vl_adaptacao_w, 
				vl_preco_nao_subsid_atual_w, 
				ie_manutencao_preco_w, 
				qt_vidas_inicial_w, 
				qt_vidas_final_w);
		end loop;
		close c01;
		 
		update	pls_contrato_plano 
		set	nr_seq_tabela	= nr_seq_tabela_w, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp() 
		where	nr_seq_contrato	= nr_seq_contrato_p 
		and	nr_seq_tabela	= nr_seq_tabela_p 
		and	nr_seq_plano	= nr_seq_plano_p;
		 
		update	pls_tabela_preco 
		set	dt_fim_vigencia	= clock_timestamp() 
		where	nr_sequencia	= nr_seq_tabela_p;
		 
		insert into pls_contrato_historico(	nr_sequencia, 
					cd_estabelecimento, 
					nr_seq_contrato, 
					dt_historico, 
					ie_tipo_historico, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					ds_historico) 
				values (	nextval('pls_contrato_historico_seq'), 
					cd_estabelecimento_p, 
					nr_seq_contrato_p, 
					clock_timestamp(), 
					3, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					'Alteração de tabela de preço do contrato');
	end if;
end if;
 
commit;
 
nr_seq_tabela_nova_p	:= nr_seq_tabela_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_tabela_contrato ( nr_seq_contrato_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nr_seq_tabela_nova_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

