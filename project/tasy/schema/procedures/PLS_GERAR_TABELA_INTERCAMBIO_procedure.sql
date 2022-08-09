-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tabela_intercambio ( nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
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
nr_intercambio_w		bigint;
vl_minimo_w			double precision;
ie_grau_titularidade_w		varchar(2);

qt_vidas_inicial_w		bigint;
qt_vidas_final_w		bigint;

c01 CURSOR FOR 
	SELECT	qt_idade_inicial, 
		qt_idade_final, 
		vl_preco_atual, 
		tx_acrescimo, 
		vl_preco_nao_subsidiado, 
		vl_minimo, 
		ie_grau_titularidade, 
		qt_vidas_inicial, 
		qt_vidas_final 
	from	pls_plano_preco 
	where	nr_seq_tabela	= nr_seq_tabela_p 
	order by qt_idade_inicial;


BEGIN 
 
if (coalesce(nr_seq_tabela_p::text, '') = '') then 
	--r aise_application_error(-20011,'A tabela não pôde ser gerada pois não foi informada uma tabela base!'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(249956);
end if;
 
select	coalesce(max(ie_preco),0) 
into STRICT	ie_preco_w 
from	pls_plano 
where	nr_sequencia	= nr_seq_plano_p;
 
if (ie_preco_w in (1,4)) then	 
 
	select	nr_sequencia, 
		coalesce(dt_inclusao,clock_timestamp()), 
		substr(obter_nome_pf_pj(cd_pessoa_fisica,cd_cgc),1,80) 
	into STRICT	nr_intercambio_w, 
		dt_contrato_w, 
		nm_estipulante_w 
	from	pls_intercambio 
	where	nr_sequencia	= nr_seq_intercambio_p;
	 
	select	coalesce(max(nr_seq_contrato_inter),0) 
	into STRICT	nr_seq_contrato_tabela_w 
	from	pls_tabela_preco 
	where	nr_sequencia	= nr_seq_tabela_p;
	 
	if (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') and (nr_seq_tabela_p IS NOT NULL AND nr_seq_tabela_p::text <> '') and (nr_seq_contrato_tabela_w = 0) then 
		 
		select	nextval('pls_tabela_preco_seq') 
		into STRICT	nr_seq_tabela_w 
		;
		 
		insert into pls_tabela_preco(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nm_tabela, 
			dt_inicio_vigencia, 
			nr_seq_plano, 
			dt_liberacao, 
			ie_tabela_base, 
			nr_seq_contrato_inter, 
			nr_seq_tabela_origem, 
			ie_preco_vidas_contrato, 
			ie_calculo_vidas, 
			nr_seq_faixa_etaria) 
		SELECT	nr_seq_tabela_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			'Tabela para o contrato de intercâmbio ' || to_char(nr_intercambio_w) || ' - ' || nm_estipulante_w, 
			dt_contrato_w, 
			nr_seq_plano_p, 
			clock_timestamp(), 
			'N', 
			nr_seq_intercambio_p, 
			nr_sequencia, 
			ie_preco_vidas_contrato, 
			ie_calculo_vidas, 
			nr_seq_faixa_etaria 
		from	pls_tabela_preco 
		where	nr_sequencia	= nr_seq_tabela_p;
		 
		open c01;
		loop 
		fetch c01 into 
			qt_idade_inicial_w, 
			qt_idade_final_w, 
			vl_preco_atual_w, 
			tx_acrescimo_w, 
			vl_preco_nao_subsidiado_w, 
			vl_minimo_w, 
			ie_grau_titularidade_w, 
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
				qt_vidas_inicial, 
				qt_vidas_final) 
			values (nextval('pls_plano_preco_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_tabela_w, 
				qt_idade_inicial_w, 
				qt_idade_final_w, 
				vl_preco_atual_w, 
				vl_preco_atual_w, 
				tx_acrescimo_w, 
				vl_preco_nao_subsidiado_w, 
				vl_minimo_w, 
				ie_grau_titularidade_w, 
				qt_vidas_inicial_w, 
				qt_vidas_final_w);
		end loop;
		close c01;
		 
		update	pls_intercambio_plano 
		set	nr_seq_tabela		= nr_seq_tabela_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp(), 
			nr_seq_tabela_origem	= nr_seq_tabela_p 
		where	nr_seq_intercambio	= nr_seq_intercambio_p 
		and	nr_seq_plano		= nr_seq_plano_p;
	end if;
end if;
 
if (ie_commit_p = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tabela_intercambio ( nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
