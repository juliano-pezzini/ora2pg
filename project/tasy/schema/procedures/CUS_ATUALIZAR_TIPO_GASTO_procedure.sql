-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_atualizar_tipo_gasto ( cd_estabelecimento_p bigint, nr_seq_tabela_p bigint, cd_tabela_custo_p bigint) AS $body$
DECLARE


cd_centro_controle_w		integer;
cd_natureza_gasto_w		numeric(20);
ie_tipo_gasto_w			varchar(2);
ie_tipo_gasto_gng_w		varchar(2);
nr_sequencia_w			bigint;
nr_seq_ng_w			bigint;
cd_estabelecimento_w	orcamento_custo.cd_estabelecimento%type;
c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_centro_controle,
	cd_natureza_gasto,
	nr_seq_ng,
	cd_estabelecimento
from	orcamento_custo
where	nr_seq_tabela		= nr_seq_tabela_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	cd_centro_controle_w,
	cd_natureza_gasto_w,
	nr_seq_ng_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	select	ie_tipo_gasto
	into STRICT	ie_tipo_gasto_gng_w
	from	natureza_gasto b,
		grupo_natureza_gasto a
	where	a.nr_sequencia			= b.nr_seq_gng
	and	coalesce(a.cd_estabelecimento, cd_estabelecimento_w)	= cd_estabelecimento_w
	and	b.nr_sequencia			= nr_seq_ng_w;
		
	ie_tipo_gasto_w	:= substr(cus_obter_tipo_gasto_centro(cd_estabelecimento_w, cd_centro_controle_w, null, cd_natureza_gasto_w, nr_seq_ng_w),1,1);
	
	if (ie_tipo_gasto_w <> 'M') then
		update	orcamento_custo
		set	ie_tipo_gasto	= ie_tipo_gasto_w
		where	nr_sequencia	= nr_sequencia_w;
	end if;
	end;
end loop;
close c01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_atualizar_tipo_gasto ( cd_estabelecimento_p bigint, nr_seq_tabela_p bigint, cd_tabela_custo_p bigint) FROM PUBLIC;
