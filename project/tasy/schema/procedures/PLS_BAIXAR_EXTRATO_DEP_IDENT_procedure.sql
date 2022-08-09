-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baixar_extrato_dep_ident ( nr_seq_lote_extrato_p bigint, nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
nr_documento_w			varchar(255);
nr_seq_lote_deposito_w		bigint;
ie_tratar_conciliacao_w		varchar(1);
vl_lancamento_w			double precision;
	
C01 CURSOR FOR 
	SELECT	nr_documento, 
		vl_lancamento 
	from	banco_extrato_lanc 
	where	nr_seq_extrato		= nr_seq_lote_extrato_p 
	and	(cd_historico)::numeric 	= 1 
	order by 1;
	

BEGIN 
select	coalesce(max(ie_tratar_conciliacao),'N') 
into STRICT	ie_tratar_conciliacao_w 
from	parametro_deposito_ident 
where	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_tratar_conciliacao_w = 'S') then 
	open c01;
	loop 
	fetch c01 into	 
		nr_documento_w, 
		vl_lancamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin		 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_lote_deposito_w 
		from	deposito_identificado a 
		where	a.nr_seq_conta_banco					= nr_seq_conta_p 
		and	(a.nr_identificacao || a.ie_digito_ident)::numeric  	= nr_documento_w 
		and	coalesce(a.dt_deposito::text, '') = '' 
		and	a.cd_estabelecimento					= cd_estabelecimento_p;
		--and	a.vl_deposito						= vl_lancamento_w; 
		 
		if (nr_seq_lote_deposito_w IS NOT NULL AND nr_seq_lote_deposito_w::text <> '') then 
			CALL baixar_titulos_deposito_iden(nr_seq_lote_deposito_w,cd_estabelecimento_p,nm_usuario_p);
		end if;
		end;
	end loop;
	close C01;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baixar_extrato_dep_ident ( nr_seq_lote_extrato_p bigint, nr_seq_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
