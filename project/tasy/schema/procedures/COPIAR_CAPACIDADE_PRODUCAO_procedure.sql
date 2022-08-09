-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_capacidade_producao ( cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nr_seq_tabela_origem_p bigint, nr_seq_tabela_dest_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_centro_controle_w	integer;
cd_estabelecimento_w	bigint;
nr_seq_tabela_w		bigint;
cd_empresa_w		bigint;
nr_seq_tabela_ww		bigint;
dt_mes_referencia_w	timestamp;
qt_registro_w		bigint;

c01 CURSOR FOR
SELECT	distinct
	c.nr_sequencia,
	a.cd_estabelecimento,
	a.cd_centro_controle
from 	tabela_custo c,
	capac_centro_controle b,
	centro_controle a
where 	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.cd_centro_controle	= b.cd_centro_controle
and	b.nr_seq_tabela		= c.nr_sequencia
/*and	c.dt_mes_referencia	= dt_mes_referencia_w
and	c.cd_empresa		= cd_empresa_w
and	((cd_estab_tabela_w is null) or	(c.cd_estabelecimento = cd_estab_tabela_w))*/

/*OS1992919 - Jean - Projeto Da vita - Inicio */

and	exists (	SELECT	1
		from	tabela_custo_acesso_v tca
		where	tca.nr_sequencia	= nr_seq_tabela_origem_p
		and	tca.nr_sequencia	= b.nr_seq_tabela
		and	tca.cd_empresa		= c.cd_empresa
		and	tca.cd_estabelecimento	= b.cd_estabelecimento);/*OS2006653 - Jeferson Job - Campo cd_estabelecimento da tabela_custo sempre vem nulo*/

/*OS1992919 - Jean - Projeto Da vita - Final*/

BEGIN

delete	from capac_centro_controle
where	nr_seq_tabela		= nr_seq_tabela_dest_p;

delete	from capac_centro_controle
where	cd_tabela_custo		= cd_tabela_destino_p;
--and	((cd_estabelecimento 	= cd_estabelecimento_p) or (cd_estabelecimento is null));
commit;

open c01;
loop
    	fetch c01 into
		nr_seq_tabela_ww,
		cd_estabelecimento_w,
	 	cd_centro_controle_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	capac_centro_controle
	where	nr_seq_tabela = nr_seq_tabela_dest_p
	and	cd_estabelecimento	= cd_estabelecimento_w
	and	cd_centro_controle	= cd_centro_controle_w;

	if (qt_Registro_w = 0) then
		insert into capac_centro_controle(cd_estabelecimento,
			cd_tabela_custo,
			cd_centro_controle,
			nr_sequencia_nivel,
			cd_nivel_capacidade,
			qt_disponibilidade,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_tabela )
		SELECT
			cd_estabelecimento_w,
			cd_tabela_destino_p,
			cd_centro_controle_w,
			nr_sequencia_nivel,
			cd_nivel_capacidade,
			qt_disponibilidade,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_tabela_dest_p
		from	capac_centro_controle
		where	nr_seq_tabela = nr_seq_tabela_ww
		and	cd_estabelecimento = cd_estabelecimento_w
		and	cd_centro_controle = cd_centro_controle_w;

		insert into reduc_capac_centro_controle(cd_estabelecimento,
			cd_tabela_custo,
			cd_centro_controle,
			nr_sequencia_nivel,
			cd_redutor_capacidade,
			qt_reducao,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_tabela)
		SELECT
			cd_estabelecimento_w,
			cd_tabela_destino_p,
			cd_centro_controle_w,
			nr_sequencia_nivel,
			cd_redutor_capacidade,
			qt_reducao,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_tabela_dest_p
		from	reduc_capac_centro_controle
		where	nr_seq_tabela = nr_seq_tabela_ww
		and	cd_estabelecimento = cd_estabelecimento_w
		and	cd_centro_controle = cd_centro_controle_w
		and	exists (	SELECT	1
				from	capac_centro_controle
				where	nr_seq_tabela = nr_seq_tabela_ww
				and	cd_estabelecimento = cd_estabelecimento_w
				and	cd_centro_controle = cd_centro_controle_w);

	end if;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_capacidade_producao ( cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nr_seq_tabela_origem_p bigint, nr_seq_tabela_dest_p bigint, nm_usuario_p text) FROM PUBLIC;
