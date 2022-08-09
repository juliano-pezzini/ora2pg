-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_empenho_nota_fiscal ( nr_seq_nota_fiscal_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_empenho_orcamento_w			varchar(1);


BEGIN

select	coalesce(max(ie_empenho_orcamento),'N')
into STRICT	ie_empenho_orcamento_w
from	parametro_estoque
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_empenho_orcamento_w = 'S') then
	CALL gerar_empenho_nota_fiscal(nr_seq_nota_fiscal_p,'1',nm_usuario_p);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_empenho_nota_fiscal ( nr_seq_nota_fiscal_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
