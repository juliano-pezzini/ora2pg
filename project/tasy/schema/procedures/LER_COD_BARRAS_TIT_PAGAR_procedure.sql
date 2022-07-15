-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ler_cod_barras_tit_pagar ( nr_ler_bloqueto_p text, nr_titulo_p bigint, ie_converte_barras_p text, cd_barras_p text, nr_seq_banco_escrit_p bigint, cd_banco_p text, nr_usuario_p text) AS $body$
BEGIN


if (coalesce(nr_ler_bloqueto_p,'X') <> 'X') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '')then
	update  titulo_pagar
	set 	nr_bloqueto 	= nr_ler_bloqueto_p
	where 	nr_titulo 	= nr_titulo_p;
end if;

if (ie_converte_barras_p = 'S') then

    if (coalesce(cd_barras_p,'X') <> 'X')and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '')and (nr_seq_banco_escrit_p IS NOT NULL AND nr_seq_banco_escrit_p::text <> '')then
	
	update titulo_pagar_escrit
	set cd_codigo_barras = cd_barras_p
	where nr_titulo 	 = nr_titulo_p
	and nr_seq_escrit 	 = nr_seq_banco_escrit_p;	
	end if;
	
end if;


if (coalesce(cd_banco_p::text, '') = '') then
	CALL definir_banco_tit_escritural('CP' , nr_titulo_p , nr_seq_banco_escrit_p , nr_usuario_p, '');
	

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ler_cod_barras_tit_pagar ( nr_ler_bloqueto_p text, nr_titulo_p bigint, ie_converte_barras_p text, cd_barras_p text, nr_seq_banco_escrit_p bigint, cd_banco_p text, nr_usuario_p text) FROM PUBLIC;

