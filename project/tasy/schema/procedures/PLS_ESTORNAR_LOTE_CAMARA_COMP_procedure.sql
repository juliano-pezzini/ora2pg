-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_estornar_lote_camara_comp ( nr_seq_lote_p pls_lote_camara_comp.nr_sequencia%type, dt_estorno_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Estonar a procedure PLS_BAIXAR_LOTE_CAMARA_COMP
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

nr_titulo_receber_w		titulo_receber.nr_titulo%type;
nr_titulo_pagar_w		pls_lote_camara_comp.nr_tit_pagar_taxa%type;
nr_seq_baixa_w			titulo_pagar_baixa.nr_sequencia%type;
nr_seq_tit_lote_cam_w		pls_titulo_lote_camara.nr_sequencia%type;
vl_titulo_w			titulo_receber.vl_titulo%type;
vl_saldo_titulo_w		titulo_receber.vl_saldo_titulo%type;

C01 CURSOR(nr_seq_lote_pc	pls_lote_camara_comp.nr_sequencia%type)FOR
	SELECT	a.nr_titulo_receber,
		a.nr_titulo_pagar,
		a.nr_sequencia nr_seq_tit_lote_cam
	from	pls_titulo_lote_camara a
	where	a.nr_seq_lote_camara	= nr_seq_lote_pc;

BEGIN

-- CANCELAR OS TÍTULOS GERADOS
select	max(nr_tit_pagar_taxa)
into STRICT	nr_titulo_pagar_w
from	pls_lote_camara_comp
where	nr_sequencia = nr_seq_lote_p;

if (nr_titulo_pagar_w IS NOT NULL AND nr_titulo_pagar_w::text <> '') then
	delete	FROM pls_titulo_lote_camara
	where	nr_titulo_pagar	= nr_titulo_pagar_w;
	
	select	max(nr_sequencia)
	into STRICT	nr_seq_baixa_w
	from	titulo_pagar_baixa
	where	nr_titulo		= nr_titulo_pagar_w;
	
	if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then
		CALL estornar_tit_pagar_baixa(nr_titulo_pagar_w,nr_seq_baixa_w,dt_estorno_p,nm_usuario_p,'N');
	end if;

	CALL cancelar_titulo_pagar(nr_titulo_pagar_w,nm_usuario_p,clock_timestamp());
end if;

select	max(nr_titulo)
into STRICT	nr_titulo_pagar_w
from	titulo_pagar
where	nr_seq_pls_lote_camara = nr_seq_lote_p;

if (nr_titulo_pagar_w IS NOT NULL AND nr_titulo_pagar_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_baixa_w
	from	titulo_pagar_baixa
	where	nr_titulo		= nr_titulo_pagar_w;
	
	if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then
		CALL estornar_tit_pagar_baixa(nr_titulo_pagar_w,nr_seq_baixa_w,dt_estorno_p,nm_usuario_p,'N');
	end if;

	CALL cancelar_titulo_pagar(nr_titulo_pagar_w,nm_usuario_p,clock_timestamp());
end if;

select	max(nr_titulo)
into STRICT	nr_titulo_receber_w
from	titulo_receber
where	nr_seq_pls_lote_camara = nr_seq_lote_p;

if (nr_titulo_receber_w IS NOT NULL AND nr_titulo_receber_w::text <> '') then
	select	coalesce(max(vl_titulo), 0),
		coalesce(max(vl_saldo_titulo), 0)
	into STRICT	vl_titulo_w,
		vl_saldo_titulo_w
	from	titulo_receber
	where	nr_titulo = nr_titulo_receber_w;
	
	if (vl_titulo_w <> vl_saldo_titulo_w) then
		select	max(nr_sequencia)
		into STRICT	nr_seq_baixa_w
		from	titulo_receber_liq
		where	nr_titulo = nr_titulo_receber_w;
		
		if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then
			CALL estornar_tit_receber_liq(nr_titulo_receber_w,nr_seq_baixa_w,dt_estorno_p,nm_usuario_p,'N',null,'P');
		end if;
	end if;
	
	CALL cancelar_titulo_receber(nr_titulo_receber_w,nm_usuario_p,'N',clock_timestamp());
end if;

-- ESTORNAR OS TÍTULOS
for r_C01_w in C01(nr_seq_lote_p) loop
	begin
	if (r_C01_w.nr_titulo_receber IS NOT NULL AND r_C01_w.nr_titulo_receber::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_baixa_w
		from	titulo_receber_liq
		where	nr_titulo		= r_C01_w.nr_titulo_receber
		and	nr_seq_pls_lote_camara	= nr_seq_lote_p;
		
		if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then
			dbms_application_info.SET_ACTION('PLS_ESTORNAR_LOTE_CAMARA_COMP');
			CALL estornar_tit_receber_liq(r_C01_w.nr_titulo_receber,nr_seq_baixa_w,dt_estorno_p,nm_usuario_p,'N',null,'P');
			
			update	pls_titulo_lote_camara
			set	vl_baixado	= 0
			where	nr_sequencia	= r_C01_w.nr_seq_tit_lote_cam;
		end if;
	elsif (r_C01_w.nr_titulo_pagar IS NOT NULL AND r_C01_w.nr_titulo_pagar::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_baixa_w
		from	titulo_pagar_baixa
		where	nr_titulo		= r_C01_w.nr_titulo_pagar
		and	nr_seq_pls_lote_camara	= nr_seq_lote_p;
		
		if (nr_seq_baixa_w IS NOT NULL AND nr_seq_baixa_w::text <> '') then
			dbms_application_info.SET_ACTION('PLS_ESTORNAR_LOTE_CAMARA_COMP');
			CALL estornar_tit_pagar_baixa(r_C01_w.nr_titulo_pagar,nr_seq_baixa_w,dt_estorno_p,nm_usuario_p,'S');
			
			update	pls_titulo_lote_camara
			set	vl_baixado	= 0
			where	nr_sequencia	= r_C01_w.nr_seq_tit_lote_cam;
		end if;
	end if;
	end;
end loop;

-- ATUALIZAR AS INFORMAÇÕES DO LOTE
update	pls_lote_camara_comp
set	nr_tit_pagar_taxa	 = NULL,
	dt_baixa		 = NULL,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_estornar_lote_camara_comp ( nr_seq_lote_p pls_lote_camara_comp.nr_sequencia%type, dt_estorno_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

