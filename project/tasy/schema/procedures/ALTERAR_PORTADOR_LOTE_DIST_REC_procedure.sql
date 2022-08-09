-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_portador_lote_dist_rec ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	 
nr_seq_dist_rec_w			distribuicao_receita.nr_sequencia%type;
nr_seq_cobr_escrit_w			distribuicao_receita.nr_seq_cobr_escrit%type;
nr_seq_conta_banco_w			distribuicao_receita.nr_seq_conta_banco%type;
nr_titulo_w				titulo_receber_dist_rec.nr_titulo%type;

c_dist_receita CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_cobr_escrit, 
		a.nr_seq_conta_banco 
	from	distribuicao_receita	a 
	where	a.nr_seq_lote	= nr_seq_lote_p;
	
c_titulos CURSOR FOR 
	SELECT	a.nr_titulo 
	from	titulo_receber_dist_rec	a 
	where	a.nr_seq_dist_rec	= nr_seq_dist_rec_w;
	

BEGIN 
open c_dist_receita;
loop 
fetch c_dist_receita into	 
	nr_seq_dist_rec_w, 
	nr_seq_cobr_escrit_w, 
	nr_seq_conta_banco_w;
EXIT WHEN NOT FOUND; /* apply on c_dist_receita */
	begin 
	open c_titulos;
	loop 
	fetch c_titulos into	 
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c_titulos */
		begin 
		CALL alterar_portador_titulo(	nr_titulo_w, 
						nr_seq_cobr_escrit_w, 
						nr_seq_conta_banco_w, 
						cd_estabelecimento_p, 
						nm_usuario_p);
		end;
	end loop;
	close c_titulos;
	end;
end loop;
close c_dist_receita;
 
update	lote_distribuicao_receita 
set	dt_alt_portador	= clock_timestamp() 
where	nr_sequencia	= nr_seq_lote_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_portador_lote_dist_rec ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
