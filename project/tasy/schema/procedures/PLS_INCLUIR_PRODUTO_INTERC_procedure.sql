-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_incluir_produto_interc ( nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_tabela_w			bigint;
qt_registros_w			bigint;
ie_preco_w			varchar(2);
ie_tabela_contrato_w		varchar(2);
ie_tipo_contratacao_w		varchar(3);
cd_pf_estipulante_w		varchar(10);
nr_contrato_w			bigint;
nm_estipulante_w		varchar(80);
nr_seq_interc_plano_w		bigint;
ds_erro_w			varchar(4000) := '';
qt_produtos_w			bigint;

c01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_intercambio_plano 
	where	nr_seq_intercambio = nr_seq_intercambio_p;


BEGIN 
 
if (coalesce(nr_seq_plano_p::text, '') = '') or (coalesce(nr_seq_plano_p,0) = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(198560, null);
	/* É necessário informar um produto! */
 
end if;
 
select	ie_preco, 
	ie_tipo_contratacao 
into STRICT	ie_preco_w, 
	ie_tipo_contratacao_w 
from	pls_plano 
where	nr_sequencia	= nr_seq_plano_p;
 
if (ie_preco_w	in ('1','4')) and 
	((coalesce(nr_seq_tabela_p::text, '') = '') or (coalesce(nr_seq_tabela_p,0) = 0)) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(198561, null);
	/* Tabela não informada para o produto! */
 
end if;
 
if (coalesce(nr_seq_intercambio_p,0) > 0) then 
	open c01;
	loop 
	fetch c01 into	 
		nr_seq_interc_plano_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		ds_erro_w := pls_consiste_intercambio_plano(nr_seq_intercambio_p, nr_seq_plano_p, nr_seq_tabela_p, nr_seq_interc_plano_w, ds_erro_w);
 
		if (coalesce(ds_erro_w,'X') <> 'X') then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(198562, 'DS_ERRO=' || ds_erro_w);
		end if;
 
	end loop;
	close c01;
	 
	insert into	pls_intercambio_plano(	nr_sequencia, nr_seq_intercambio, nr_seq_plano, 
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_tabela, ie_situacao) 
	values (	nextval('pls_intercambio_plano_seq'), nr_seq_intercambio_p, nr_seq_plano_p, 
			clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_seq_tabela_p, 'A');
	 
	if (ie_preco_w in ('1','4')) then 
		CALL pls_gerar_tabela_intercambio(nr_seq_intercambio_p, nr_seq_plano_p, nr_seq_tabela_p, cd_estabelecimento_p, 'N', nm_usuario_p);
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_incluir_produto_interc ( nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

