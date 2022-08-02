-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_gerar_preco_resc () AS $body$
DECLARE

 
nr_seq_segurado_w			bigint;
cd_estabelecimento_w			integer;
qt_erro_w				bigint	:= 0;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		b.cd_estabelecimento 
	from	pls_segurado a, 
		pls_contrato b, 
		pls_plano c 
	where	a.nr_seq_contrato	= b.nr_sequencia 
	and	a.nr_seq_plano		= c.nr_sequencia 
	and	not exists (	SELECT	1 
				from	pls_segurado_preco x 
				where	x.nr_seq_segurado = a.nr_sequencia) 
	and	(a.dt_rescisao IS NOT NULL AND a.dt_rescisao::text <> '') 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	c.ie_preco not in ('2','3');


BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_segurado_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	begin 
	CALL PLS_Gerar_valor_segurado(	null, 
					nr_seq_segurado_w, 
					'L', 
					cd_estabelecimento_w, 
					'TASY', 
					'S', 
					clock_timestamp(), 
					'S', 
					'N', 
					'S', 
					'N');
	exception 
	when others then 
		qt_erro_w	:= qt_erro_w + 1;
	end;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_gerar_preco_resc () FROM PUBLIC;

