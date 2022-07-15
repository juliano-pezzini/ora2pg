-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_preco_padrao_proc () AS $body$
DECLARE



nr_sequencia_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_tabela_custo_w		integer;
cd_estabelecimento_w		smallint;
/* Baca criado para utilizar NR_SEQUENCIA como PK */

c01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	cd_tabela_custo,
	cd_estabelecimento
from	preco_padrao_proc
where	coalesce(nr_sequencia::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_tabela_custo_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	nextval('preco_padrao_proc_seq')
	into STRICT	nr_sequencia_w
	;

	update	preco_padrao_proc
	set	nr_sequencia 		= nr_sequencia_w,
		nm_usuario		= 'BacaPrecoPK'
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	cd_tabela_custo	= cd_tabela_custo_w
	and	cd_procedimento	= cd_procedimento_w
	and	ie_origem_proced	= ie_origem_proced_w;
end loop;
close c01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_preco_padrao_proc () FROM PUBLIC;

