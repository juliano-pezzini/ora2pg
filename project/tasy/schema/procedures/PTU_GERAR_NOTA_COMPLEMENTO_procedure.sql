-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_nota_complemento ( nr_seq_cobranca_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
qt_regra_w		integer;
nr_seq_conta_cobr_w	ptu_nota_cobranca.nr_seq_conta%type;
ie_tipo_guia_w		pls_conta.ie_tipo_guia%type;


BEGIN

select	count(1)
into STRICT	qt_regra_w
from	pls_info_ptu_compl_linha LIMIT 1;

if (coalesce(qt_regra_w,0) = 0) then
	CALL ptu_gerar_nota_compl_padrao(nr_seq_cobranca_p, nm_usuario_p);
else
	select	max(nr_seq_conta)
	into STRICT	nr_seq_conta_cobr_w
	from	ptu_nota_cobranca
	where	nr_sequencia = nr_seq_cobranca_p;
	
	select	max(ie_tipo_guia)
	into STRICT	ie_tipo_guia_w
	from	pls_conta
	where	nr_sequencia = nr_seq_conta_cobr_w;
	
	select	count(1)
	into STRICT	qt_regra_w
	from	pls_info_ptu_compl_linha	b,
		pls_info_ptu_complemento	a
	where	a.nr_sequencia			= b.nr_seq_regra
	and	a.ie_tipo_guia			= ie_tipo_guia_w;
	
	if (qt_regra_w > 0) then
		CALL ptu_gerar_nota_compl_regra(nr_seq_cobranca_p, nm_usuario_p);
	else
		CALL ptu_gerar_nota_compl_padrao(nr_seq_cobranca_p, nm_usuario_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_nota_complemento ( nr_seq_cobranca_p bigint, nm_usuario_p text) FROM PUBLIC;
