-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mudar_status_lote ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
ie_status_w			varchar(2);
ie_status_ww			varchar(2);
qt_registros_w			bigint	:= 0;

c01 CURSOR(	nr_seq_lote_pc		pls_lote_protocolo.nr_sequencia%type) FOR 
	SELECT	nr_sequencia 
	from	pls_lote_protocolo_venc 
	where	nr_seq_lote = nr_seq_lote_pc;
	
c02 CURSOR(	nr_seq_lote_venc_pc	pls_lote_protocolo_venc.nr_sequencia%type) FOR 
	SELECT	nr_sequencia 
	from	pls_lote_prot_venc_trib 
	where	nr_seq_lote_venc = nr_seq_lote_venc_pc;
	
BEGIN 
 
select	ie_status 
into STRICT	ie_status_w 
from	pls_lote_protocolo 
where	nr_sequencia = nr_seq_lote_p;
 
if (ie_status_w = 'P') then 
	ie_status_ww := 'D';
	CALL pls_gerar_venc_lote_protocolo(nr_seq_lote_p,nm_usuario_p);
elsif (ie_status_w = 'D') then 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	titulo_pagar 
	where	nr_seq_lote_res_pls = nr_seq_lote_p 
	and	ie_situacao <> 'C';
	 
	if (qt_registros_w	> 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265561,''); -- Este lote possui título(s) vinculado(s), não pode ser alterado! 
	end if;
	 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	nota_fiscal 
	where	nr_seq_lote_res_pls = nr_seq_lote_p 
	and	ie_situacao = '1';
	 
	if (qt_registros_w	> 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265563,''); -- Este lote possui nota fiscal vinculada, não pode ser alterado! 
	end if;
	 
	-- Percorre todos os Vencimentos 
	for r_C01_w in C01( nr_seq_lote_p ) loop 
		-- Percorre todos os Tributos dos Vencimentos 
		for r_c02_w in c02( r_c01_w.nr_sequencia ) loop 
			delete	FROM pls_lote_prot_venc_trib 
			where	nr_sequencia = r_c02_w.nr_sequencia;
		end loop;
		delete	FROM pls_lote_protocolo_venc 
		where	nr_sequencia = r_C01_w.nr_sequencia;
	end loop;
	 
	ie_status_ww	:= 'P';
end if;
 
update	pls_lote_protocolo 
set	ie_status = ie_status_ww 
where	nr_sequencia = nr_seq_lote_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mudar_status_lote ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
