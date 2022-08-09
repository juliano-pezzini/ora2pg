-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_capac_cc_html (cd_estabelecimento_p bigint, cd_centro_controle_p bigint, nr_seq_tabela_p bigint, ie_tipo_centro_p text, nm_usuario_p text) AS $body$
DECLARE


cd_tabela_custo_w	bigint;
cd_centro_controle_w	bigint;


BEGIN

cd_tabela_custo_w := obter_tab_custo_html(nr_seq_tabela_p);

if (ie_tipo_centro_p = 'T') then
	cd_centro_controle_w := 0;
else
	cd_centro_controle_w := cd_centro_controle_p;
end if;

CALL gerar_capac_centro_controle(cd_estabelecimento_p,
				cd_tabela_custo_w,
				cd_centro_controle_w,
				nr_seq_tabela_p,
				nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_capac_cc_html (cd_estabelecimento_p bigint, cd_centro_controle_p bigint, nr_seq_tabela_p bigint, ie_tipo_centro_p text, nm_usuario_p text) FROM PUBLIC;
