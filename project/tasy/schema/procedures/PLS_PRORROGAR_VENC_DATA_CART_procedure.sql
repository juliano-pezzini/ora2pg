-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_prorrogar_venc_data_cart ( nr_seq_lote_p bigint, dt_vencimento_nova_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_segurado_w		bigint;
nr_seq_seg_carteira_w		bigint;
nr_seq_carteira_venc_w		bigint;
dt_rescisao_programada_w	timestamp;
dt_rescisao_w			timestamp;
ie_venc_cartao_rescisao_w	pls_parametros.ie_venc_cartao_rescisao%type;

C01 CURSOR FOR 
	SELECT	b.nr_seq_segurado, 
		a.nr_seq_seg_carteira, 
		a.nr_sequencia, 
		c.dt_rescisao 
	from	pls_carteira_vencimento a, 
		pls_segurado_carteira	b, 
		pls_segurado		c 
	where	a.nr_seq_seg_carteira	= b.nr_sequencia 
	and	b.nr_seq_segurado	= c.nr_sequencia 
	and	a.nr_seq_lote		= nr_seq_lote_p;
	

BEGIN 
 
select	ie_venc_cartao_rescisao 
into STRICT	ie_venc_cartao_rescisao_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_segurado_w, 
	nr_seq_seg_carteira_w, 
	nr_seq_carteira_venc_w, 
	dt_rescisao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	dt_rescisao_programada_w	:= null;
	 
	begin 
	dt_rescisao_programada_w	:= pls_obter_data_rescisao_seg(nr_seq_segurado_w, ie_venc_cartao_rescisao_w);
	exception 
	when others then 
		dt_rescisao_programada_w	:= null;
	end;
	 
	if (coalesce(dt_rescisao_programada_w::text, '') = '') then 
		dt_rescisao_programada_w	:= dt_rescisao_w;
	end if;
	 
	if (coalesce(dt_rescisao_programada_w,dt_vencimento_nova_p+1) > dt_vencimento_nova_p) then 
		update	pls_carteira_vencimento 
		set	DT_VALIDADE_PRORROGADA	= dt_vencimento_nova_p, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where	nr_sequencia		= nr_seq_carteira_venc_w;
	else	 
		update	pls_carteira_vencimento 
		set	DT_VALIDADE_PRORROGADA	= dt_rescisao_programada_w, 
			nm_usuario		= nm_usuario_p, 
			dt_atualizacao		= clock_timestamp() 
		where	nr_sequencia		= nr_seq_carteira_venc_w;
	end if;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_prorrogar_venc_data_cart ( nr_seq_lote_p bigint, dt_vencimento_nova_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
