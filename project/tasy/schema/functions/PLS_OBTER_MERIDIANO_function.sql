-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_meridiano (nr_seq_fatura_p ptu_nota_cobranca.nr_seq_fatura%type) RETURNS varchar AS $body$
DECLARE

			
ds_meridiano_w			varchar(3);
cd_cooperativa_w		ptu_fatura.cd_unimed_destino%type;
cd_cgc_w			pls_congenere.cd_cgc%type;
sg_estado_w			pessoa_juridica.sg_estado%type;


BEGIN

-- Padrao brasileiro e -3, Regioes Sul, Sudeste e Nordeste, Goias, Distrito Federal, Tocantins, Amapa e Para
ds_meridiano_w := '-03';

select	lpad(max(cd_unimed_destino),4,'0')
into STRICT	cd_cooperativa_w
from	ptu_fatura
where	nr_sequencia = nr_seq_fatura_p;

select	max(cd_cgc)
into STRICT	cd_cgc_w
from	pls_congenere
where	lpad(cd_cooperativa,4,'0') = cd_cooperativa_w;

select	max(sg_estado)
into STRICT	sg_estado_w
from	pessoa_juridica
where	cd_cgc = cd_cgc_w;

if (sg_estado_w in ('RN','PB','PE','AL')) then
	ds_meridiano_w := '-02';
end if;

if (sg_estado_w in ('MS','MT','RO','AC','AM','RR')) then
	ds_meridiano_w := '-04';
end if;

return	ds_meridiano_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_meridiano (nr_seq_fatura_p ptu_nota_cobranca.nr_seq_fatura%type) FROM PUBLIC;

