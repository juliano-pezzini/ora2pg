-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_info_padrao_nota ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w		bigint;
ie_tipo_nota_w		nota_fiscal.ie_tipo_nota%type;
ie_tipo_frete_w		varchar(15);
cd_cnpj_transportador_w	pessoa_juridica.cd_cgc%type;

C01 CURSOR FOR
	SELECT	cd_cnpj_transportador,
		ie_tipo_frete
	from	regra_padrao_tipo_nf
	where	(ie_entrada = 'S' AND ie_tipo_nota_w = 'EN') or
		(ie_complementar = 'S' AND ie_tipo_nota_w = 'NC') or
		(ie_entrada_pf = 'S' AND ie_tipo_nota_w = 'EF') or
		(ie_entrada_ep = 'S' AND ie_tipo_nota_w = 'EP') or
		(ie_saida_pf = 'S' AND ie_tipo_nota_w = 'SF') or
		(ie_saida_digitacao = 'S' AND ie_tipo_nota_w = 'SD') or
		(ie_saida_emissao = 'S' AND ie_tipo_nota_w = 'SE');


BEGIN

select	count(1)
into STRICT	qt_existe_w
from	regra_padrao_tipo_nf;

if (qt_existe_w > 0) then

	select	max(ie_tipo_nota)
	into STRICT	ie_tipo_nota_w
	from	nota_fiscal
	where	nr_sequencia = nr_sequencia_p;

	open C01;
	loop
	fetch C01 into
		cd_cnpj_transportador_w,
		ie_tipo_frete_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (coalesce(cd_cnpj_transportador_w, '0') <> '0') then

			insert into nota_fiscal_transportadora(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_nota,
				cd_cnpj,
				ie_tipo_frete)
			values (	nextval('nota_fiscal_transportadora_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_sequencia_p,
				cd_cnpj_transportador_w,
				ie_tipo_frete_w);
		end if;
		end;
	end loop;
	close C01;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_info_padrao_nota ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

