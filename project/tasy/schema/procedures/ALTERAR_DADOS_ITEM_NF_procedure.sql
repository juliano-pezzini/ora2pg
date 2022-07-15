-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_dados_item_nf (nm_usuario_p text, nr_seq_nota_p bigint, nr_item_nf_p bigint, ds_complemento_p text, cd_natureza_operacao_p bigint) AS $body$
BEGIN

if (coalesce(ds_complemento_p, 'XX') <> 'XX') then
	CALL alterar_complemento_item_nota(	nm_usuario_p,
					nr_seq_nota_p,
					nr_item_nf_p,
					ds_complemento_p);

end if;

if (coalesce(cd_natureza_operacao_p, 0) <> 0) then
	CALL alterar_natureza_item_nf(	nr_item_nf_p,
					nr_seq_nota_p,
					cd_natureza_operacao_p,
					nm_usuario_p);
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_dados_item_nf (nm_usuario_p text, nr_seq_nota_p bigint, nr_item_nf_p bigint, ds_complemento_p text, cd_natureza_operacao_p bigint) FROM PUBLIC;

