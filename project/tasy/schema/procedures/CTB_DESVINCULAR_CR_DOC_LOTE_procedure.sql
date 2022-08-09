-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_desvincular_cr_doc_lote ( nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
qt_registro_w			bigint	:= 0;

c_titulo CURSOR FOR 
	SELECT	a.nr_titulo 
	from	titulo_receber	a 
	where	a.nr_lote_contabil	= nr_lote_contabil_p 
	and	not exists (SELECT	1 
				from	movimento_contabil_doc	x 
				where	x.nr_lote_contabil	= nr_lote_contabil_p 
				and	x.nr_documento		= a.nr_titulo);
				
c_titulo_w		c_titulo%rowtype;
				
c_baixa CURSOR FOR 
	SELECT	a.nr_titulo, 
		a.nr_sequencia 
	from	titulo_receber_liq	a 
	where	a.nr_lote_contabil	= nr_lote_contabil_p 
	and	not exists (SELECT	1 
				from	movimento_contabil_doc	x 
				where	x.nr_lote_contabil	= nr_lote_contabil_p 
				and	x.nr_documento		= a.nr_titulo);
				
c_baixa_w		c_baixa%rowtype;

c_baixa_ops CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	pls_titulo_rec_liq_mens	a 
	where	a.nr_lote_contabil	= nr_lote_contabil_p 
	and	not exists (SELECT	1 
				from	movimento_contabil_doc	x 
				where	x.nr_lote_contabil	= nr_lote_contabil_p 
				and	x.nr_documento		= a.nr_sequencia);
				
c_baixa_ops_w		c_baixa_ops%rowtype;


BEGIN 
open c_titulo;
loop 
fetch c_titulo into	 
	c_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c_titulo */
	begin 
	update	titulo_receber 
	set	nr_lote_contabil	= 0 
	where	nr_titulo		= c_titulo_w.nr_titulo;
	 
	qt_registro_w	:= qt_registro_w + 1;
	 
	if (qt_registro_w >= 400) then 
		qt_registro_w	:= 0;
		commit;
	end if;
	end;
end loop;
close c_titulo;
 
open c_baixa;
loop 
fetch c_baixa into	 
	c_baixa_w;
EXIT WHEN NOT FOUND; /* apply on c_baixa */
	begin 
	update	titulo_receber_liq 
	set	nr_lote_contabil	= 0 
	where	nr_titulo		= c_baixa_w.nr_titulo 
	and	nr_sequencia		= c_baixa_w.nr_sequencia;
	 
	qt_registro_w	:= qt_registro_w + 1;
	 
	if (qt_registro_w >= 400) then 
		qt_registro_w	:= 0;
		commit;
	end if;
	end;
end loop;
close c_baixa;
 
open c_baixa_ops;
loop 
fetch c_baixa_ops into	 
	c_baixa_ops_w;
EXIT WHEN NOT FOUND; /* apply on c_baixa_ops */
	begin 
	update	pls_titulo_rec_liq_mens 
	set	nr_lote_contabil	= 0 
	where	nr_sequencia		= c_baixa_ops_w.nr_sequencia;
	 
	qt_registro_w	:= qt_registro_w + 1;
	 
	if (qt_registro_w >= 400) then 
		qt_registro_w	:= 0;
		commit;
	end if;
	end;
end loop;
close c_baixa_ops;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_desvincular_cr_doc_lote ( nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
