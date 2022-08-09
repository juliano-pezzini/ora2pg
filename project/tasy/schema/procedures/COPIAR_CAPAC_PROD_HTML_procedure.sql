-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_capac_prod_html (cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, nr_seq_tabela_dest_p bigint, nm_usuario_p text, nr_seq_tabela_origem_p bigint default null) AS $body$
DECLARE


cd_tabela_destino_w 	tabela_custo.cd_tabela_custo%type;	
nr_seq_tabela_origem_w	tabela_custo.nr_sequencia%type;			
				

BEGIN
/*OS2006653 - Jeferson Job - Colocado aqui pois o nr_seq_tabela_origem_p pode vir nulo*/

cd_tabela_destino_w := obter_tab_custo_html(nr_seq_tabela_dest_p);
nr_seq_tabela_origem_w:= nr_seq_tabela_origem_p;

if ( coalesce(nr_seq_tabela_origem_p, 0) = 0 ) then
	select	max(nr_sequencia)
	into STRICT	nr_seq_tabela_origem_w
	from	tabela_custo
	where	cd_tabela_custo = cd_tabela_origem_p
	and	cd_estabelecimento = cd_estabelecimento_p;
end if;

CALL copiar_capacidade_producao(cd_estabelecimento_p,
				cd_tabela_origem_p,
				cd_tabela_destino_w,
				nr_seq_tabela_origem_w,
				nr_seq_tabela_dest_p,
				nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_capac_prod_html (cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, nr_seq_tabela_dest_p bigint, nm_usuario_p text, nr_seq_tabela_origem_p bigint default null) FROM PUBLIC;
