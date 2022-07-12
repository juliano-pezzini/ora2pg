-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordem_compra_nf_pendente ( cd_estabelecimento_p bigint, cd_pessoa_solicitante_p text) RETURNS varchar AS $body$
DECLARE


ordem_compra_nf_pendente_w varchar(255);
nr_ordem_compra_w ordem_compra.nr_ordem_compra%type;

c01 CURSOR FOR
SELECT a.nr_ordem_compra
from ordem_compra a,
     nota_fiscal b
where a.nr_ordem_compra = b.nr_ordem_compra
and a.ie_tipo_ordem = 'T'
and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and coalesce(a.nr_seq_motivo_cancel::text, '') = ''
and (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')
and b.ie_tipo_nota = 'ST'
and (b.dt_atualizacao_estoque IS NOT NULL AND b.dt_atualizacao_estoque::text <> '')
and a.cd_estabelecimento = cd_estabelecimento_p
and a.cd_pessoa_solicitante = cd_pessoa_solicitante_p
and coalesce(a.dt_baixa::text, '') = ''

and not exists ( select 1
                 from ordem_compra c,
                      nota_fiscal d
                 where c.nr_ordem_compra = d.nr_ordem_compra
                 and c.ie_tipo_ordem = 'T'
                 and (c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '')
                 and coalesce(c.nr_seq_motivo_cancel::text, '') = ''
                 and (c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
                 and d.ie_tipo_nota <> 'ST'
                 and (d.dt_atualizacao_estoque IS NOT NULL AND d.dt_atualizacao_estoque::text <> '')
                 and c.nr_ordem_compra = a.nr_ordem_compra
                 and d.nr_nota_fiscal = b.nr_nota_fiscal
                 and c.cd_estabelecimento = cd_estabelecimento_p
				 and c.cd_pessoa_solicitante = cd_pessoa_solicitante_p 
				 and coalesce(a.dt_baixa::text, '') = '' );


BEGIN

open c01;
loop
fetch c01 into nr_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

begin
	ordem_compra_nf_pendente_w := substr(ordem_compra_nf_pendente_w || nr_ordem_compra_w || ',', 1, 255);
end;

end loop;

close c01;

return ordem_compra_nf_pendente_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordem_compra_nf_pendente ( cd_estabelecimento_p bigint, cd_pessoa_solicitante_p text) FROM PUBLIC;

