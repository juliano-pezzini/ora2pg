-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_grupo_intercambio ( nr_seq_grupo_p bigint, cd_cgc_empresa_p text, cd_operadora_empresa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_grupo_w		bigint;
cd_grupo_w		varchar(30);


BEGIN

select	max(nr_seq_regra)
into STRICT	nr_seq_grupo_w
from	pls_regra_benef_grupo
where	cd_cgc_empresa	= cd_cgc_empresa_p
and	coalesce(cd_operadora_empresa,0) = coalesce(cd_operadora_empresa_p,0)
and	nr_seq_regra	<> nr_seq_grupo_p;

if (coalesce(nr_seq_grupo_w,0) <> 0) then
	select	max(cd_grupo)
	into STRICT	cd_grupo_w
	from	pls_regra_grupo_inter
	where	nr_sequencia = nr_seq_grupo_w;

	CALL wheb_mensagem_pck.exibir_mensagem_abort( 182719, 'CD_GRUPO='||cd_grupo_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_grupo_intercambio ( nr_seq_grupo_p bigint, cd_cgc_empresa_p text, cd_operadora_empresa_p bigint, nm_usuario_p text) FROM PUBLIC;

