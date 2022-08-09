-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_altera_status_fatura (nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nr_seq_ajuste_gerado_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_conta_w			pls_fatura_conta.nr_seq_conta%type;
nr_seq_lote_w			pls_fatura.nr_seq_lote%type;
nr_seq_analise_w		pls_conta.nr_seq_analise%type;
ie_novo_pos_estab_w		pls_visible_false.ie_novo_pos_estab%type := 'N';

c01 CURSOR FOR 
	SELECT	b.nr_seq_conta, 
		c.nr_seq_lote 
	from	pls_fatura_conta b, 
		pls_fatura_evento a, 
		pls_fatura c 
	where	a.nr_sequencia	= b.nr_seq_fatura_evento 
	and	b.nr_seq_conta	in (SELECT	x.nr_seq_conta			/* Somente contas que NECESSITAM de ajuste */
 
				from	w_pls_fatura_refat x) 
	and	a.nr_seq_fatura = c.nr_sequencia 
	and	a.nr_seq_fatura	= nr_seq_fatura_p;
	
C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_auditoria_conta_grupo 
	where	nr_seq_analise	= nr_seq_analise_w 
	order by nr_seq_ordem desc;
	
BEGIN 
 
select	coalesce(max(ie_novo_pos_estab), 'N') 
into STRICT	ie_novo_pos_estab_w 
from	pls_visible_false 
where	cd_estabelecimento = cd_estabelecimento_p;
 
if (ie_novo_pos_estab_w = 'S') then 
	nr_seq_ajuste_gerado_p := pls_faturamento_pck.altera_status_fatura(nr_seq_fatura_p, cd_estabelecimento_p, nr_seq_ajuste_gerado_p, nm_usuario_p);
else 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_conta_w, 
		nr_seq_lote_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		 
		select	max(nr_seq_analise) 
		into STRICT	nr_seq_analise_w 
		from	pls_conta_pos_estabelecido 
		where	nr_seq_conta	= nr_seq_conta_w 
		and	nr_seq_lote_fat = nr_seq_lote_w;
		 
		if (nr_seq_analise_w IS NOT NULL AND nr_seq_analise_w::text <> '') then 
			update	pls_conta_pos_estabelecido 
			set	ie_status_faturamento	= 'D', 
				nr_seq_lote_fat		 = NULL, 
				nr_seq_evento_fat	 = NULL, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_analise		= nr_seq_analise_w 
			and	nr_seq_lote_fat		= nr_seq_lote_w;
			 
			CALL pls_desfazer_fechar_conta_aud(nr_seq_analise_w,	cd_estabelecimento_p,nm_usuario_p);
			 
			for r_c02_w in C02() loop 
				begin 
				CALL pls_desf_final_grupo_analise( 	nr_seq_analise_w, null, r_c02_w.nr_sequencia, 
								nm_usuario_p, cd_estabelecimento_p, 'S');
				end;
			end loop;
		else 
			update	pls_conta_pos_estabelecido 
			set	ie_status_faturamento	= 'D', 
				nr_seq_lote_fat		 = NULL, 
				nr_seq_evento_fat	 = NULL, 
				dt_atualizacao		= clock_timestamp(), 
				nm_usuario		= nm_usuario_p 
			where	nr_seq_conta		= nr_seq_conta_w 
			and	nr_seq_lote_fat		= nr_seq_lote_w;
		end if;
		 
	end loop;
	close c01;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_altera_status_fatura (nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nr_seq_ajuste_gerado_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
