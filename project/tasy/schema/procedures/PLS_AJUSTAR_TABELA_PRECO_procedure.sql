-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_tabela_preco ( nr_seq_tabela_origem_p bigint, nr_seq_tabela_destino_p bigint, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp) AS $body$
DECLARE

 
nr_seq_segurado_w		bigint;
nr_seq_tabela_ant_w		bigint;
nm_tabela_ant_w			varchar(255);
nr_seq_contrato_w		bigint;
cd_estabelecimento_w		smallint;
nm_tabela_destino_w		varchar(255);

C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_segurado 
	where	nr_seq_tabela	= nr_seq_tabela_origem_p 
	and	trunc(dt_contratacao,'dd') between trunc(dt_inicio_vigencia_p,'dd') and trunc(dt_fim_vigencia_p,'dd');


BEGIN 
 
select	nm_tabela 
into STRICT	nm_tabela_destino_w 
from	pls_tabela_preco 
where	nr_sequencia  = nr_seq_tabela_destino_p;
 
open c01;
loop 
fetch c01 into 
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	 
	select	a.nr_seq_tabela, 
		b.nm_tabela, 
		a.nr_seq_contrato 
	into STRICT	nr_seq_tabela_ant_w, 
		nm_tabela_ant_w, 
		nr_seq_contrato_w 
	from	pls_segurado a, 
		pls_tabela_preco b 
	where	a.nr_seq_tabela = b.nr_sequencia 
	and	a.nr_sequencia = nr_seq_segurado_w;
	 
	update	pls_segurado 
	set	nr_seq_tabela	= nr_seq_tabela_destino_p 
	where	nr_sequencia	= nr_seq_segurado_w;
	 
	select	cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from	pls_contrato 
	where	nr_sequencia	= nr_seq_contrato_w;
	 
	CALL pls_gerar_valor_segurado(null, nr_seq_segurado_w, 'A', 
		cd_estabelecimento_w, 'TASY', 'S', 
		clock_timestamp(), 'S', 'N', 
		'N', 'N');
		 
	/* Gerar histórico */
 
	CALL pls_gerar_segurado_historico( 
		nr_seq_segurado_w, '3', clock_timestamp(), 
		'Mudança de tabela para titular e dependentes', 
		'Alterada tabela de preço de '||nr_seq_tabela_ant_w||' - '||nm_tabela_ant_w || ' para ' || 
			nr_seq_tabela_destino_p || ' - ' || nm_tabela_destino_w, 
		null, 
		null, null, null, 
		clock_timestamp(), null, null, 
		null, null, null, 
		null, 'Tasy', 'S');
		 
	CALL pls_gerar_desconto_contrato(nr_seq_contrato_w, clock_timestamp(), 'TASY', cd_estabelecimento_w);
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_tabela_preco ( nr_seq_tabela_origem_p bigint, nr_seq_tabela_destino_p bigint, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp) FROM PUBLIC;
